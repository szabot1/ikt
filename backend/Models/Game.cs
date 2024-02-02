using System;
using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace backend.Models;

public partial class Game
{
    public string Id { get; set; } = null!;

    public string Slug { get; set; } = null!;

    public string Name { get; set; } = null!;

    public string Description { get; set; } = null!;

    public bool? IsActive { get; set; }

    public bool IsFeatured { get; set; }

    public DateTime CreatedAt { get; set; }

    public DateTime UpdatedAt { get; set; }

    [JsonPropertyName("images")]
    public virtual ICollection<GameImage> GameImages { get; set; } = new List<GameImage>();

    [JsonPropertyName("tags")]
    public virtual ICollection<GameTag> GameTags { get; set; } = new List<GameTag>();

    [JsonIgnore]
    public virtual ICollection<Offer> Offers { get; set; } = new List<Offer>();

    [JsonIgnore]
    public virtual ICollection<Order> Orders { get; set; } = new List<Order>();

    public Game NormalizeForJson()
    {
        if (GameImages != null)
        {
            GameImages = GameImages.Select(gameImage => gameImage.WithoutGame()).ToList();
        }

        if (GameTags != null)
        {
            GameTags = GameTags.Select(gameTag => gameTag.WithoutGame()).ToList();
        }

        return this;
    }
}
