using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace backend.Models;

[Table("user_social")]
[Index("UserId", Name = "user_social_user_id_idx")]
public partial class UserSocial
{
    [Key]
    [Column("user_id")]
    public string UserId { get; set; } = null!;

    [Column("discord")]
    public string? Discord { get; set; }

    [Column("steam")]
    public string? Steam { get; set; }

    [Column("ubisoft")]
    public string? Ubisoft { get; set; }

    [Column("epic")]
    public string? Epic { get; set; }

    [Column("origin")]
    public string? Origin { get; set; }

    [Column("created_at", TypeName = "timestamp without time zone")]
    public DateTime CreatedAt { get; set; }

    [Column("updated_at", TypeName = "timestamp without time zone")]
    public DateTime UpdatedAt { get; set; }

    [ForeignKey("UserId")]
    [InverseProperty("UserSocial")]
    public virtual User User { get; set; } = null!;
}
