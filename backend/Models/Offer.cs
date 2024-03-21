using System;
using System.Collections.Generic;
using System.Text.Json.Serialization;

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

    [JsonIgnore]
    public virtual ICollection<Order> Orders { get; set; } = new List<Order>();

    [JsonIgnore]
    public virtual Seller Seller { get; set; } = null!;

    public virtual OfferType TypeNavigation { get; set; } = null!;

    [JsonIgnore]
    public virtual ICollection<OfferStock> OfferStocks { get; set; } = new List<OfferStock>();

    public Offer NormalizeForJson()
    {
        if (Game != null)
        {
            Game = Game.NormalizeForJson();
        }

        return this;
    }
}
