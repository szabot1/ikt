using System;
using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace backend.Models;

public partial class UserExperience
{
    public string UserId { get; set; } = null!;

    public int Experience { get; set; }

    [JsonIgnore]
    public virtual User User { get; set; } = null!;

    public UserExperience NormalizeForJson()
    {
        User = null!;
        return this;
    }
}
