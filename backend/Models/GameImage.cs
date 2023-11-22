using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace backend.Models;

[Table("game_images")]
[Index("GameId", Name = "game_images_game_id_idx")]
public partial class GameImage
{
    [Key]
    [Column("id")]
    public string Id { get; set; } = null!;

    [Column("game_id")]
    public string GameId { get; set; } = null!;

    [Column("image_url")]
    public string ImageUrl { get; set; } = null!;

    [Column("created_at", TypeName = "timestamp without time zone")]
    public DateTime CreatedAt { get; set; }

    [Column("updated_at", TypeName = "timestamp without time zone")]
    public DateTime UpdatedAt { get; set; }

    [ForeignKey("GameId")]
    [InverseProperty("GameImages")]
    public virtual Game Game { get; set; } = null!;
}
