using System;
using System.Collections.Generic;

namespace backend.Models;

public partial class Order
{
    public string Id { get; set; } = null!;

    public string UserId { get; set; } = null!;

    public string GameId { get; set; } = null!;

    public string OfferId { get; set; } = null!;

    public string StripePaymentIntentId { get; set; } = null!;

    public DateTime CreatedAt { get; set; }

    public virtual Game Game { get; set; } = null!;

    public virtual Offer Offer { get; set; } = null!;

    public virtual User User { get; set; } = null!;
}
