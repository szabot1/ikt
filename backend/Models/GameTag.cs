using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace backend.Models;

[Table("game_tags")]
[Index("GameId", Name = "game_tags_game_id_idx")]
[Index("TagId", Name = "game_tags_tag_id_idx")]
public partial class GameTag
{
    [Key]
    [Column("id")]
    public string Id { get; set; } = null!;

    [Column("game_id")]
    public string GameId { get; set; } = null!;

    [Column("tag_id")]
    public string TagId { get; set; } = null!;

    [Column("created_at", TypeName = "timestamp without time zone")]
    public DateTime CreatedAt { get; set; }

    [ForeignKey("GameId")]
    [InverseProperty("GameTags")]
    public virtual Game Game { get; set; } = null!;

    [ForeignKey("TagId")]
    [InverseProperty("GameTags")]
    public virtual Tag Tag { get; set; } = null!;

    public GameTag WithoutGame()
    {
        Game = null!;
        return this;
    }
}
