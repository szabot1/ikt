using backend.Data;
using backend.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Visus.Cuid;

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

        return tag ?? (ActionResult<Tag>)NotFound();
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

    [HttpPost("new")]
    [Authorize(Roles = "admin")]
    public async Task<ActionResult<Tag>> CreateTag(GameStoreContext context, [FromBody] CreateTagRequest request)
    {
        var tag = new Tag
        {
            Id = new Cuid2().ToString(),
            Name = request.Name,
            CreatedAt = DateTime.SpecifyKind(DateTime.UtcNow, DateTimeKind.Unspecified)
        };

        context.Tags.Add(tag);
        await context.SaveChangesAsync();

        return CreatedAtAction(nameof(GetTagById), new { id = tag.Id }, tag);
    }

    public record CreateTagRequest(string Name);
}