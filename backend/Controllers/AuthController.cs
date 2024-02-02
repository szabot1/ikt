using backend.Data;
using backend.Models;
using backend.Utils;
using Isopoh.Cryptography.Argon2;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Visus.Cuid;
using static backend.Utils.Validation;

namespace backend.Controllers;

[Route("api/auth")]
[ApiController]
public class AuthController : ControllerBase
{
    private static readonly List<IValidator> EmailValidators = new()
    {
        Required,
        Email
    };

    private static readonly List<IValidator> UsernameValidators = new()
    {
        Required,
        MinLength(3),
        MaxLength(32),
        Matches("^[a-zA-Z0-9_]+$", "Username can only contain letters, numbers, and underscores")
    };

    private static readonly List<IValidator> PasswordValidators = new()
    {
        Required,
        MinLength(8),
        MaxLength(64),
        HasLowercase,
        HasUppercase,
        HasDigit,
        HasSpecial
    };

    private readonly JwtConfig _jwtConfig;

    public AuthController(JwtConfig jwtConfig)
    {
        _jwtConfig = jwtConfig;
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

        try
        {
            var user = new User
            {
                Id = new Cuid2().ToString(),
                Email = request.Email,
                Username = request.Username,
                Password = Argon2.Hash(request.Password),
                CreatedAt = DateTime.UtcNow,
                UpdatedAt = DateTime.UtcNow
            };

            context.Users.Add(user);
            await context.SaveChangesAsync();

            return Ok();
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

    public record RegisterRequest(string Email, string Username, string Password);

    [HttpPost("login")]
    public async Task<IActionResult> Login(
        [FromServices] GameStoreContext context,
        [FromBody] LoginRequest request)
    {
        var user = await context.Users.FirstOrDefaultAsync(user => user.Email == request.Email);

        if (user == null || !Argon2.Verify(user.Password, request.Password))
        {
            if (user == null)
                // This is to prevent user enumeration attacks by making sure
                //  the request takes the same amount of time regardless of whether the user exists.
                Argon2.Verify("password", "password");

            return Unauthorized(new
            {
                success = false,
                errors = new Dictionary<string, List<string>>
                {
                    { "email", new List<string> { "Invalid email or password" } },
                    { "password", new List<string> { "Invalid email or password" } }
                }
            });
        }

        try
        {
            var refreshToken = Token.GenerateRefreshToken();
            await context.UserRefreshTokens.AddAsync(new UserRefreshToken
            {
                Token = refreshToken,
                UserId = user.Id,
                CreatedAt = DateTime.UtcNow
            });
            await context.SaveChangesAsync();

            var accessToken = Token.GenerateAccessToken(_jwtConfig, user);

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
            var accessToken = Token.GenerateAccessToken(_jwtConfig, token.User);

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