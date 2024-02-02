using System;
using System.Collections.Generic;

namespace backend.Models;

public partial class Offer
{
    public string Id { get; set; } = null!;

    public string GameId { get; set; } = null!;

    public string SellerId { get; set; } = null!;

    public int Price { get; set; }

    public bool? IsActive { get; set; }

    public string Type { get; set; } = null!;

    public DateTime CreatedAt { get; set; }

    public DateTime UpdatedAt { get; set; }

    public virtual Game Game { get; set; } = null!;

    public virtual ICollection<Order> Orders { get; set; } = new List<Order>();

    public virtual Seller Seller { get; set; } = null!;

    public virtual OfferType TypeNavigation { get; set; } = null!;
}
