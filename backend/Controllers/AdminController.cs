using backend.Data;
using backend.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Visus.Cuid;

namespace backend.Controllers;

[Route("api/admin")]
[ApiController]
public class AdminController : ControllerBase
{
    [Authorize(Roles = "admin")]
    [HttpGet("stats")]
    public async Task<IActionResult> Stats(GameStoreContext context)
    {
        var tags = await context.Tags.CountAsync();
        var games = await context.Games.CountAsync();
        var sellers = await context.Sellers.CountAsync();
        var offers = await context.Offers.CountAsync();

        return Ok(new { Tags = tags, Games = games, Sellers = sellers, Offers = offers });
    }

    [Authorize(Roles = "admin")]
    [HttpGet("users")]
    public async Task<IActionResult> Users(GameStoreContext context)
    {
        var users = await context.Users.ToListAsync();
        return Ok(users);
    }

    [Authorize(Roles = "admin")]
    [HttpGet("tags")]
    public async Task<IActionResult> Tags(GameStoreContext context)
    {
        var tags = await context.Tags.ToListAsync();
        return Ok(tags);
    }

    [Authorize(Roles = "admin")]
    [HttpPost("tags")]
    public async Task<IActionResult> AddTag(GameStoreContext context, [FromBody] Tag.CreateDto create)
    {
        var id = new Cuid2().ToString();

        context.Tags.Add(new Tag
        {
            Id = id,
            Name = create.Name,
            CreatedAt = DateTime.SpecifyKind(DateTime.UtcNow, DateTimeKind.Unspecified)
        });

        await context.SaveChangesAsync();
        return Ok(new { Id = id });
    }

    [Authorize(Roles = "admin")]
    [HttpDelete("tags/{id}")]
    public async Task<IActionResult> DeleteTag(GameStoreContext context, string id)
    {
        var tag = await context.Tags.FindAsync(id);
        if (tag == null)
        {
            return NotFound();
        }

        context.Tags.Remove(tag);
        await context.SaveChangesAsync();
        return Ok();
    }

    [Authorize(Roles = "admin")]
    [HttpPut("tags/{id}")]
    public async Task<IActionResult> UpdateTag(GameStoreContext context, string id, [FromBody] Tag.UpdateDto update)
    {
        var tag = await context.Tags.FindAsync(id);
        if (tag == null)
        {
            return NotFound();
        }

        tag.Name = update.Name;
        await context.SaveChangesAsync();
        return Ok();
    }

    [Authorize(Roles = "admin")]
    [HttpGet("games")]
    public async Task<IActionResult> Games(GameStoreContext context)
    {
        var games = await context.Games.ToListAsync();
        return Ok(games);
    }

    [Authorize(Roles = "admin")]
    [HttpDelete("games/{id}")]
    public async Task<IActionResult> DeleteGame(GameStoreContext context, string id)
    {
        var game = await context.Games.FindAsync(id);
        if (game == null)
        {
            return NotFound();
        }

        context.Games.Remove(game);
        await context.SaveChangesAsync();
        return Ok();
    }

    [Authorize(Roles = "admin")]
    [HttpGet("sellers")]
    public async Task<IActionResult> Sellers(GameStoreContext context)
    {
        var sellers = await context.Sellers.ToListAsync();
        return Ok(sellers);
    }

    [Authorize(Roles = "admin")]
    [HttpDelete("sellers/{id}")]
    public async Task<IActionResult> DeleteSeller(GameStoreContext context, string id)
    {
        var seller = await context.Sellers.FindAsync(id);
        if (seller == null)
        {
            return NotFound();
        }

        context.Sellers.Remove(seller);
        await context.SaveChangesAsync();
        return Ok();
    }

    [Authorize(Roles = "admin")]
    [HttpGet("offers")]
    public async Task<IActionResult> Offers(GameStoreContext context)
    {
        var offers = await context.Offers.ToListAsync();
        return Ok(offers);
    }

    [Authorize(Roles = "admin")]
    [HttpDelete("offers/{id}")]
    public async Task<IActionResult> DeleteOffer(GameStoreContext context, string id)
    {
        var offer = await context.Offers.FindAsync(id);
        if (offer == null)
        {
            return NotFound();
        }

        context.Offers.Remove(offer);
        await context.SaveChangesAsync();
        return Ok();
    }
}