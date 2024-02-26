using backend.Data;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace backend.Controllers;

[Route("api/offer")]
[ApiController]
public class OfferController : ControllerBase
{
    [HttpGet("game-id/{gameId}")]
    public async Task<IActionResult> GetByGameId(GameStoreContext context, string gameId)
    {
        var offers = await context.Offers.Where(o => o.GameId == gameId).ToListAsync();
        return Ok(offers);
    }

    [HttpGet("{id}")]
    public async Task<IActionResult> GetById(GameStoreContext context, int id)
    {
        var offer = await context.Offers.FindAsync(id);

        if (offer == null)
        {
            return NotFound();
        }

        return Ok(offer);
    }
}