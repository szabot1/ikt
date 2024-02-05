using System.Security.Claims;
using System.Text.Encodings.Web;
using backend.Data;
using backend.Utils;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.Extensions.Options;

namespace backend.Auth;

public class JwtAuthorization : JwtBearerHandler
{
    private readonly GameStoreContext _dbContext;
    private readonly JwtConfig _jwtConfig;

    public JwtAuthorization(IOptions<JwtConfig> jwtConfig, GameStoreContext gameStoreContext,
                            IOptionsMonitor<JwtBearerOptions> options,
                            ILoggerFactory logger, UrlEncoder encoder, ISystemClock clock)
                            : base(options, logger, encoder, clock)
    {
        _jwtConfig = jwtConfig.Value;
        _dbContext = gameStoreContext;
    }

    protected override async Task<AuthenticateResult> HandleAuthenticateAsync()
    {
        if (!Context.Request.Headers.TryGetValue("Authorization", out var authorizationHeaderValues))
        {
            return AuthenticateResult.Fail("Authorization header not found.");
        }

        var authorizationHeader = authorizationHeaderValues.FirstOrDefault();
        if (string.IsNullOrEmpty(authorizationHeader) || !authorizationHeader.StartsWith("Bearer "))
        {
            return AuthenticateResult.Fail("Bearer token not found in Authorization header.");
        }

        var token = authorizationHeader["Bearer ".Length..].Trim();

        try
        {
            var userId = Token.GetUserIdFromAccessToken(_jwtConfig, token);
            var user = await _dbContext.Users.FindAsync(userId);

            if (user == null)
            {
                return AuthenticateResult.Fail("User not found.");
            }

            Context.Items.Add("User", user);

            var claims = new List<Claim>
            {
                new(ClaimTypes.NameIdentifier, user.Id),
                new(ClaimTypes.Name, user.Username),
                new(ClaimTypes.Email, user.Email),
                new(ClaimTypes.Role, user.Role.ToString())
            };

            var identity = new ClaimsIdentity(claims, Scheme.Name);
            var principal = new ClaimsPrincipal(identity);

            var ticket = new AuthenticationTicket(principal, Scheme.Name);
            return AuthenticateResult.Success(ticket);
        }
        catch
        {
            return AuthenticateResult.Fail("Invalid token.");
        }
    }
}