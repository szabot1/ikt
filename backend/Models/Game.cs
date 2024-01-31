using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;
using Microsoft.EntityFrameworkCore;

namespace backend.Models;

[Table("games")]
[Index("Name", Name = "games_name_idx")]
[Index("Slug", Name = "games_slug_idx")]
[Index("Slug", Name = "games_slug_key", IsUnique = true)]
public partial class Game
{
    [Key]
    [Column("id")]
    public string Id { get; set; } = null!;

    [Column("slug")]
    public string Slug { get; set; } = null!;

    [Column("name")]
    public string Name { get; set; } = null!;

    [Column("description")]
    public string Description { get; set; } = null!;

    [Required]
    [Column("is_active")]
    public bool? IsActive { get; set; }

    [Column("is_featured")]
    public bool IsFeatured { get; set; }

    [Column("created_at", TypeName = "timestamp without time zone")]
    public DateTime CreatedAt { get; set; }

    [Column("updated_at", TypeName = "timestamp without time zone")]
    public DateTime UpdatedAt { get; set; }

    [InverseProperty("Game")]
    [JsonPropertyName("images")]
    public virtual ICollection<GameImage> GameImages { get; set; } = new List<GameImage>();

    [InverseProperty("Game")]
    [JsonPropertyName("tags")]
    public virtual ICollection<GameTag> GameTags { get; set; } = new List<GameTag>();

    [InverseProperty("Game")]
    [JsonIgnore]
    public virtual ICollection<Offer> Offers { get; set; } = new List<Offer>();

    [InverseProperty("Game")]
    [JsonIgnore]
    public virtual ICollection<Order> Orders { get; set; } = new List<Order>();
}
