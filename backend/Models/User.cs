using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace backend.Models;

[Table("users")]
[Index("Email", Name = "users_email_idx")]
[Index("Email", Name = "users_email_key", IsUnique = true)]
[Index("StripeCustomerId", Name = "users_stripe_customer_id_idx")]
[Index("Username", Name = "users_username_idx")]
[Index("Username", Name = "users_username_key", IsUnique = true)]
public partial class User
{
    [Key]
    [Column("id")]
    public string Id { get; set; } = null!;

    [Column("email")]
    public string Email { get; set; } = null!;

    [Column("username")]
    public string Username { get; set; } = null!;

    [Column("password")]
    public string Password { get; set; } = null!;

    [Column("stripe_customer_id")]
    public string? StripeCustomerId { get; set; }

    [Column("created_at", TypeName = "timestamp without time zone")]
    public DateTime CreatedAt { get; set; }

    [Column("updated_at", TypeName = "timestamp without time zone")]
    public DateTime UpdatedAt { get; set; }

    [InverseProperty("User")]
    public virtual ICollection<Order> Orders { get; set; } = new List<Order>();

    [InverseProperty("User")]
    public virtual ICollection<Seller> Sellers { get; set; } = new List<Seller>();

    [InverseProperty("User")]
    public virtual UserExperience? UserExperience { get; set; }

    [InverseProperty("User")]
    public virtual UserSocial? UserSocial { get; set; }
}
