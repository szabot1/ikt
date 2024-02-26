using System;
using System.Collections.Generic;

namespace backend.Models;

public partial class Seller
{
    public string Id { get; set; } = null!;

    public string UserId { get; set; } = null!;

    public string Slug { get; set; } = null!;

    public string DisplayName { get; set; } = null!;

    public string ImageUrl { get; set; } = null!;

    public bool IsVerified { get; set; }
    public bool IsClosed { get; set; }

    public DateTime CreatedAt { get; set; }

    public DateTime UpdatedAt { get; set; }

    public virtual ICollection<Offer> Offers { get; set; } = new List<Offer>();

    public virtual User User { get; set; } = null!;

    public Seller NormalizeForJson()
    {
        Offers = null!;
        User = null!;

        return this;
    }
}
