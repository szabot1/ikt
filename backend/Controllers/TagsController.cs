using backend.Data;
using backend.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace backend.Controllers;

[Route("api/tags")]
[ApiController]
public class TagsController : ControllerBase
{
    [HttpGet]
    public async Task<ActionResult<IEnumerable<Tag>>> GetAllTags(GameStoreContext context)
        => await context.Tags.ToListAsync();

    [HttpGet("{id}")]
    public async Task<ActionResult<Tag>> GetTagById(GameStoreContext context, string id)
    {
        var tag = await context.Tags.FindAsync(id);

        if (tag == null)
        {
            return NotFound();
        }

        return tag;
    }

    [HttpGet("{id}/games")]
    public async Task<ActionResult<IEnumerable<Game>>> GetGamesByTagId(
        GameStoreContext context,
        string id,
        [FromQuery] int page = 1,
        [FromQuery] int size = 20)
        => await context.Games
            .Where(game => game.GameTags.Any(gameTag => gameTag.TagId == id))
            .Skip((page - 1) * size)
            .Take(size)
            .Include(game => game.GameImages)
            .Include(game => game.GameTags)
            .ThenInclude(gameTag => gameTag.Tag)
            .Select(game => game.NormalizeForJson())
            .ToListAsync();
}