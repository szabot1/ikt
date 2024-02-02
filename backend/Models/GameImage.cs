using System;
using System.Collections.Generic;

namespace backend.Models;

public partial class GameImage
{
    public string Id { get; set; } = null!;

    public string GameId { get; set; } = null!;

    public string ImageUrl { get; set; } = null!;

    public DateTime CreatedAt { get; set; }

    public DateTime UpdatedAt { get; set; }

    public virtual Game Game { get; set; } = null!;

    public GameImage WithoutGame()
    {
        Game = null!;
        return this;
    }
}
