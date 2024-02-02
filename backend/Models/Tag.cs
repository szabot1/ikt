using System;
using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace backend.Models;

public partial class Tag
{
    public string Id { get; set; } = null!;

    public string Name { get; set; } = null!;

    public DateTime CreatedAt { get; set; }

    [JsonIgnore]
    public virtual ICollection<GameTag> GameTags { get; set; } = new List<GameTag>();
}
