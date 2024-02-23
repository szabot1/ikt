using System;
using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace backend.Models;

public partial class User
{
    public string Id { get; set; } = null!;

    public string Email { get; set; } = null!;

    public string Username { get; set; } = null!;

    [JsonIgnore]
    public string Password { get; set; } = null!;

    public UserRole Role { get; set; } = UserRole.user;

    public string? StripeCustomerId { get; set; }

    public DateTime CreatedAt { get; set; }

    public DateTime UpdatedAt { get; set; }

    [JsonIgnore]
    public virtual ICollection<Order> Orders { get; set; } = new List<Order>();

    [JsonIgnore]
    public virtual ICollection<Seller> Sellers { get; set; } = new List<Seller>();

    [JsonIgnore]
    public virtual UserExperience? UserExperience { get; set; }

    [JsonIgnore]
    public virtual ICollection<UserRefreshToken> UserRefreshTokens { get; set; } = new List<UserRefreshToken>();

    [JsonPropertyName("social")]
    public virtual UserSocial? UserSocial { get; set; }
}
