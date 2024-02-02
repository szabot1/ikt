using System;
using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace backend.Models;

public partial class UserRefreshToken
{
    public string Token { get; set; } = null!;

    public string UserId { get; set; } = null!;

    public DateTime CreatedAt { get; set; }

    [JsonIgnore]
    public virtual User User { get; set; } = null!;
}
