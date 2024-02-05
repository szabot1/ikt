using System.Security.Cryptography;
using backend.Data;
using backend.Models;
using JWT.Algorithms;
using JWT.Builder;

namespace backend.Utils;

public class Token
{
    public static string GenerateRefreshToken()
    {
        var bytes = new byte[32];
        using var rng = RandomNumberGenerator.Create();
        rng.GetBytes(bytes);
        return Convert.ToBase64String(bytes);
    }

    public static string GenerateAccessToken(JwtConfig jwtConfig, User user)
    {
        return JwtBuilder.Create()
            .WithAlgorithm(new HMACSHA256Algorithm())
            .WithSecret(jwtConfig.Key)
            .AddClaim("exp", DateTimeOffset.UtcNow.AddMinutes(15).ToUnixTimeSeconds())
            .AddClaim("sub", user.Id)
            .AddClaim("username", user.Username)
            .AddClaim("email", user.Email)
            .Encode();
    }
}