using backend.Data;
using backend.Models;
using backend.Utils;
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

    [HttpGet("{id}")]
    public async Task<ActionResult<Game>> GetGameById(
        GameStoreContext context,
        string id)
    {
        var game = await context.Games
        .Where(game => game.Id == id)
        .Include(game => game.GameImages)
        .Include(game => game.GameTags)
        .ThenInclude(gameTag => gameTag.Tag)
        .Select(game => game.NormalizeForJson())
        .FirstOrDefaultAsync();

        return game ?? (ActionResult<Game>)NotFound();
    }

    [HttpGet("search")]
    public async Task<ActionResult<IEnumerable<object>>> SearchGames(
        GameStoreContext context,
        [FromQuery] string query)
    {
        var games = await context.Games
         .Include(game => game.Offers)
         .Include(game => game.GameImages)
         .Include(game => game.GameTags)
         .ThenInclude(gameTag => gameTag.Tag)
         .ToListAsync();

        var resultGames = games.Where(game => Search.Similarity(game.Name, query) > 0.5)
           .OrderByDescending(game => Search.Similarity(game.Name, query))
           .ToList();

        return Ok(resultGames.ConvertAll(game =>
        {
            return new
            {
                game.Id,
                game.Name,
                game.Slug,
                game.Description,
                game.IsActive,
                game.IsFeatured,
                game.GameImages,
                game.GameTags,
                game.CreatedAt,
                game.UpdatedAt,
                game.Offers
            };
        }));
    }
}