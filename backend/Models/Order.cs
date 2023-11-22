using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace backend.Models;

[Table("orders")]
[Index("GameId", Name = "orders_game_id_idx")]
[Index("StripePaymentIntentId", Name = "orders_stripe_payment_intent_id_idx")]
[Index("UserId", Name = "orders_user_id_idx")]
public partial class Order
{
    [Key]
    [Column("id")]
    public string Id { get; set; } = null!;

    [Column("user_id")]
    public string UserId { get; set; } = null!;

    [Column("game_id")]
    public string GameId { get; set; } = null!;

    [Column("offer_id")]
    public string OfferId { get; set; } = null!;

    [Column("stripe_payment_intent_id")]
    public string StripePaymentIntentId { get; set; } = null!;

    [Column("created_at", TypeName = "timestamp without time zone")]
    public DateTime CreatedAt { get; set; }

    [ForeignKey("GameId")]
    [InverseProperty("Orders")]
    public virtual Game Game { get; set; } = null!;

    [ForeignKey("OfferId")]
    [InverseProperty("Orders")]
    public virtual Offer Offer { get; set; } = null!;

    [ForeignKey("UserId")]
    [InverseProperty("Orders")]
    public virtual User User { get; set; } = null!;
}
