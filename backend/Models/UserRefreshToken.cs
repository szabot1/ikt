using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;
using Microsoft.EntityFrameworkCore;

namespace backend.Models;

[Table("user_refresh_tokens")]
[Index("UserId", Name = "user_refresh_tokens_user_id_idx")]
public partial class UserRefreshToken
{
    [Key]
    [Column("token")]
    public string Token { get; set; } = null!;

    [Column("user_id")]
    public string UserId { get; set; } = null!;

    [Column("created_at")]
    public DateTime CreatedAt { get; set; }

    [ForeignKey("UserId")]
    [InverseProperty("UserRefreshToken")]
    [JsonIgnore]
    public virtual User User { get; set; } = null!;
}
