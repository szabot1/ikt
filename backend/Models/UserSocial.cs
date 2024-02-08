using System;
using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace backend.Models;

public partial class UserSocial
{
    public string UserId { get; set; } = null!;

    public string? Discord { get; set; }

    public string? Steam { get; set; }

    public string? Ubisoft { get; set; }

    public string? Epic { get; set; }

    public string? Origin { get; set; }

    public DateTime CreatedAt { get; set; }

    public DateTime UpdatedAt { get; set; }

    [JsonIgnore]
    public virtual User User { get; set; } = null!;

    public UserSocial NormalizeForJson()
    {
        User = null!;
        return this;
    }
}
