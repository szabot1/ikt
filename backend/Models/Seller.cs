using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace backend.Models;

[Table("sellers")]
[Index("DisplayName", Name = "sellers_display_name_idx")]
[Index("Slug", Name = "sellers_slug_idx")]
[Index("Slug", Name = "sellers_slug_key", IsUnique = true)]
[Index("UserId", Name = "sellers_user_id_idx")]
public partial class Seller
{
    [Key]
    [Column("id")]
    public string Id { get; set; } = null!;

    [Column("user_id")]
    public string UserId { get; set; } = null!;

    [Column("slug")]
    public string Slug { get; set; } = null!;

    [Column("display_name")]
    public string DisplayName { get; set; } = null!;

    [Column("image_url")]
    public string ImageUrl { get; set; } = null!;

    [Column("is_verified")]
    public bool IsVerified { get; set; }

    [Column("created_at", TypeName = "timestamp without time zone")]
    public DateTime CreatedAt { get; set; }

    [Column("updated_at", TypeName = "timestamp without time zone")]
    public DateTime UpdatedAt { get; set; }

    [InverseProperty("Seller")]
    public virtual ICollection<Offer> Offers { get; set; } = new List<Offer>();

    [ForeignKey("UserId")]
    [InverseProperty("Sellers")]
    public virtual User User { get; set; } = null!;
}
