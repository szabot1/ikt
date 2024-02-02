using System;
using System.Collections.Generic;

namespace backend.Models;

public partial class GameTag
{
    public string Id { get; set; } = null!;

    public string GameId { get; set; } = null!;

    public string TagId { get; set; } = null!;

    public DateTime CreatedAt { get; set; }

    public virtual Game Game { get; set; } = null!;

    public virtual Tag Tag { get; set; } = null!;

    public GameTag WithoutGame()
    {
        Game = null!;
        return this;
    }
}
