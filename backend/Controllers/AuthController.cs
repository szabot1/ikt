using System.Net.Http.Headers;
using backend.Data;
using backend.Models;
using backend.Utils;
using Isopoh.Cryptography.Argon2;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using Stripe;
using Visus.Cuid;
using static backend.Utils.Validation;

namespace backend.Controllers;

[Route("api/auth")]
[ApiController]
public class AuthController : ControllerBase
{
    private static readonly List<IValidator> EmailValidators = new()
    {
        Validation.Email
    };

    private static readonly List<IValidator> UsernameValidators = new()
    {
        MinLength(3, "Username"),
        MaxLength(32, "Username"),
        Matches("^[a-zA-Z0-9_]+$", "Username can only contain letters, numbers, and underscores")
    };

    private static readonly List<IValidator> PasswordValidators = new()
    {
        MinLength(8, "Password"),
        MaxLength(64, "Password"),
        HasLowercase("Password"),
        HasUppercase("Password"),
        HasDigit("Password"),
        HasSpecial("Password")
    };

    private static readonly CustomerService _customerService = new();

    private readonly JwtConfig _jwtConfig;
    private readonly StripeConfig _stripeConfig;
    private readonly EmailConfig _emailConfig;

    public AuthController(IOptions<JwtConfig> jwtConfig, IOptions<StripeConfig> stripeConfig, IOptions<EmailConfig> emailConfig)
    {
        _jwtConfig = jwtConfig.Value;
        _stripeConfig = stripeConfig.Value;
        _emailConfig = emailConfig.Value;

        StripeConfiguration.ApiKey = _stripeConfig.SecretKey;
    }

    [Authorize]
    [HttpPost("logout")]
    public async Task<IActionResult> Logout(
        [FromServices] GameStoreContext context,
        [FromBody] LogoutRequest request)
    {
        var token = await context.UserRefreshTokens
            .FirstOrDefaultAsync(token => token.Token == request.RefreshToken);

        if (token == null)
        {
            return Unauthorized(new
            {
                success = false,
                errors = new Dictionary<string, List<string>>
                {
                    { "refreshToken", new List<string> { "Invalid refresh token" } }
                }
            });
        }

        if (token.UserId != ((User)HttpContext.Items["User"]!).Id)
        {
            return Unauthorized(new
            {
                success = false,
                errors = new Dictionary<string, List<string>>
                {
                    { "refreshToken", new List<string> { "Invalid refresh token" } }
                }
            });
        }

        try
        {
            context.UserRefreshTokens.Remove(token);
            await context.SaveChangesAsync();

            return Ok(new { success = true });
        }
        catch (Exception e)
        {
            return StatusCode(500, new
            {
                success = false,
                errors = new Dictionary<string, List<string>>
                {
                    { "server", new List<string> { e.Message } }
                }
            });
        }
    }

    public record LogoutRequest(string AccessToken, string RefreshToken);

    [Authorize]
    [HttpGet("user-info")]
    public async Task<IActionResult> UserInfo([FromServices] GameStoreContext context)
    {
        var user = (User)HttpContext.Items["User"]!;

        var experience = await context.UserExperiences
            .FirstOrDefaultAsync(experience => experience.UserId == user.Id);

        var social = await context.UserSocials
            .FirstOrDefaultAsync(social => social.UserId == user.Id);

        return Ok(new
        {
            id = user.Id,
            email = user.Email,
            username = user.Username,
            role = user.Role.ToString(),
            experience = experience!.NormalizeForJson(),
            social = social!.NormalizeForJson()
        });
    }

