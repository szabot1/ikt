using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace backend.Models;

[Table("offers")]
[Index("GameId", Name = "offers_game_id_idx")]
[Index("Price", Name = "offers_price_idx")]
[Index("SellerId", Name = "offers_seller_id_idx")]
public partial class Offer
{
    [Key]
    [Column("id")]
    public string Id { get; set; } = null!;

    [Column("game_id")]
    public string GameId { get; set; } = null!;

    [Column("seller_id")]
    public string SellerId { get; set; } = null!;

    [Column("price")]
    public int Price { get; set; }

    [Required]
    [Column("is_active")]
    public bool? IsActive { get; set; }

    [Column("type")]
    public string Type { get; set; } = null!;

    [Column("created_at", TypeName = "timestamp without time zone")]
    public DateTime CreatedAt { get; set; }

    [Column("updated_at", TypeName = "timestamp without time zone")]
    public DateTime UpdatedAt { get; set; }

    [ForeignKey("GameId")]
    [InverseProperty("Offers")]
    public virtual Game Game { get; set; } = null!;

    [InverseProperty("Offer")]
    public virtual ICollection<Order> Orders { get; set; } = new List<Order>();

    [ForeignKey("SellerId")]
    [InverseProperty("Offers")]
    public virtual Seller Seller { get; set; } = null!;

    [ForeignKey("Type")]
    [InverseProperty("Offers")]
    public virtual OfferType TypeNavigation { get; set; } = null!;
}
