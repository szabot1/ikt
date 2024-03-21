using System;
using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace backend.Models;

public partial class OfferStock
{
    public string Id { get; set; } = null!;

    public string OfferId { get; set; } = null!;

    public string Item { get; set; } = null!;

    public bool IsLocked { get; set; }

    public DateTime CreatedAt { get; set; }

    [JsonIgnore]
    public virtual Offer Offer { get; set; } = null!;
}