    [HttpPost("register")]
    public async Task<IActionResult> Register(
        [FromServices] GameStoreContext context,
        [FromBody] RegisterRequest request)
    {
        var errors = new Dictionary<string, List<string>>
        {
            { "email", Validate(request.Email, EmailValidators) },
            { "username", Validate(request.Username, UsernameValidators) },
            { "password", Validate(request.Password, PasswordValidators) }
        };

        if (await context.Users.AnyAsync(user => user.Email == request.Email))
        {
            errors["email"].Add("Email is already in use");
        }

        if (await context.Users.AnyAsync(user => user.Username == request.Username))
        {
            errors["username"].Add("Username is already in use");
        }

        if (errors.Values.Any(list => list.Count > 0))
        {
            return BadRequest(new
            {
                success = false,
                errors
            });
        }

        if (request.EmailCode == "")
        {
            // If no code is provided, send a new email

            var token = new EmailToken
            {
                Token = Utils.Token.GenerateEmailOneTimeCode(),
                Email = request.Email,
                CreatedAt = DateTime.SpecifyKind(DateTime.UtcNow, DateTimeKind.Unspecified)
            };

            try
            {
                await Utils.Email.SendEmailAsync(
                    _emailConfig,
                    request.Email,
                    "Game Key Store Email Verification",
                    $@"<h1>Hello!</h1>
                <p>Someone (hopefully you) has requested to register an account on our store.</p>
                <p>If this was you, please use the following code to verify your email address:</p>
                <h2>{token.Token}</h2>
                <p>If this wasn't you, please ignore this email.</p>
                ",
                    Utils.Email.EmailType.Accounts);

                context.EmailTokens.RemoveRange(context.EmailTokens.Where(t => t.Email == request.Email));
                context.EmailTokens.Add(token);
                await context.SaveChangesAsync();

                return StatusCode(418);
            }
            catch (Exception e)
            {
                Console.WriteLine(e.ToString());
                return StatusCode(500, new
                {
                    success = false,
                    errors = new Dictionary<string, List<string>>
                {
                    { "server", new List<string> { e.Message } }
                }
                });

            }
        }

        var emailToken = await context.EmailTokens.FirstOrDefaultAsync(token => token.Email == request.Email);

        if (emailToken == null || emailToken.Token != request.EmailCode || emailToken.CreatedAt.AddHours(1) < DateTime.UtcNow)
        {
            // If a code is provided, but it's invalid, return an error

            if (emailToken != null && emailToken.CreatedAt.AddHours(1) < DateTime.UtcNow)
            {
                // If the code is expired, remove it from the database

                context.EmailTokens.Remove(emailToken);
                await context.SaveChangesAsync();
            }

            return BadRequest(new
            {
                success = false,
                errors = new Dictionary<string, List<string>>
                {
                    { "emailCode", new List<string> { "Invalid email code" } }
                }
            });
        }

        context.EmailTokens.Remove(emailToken); // Remove the email token from the database

        try
        {
            var userId = new Cuid2().ToString();

            // Create a new Stripe customer
            var customerOptions = new CustomerCreateOptions
            {
                Email = request.Email,
                Description = "IKT Project Customer",
                Name = request.Username
            };

            customerOptions.Metadata = new Dictionary<string, string>
            {
                { "user_id", userId }
            };

            var requestOptions = new RequestOptions
            {
                ApiKey = _stripeConfig.SecretKey
            };

            var stripeCustomer = await _customerService.CreateAsync(customerOptions, requestOptions);

            // Create a new user
            var user = new User
            {
                Id = userId,
                Email = request.Email,
                Username = request.Username,
                Password = Argon2.Hash(request.Password),
                CreatedAt = DateTime.SpecifyKind(DateTime.UtcNow, DateTimeKind.Unspecified),
                UpdatedAt = DateTime.SpecifyKind(DateTime.UtcNow, DateTimeKind.Unspecified),
                StripeCustomerId = stripeCustomer.Id
            };

            context.Users.Add(user);

            // Create a new user experience
            var experience = new UserExperience
            {
                UserId = user.Id,
                Experience = 0
            };

            context.UserExperiences.Add(experience);

            // Create a new user social
            var social = new UserSocial
            {
                UserId = user.Id,
                CreatedAt = DateTime.SpecifyKind(DateTime.UtcNow, DateTimeKind.Unspecified),
                UpdatedAt = DateTime.SpecifyKind(DateTime.UtcNow, DateTimeKind.Unspecified)
            };

            context.UserSocials.Add(social);

            await context.SaveChangesAsync();

            return Ok(new { success = true });
        }
        catch (Exception e)
        {
            Console.WriteLine(e.ToString());
            return StatusCode(500, new
            {
                success = false,
                errors = new Dictionary<string, List<string>>
                {
                    { "server", new List<string> { e.Message
} }
                }
            });
        }
    }

    public record RegisterRequest(string Email, string EmailCode, string Username, string Password);

    [HttpPost("login")]
    public async Task<IActionResult> Login(
        [FromServices] GameStoreContext context,
        [FromBody] LoginRequest request)
    {
        var user = await context.Users.FirstOrDefaultAsync(user => user.Email == request.Email);

        if (user == null)
        {
            return Unauthorized(new
            {
                success = false,
                errors = new Dictionary<string, List<string>>
                {
                    { "email", new List<string> { "User not found" } }
                }
            });
        }

        if (!Argon2.Verify(user.Password, request.Password))
        {
            return Unauthorized(new
            {
                success = false,
                errors = new Dictionary<string, List<string>>
                {
                    { "password", new List<string> { "Invalid password" } }
                }
            });
        }

        try
        {
            var refreshToken = Utils.Token.GenerateRefreshToken();
            await context.UserRefreshTokens.AddAsync(new UserRefreshToken
            {
                Token = refreshToken,
                UserId = user.Id,
                CreatedAt = DateTime.SpecifyKind(DateTime.UtcNow, DateTimeKind.Unspecified)
            });
            await context.SaveChangesAsync();

            var accessToken = Utils.Token.GenerateAccessToken(_jwtConfig, user);

            return Ok(new
            {
                success = true,
                accessToken,
                refreshToken
            });
        }
        catch (Exception e)
        {
            return StatusCode(500, new
            {
                success = false,
                errors = new Dictionary<string, List<string>>
                {
                    { "server", new List<string> { e.Message } }
                }
            });
        }
    }

    public record LoginRequest(string Email, string Password);

    [HttpPost("refresh")]
    public async Task<IActionResult> Refresh(
        [FromServices] GameStoreContext context,
        [FromBody] RefreshRequest request)
    {
        var token = await context.UserRefreshTokens
            .Include(token => token.User)
            .FirstOrDefaultAsync(token => token.Token == request.RefreshToken);

        if (token == null)
        {
            return Unauthorized(new
            {
                success = false,
                errors = new Dictionary<string, List<string>>
                {
                    { "refreshToken", new List<string> { "Invalid refresh token" } }
                }
            });
        }

        try
        {
            var accessToken = Utils.Token.GenerateAccessToken(_jwtConfig, token.User);

            return Ok(new
            {
                success = true,
                accessToken
            });
        }
        catch (Exception e)
        {
            return StatusCode(500, new
            {
                success = false,
                errors = new Dictionary<string, List<string>>
                {
                    { "server", new List<string> { e.Message } }
                }
            });
        }
    }

    public record RefreshRequest(string RefreshToken);
}