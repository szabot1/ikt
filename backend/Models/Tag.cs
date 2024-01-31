using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;
using Microsoft.EntityFrameworkCore;

namespace backend.Models;

[Table("tags")]
[Index("Name", Name = "tags_name_key", IsUnique = true)]
public partial class Tag
{
    [Key]
    [Column("id")]
    public string Id { get; set; } = null!;

    [Column("name")]
    public string Name { get; set; } = null!;

    [Column("created_at", TypeName = "timestamp without time zone")]
    public DateTime CreatedAt { get; set; }

    [InverseProperty("Tag")]
    [JsonIgnore]
    public virtual ICollection<GameTag> GameTags { get; set; } = new List<GameTag>();
}
