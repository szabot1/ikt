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
}