using backend.Data;
using backend.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace backend.Controllers;

[Route("api/games")]
[ApiController]
public class GamesController : ControllerBase
{
    [HttpGet]
    public async Task<ActionResult<IEnumerable<Game>>> GetGames(
        GameStoreContext context,
        [FromQuery] int page = 1,
        [FromQuery] int size = 20)
        => await context.Games
            .Skip((page - 1) * size)
            .Take(size)
            .Include(game => game.GameImages)
            .Include(game => game.GameTags)
            .ThenInclude(gameTag => gameTag.Tag)
            .Select(game => game.NormalizeForJson())
            .ToListAsync();

    [HttpGet("featured")]
    public async Task<ActionResult<IEnumerable<Game>>> GetFeaturedGames(
        GameStoreContext context,
        [FromQuery] int page = 1,
        [FromQuery] int size = 20)
        => await context.Games
            .Where(game => game.IsFeatured)
            .Skip((page - 1) * size)
            .Take(size)
            .Include(game => game.GameImages)
            .Include(game => game.GameTags)
            .ThenInclude(gameTag => gameTag.Tag)
            .Select(game => game.NormalizeForJson())
            .ToListAsync();

    [HttpGet("recently-updated")]
    public async Task<ActionResult<IEnumerable<Game>>> GetRecentlyUpdatedGames(
        GameStoreContext context,
        [FromQuery] int page = 1,
        [FromQuery] int size = 20)
        => await context.Games
            .OrderByDescending(game => game.UpdatedAt)
            .Skip((page - 1) * size)
            .Take(size)
            .Include(game => game.GameImages)
            .Include(game => game.GameTags)
            .ThenInclude(gameTag => gameTag.Tag)
            .Select(game => game.NormalizeForJson())
            .ToListAsync();

    [HttpGet("discounted")]
    public ActionResult<IEnumerable<Game>> GetDiscountedGames(
        GameStoreContext context,
        [FromQuery] int page = 1,
        [FromQuery] int size = 20)
        => Ok(new List<Game>());
}