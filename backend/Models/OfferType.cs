using System;
using System.Collections.Generic;

namespace backend.Models;

public partial class OfferType
{
    public string Id { get; set; } = null!;

    public string Slug { get; set; } = null!;

    public string Name { get; set; } = null!;

    public string Description { get; set; } = null!;

    public string ClaimInstructions { get; set; } = null!;

    public DateTime CreatedAt { get; set; }

    public virtual ICollection<Offer> Offers { get; set; } = new List<Offer>();
}
