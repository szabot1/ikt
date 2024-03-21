using backend.Data;
using backend.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Visus.Cuid;

namespace backend.Controllers;

[Route("api/offer")]
[ApiController]
public class OfferController : ControllerBase
{
    [HttpGet("game-id/{gameId}")]
    public async Task<IActionResult> GetByGameId(GameStoreContext context, string gameId)
    {
        var offers = await context.Offers.Where(o => o.GameId == gameId).Where(o => o.IsActive == true).ToListAsync();
        return Ok(offers);
    }

    [Authorize]
    [HttpGet("types")]
    public async Task<IActionResult> GetTypes(GameStoreContext context)
    {
        var types = await context.OfferTypes.ToListAsync();
        return Ok(types);
    }

    [Authorize]
    [HttpGet("create-offer-game-list")]
    public async Task<IActionResult> GetCreateOfferGameList(GameStoreContext context)
    {
        var user = (User)HttpContext.Items["User"]!;

        var seller = await context.Sellers.Include(s => s.Offers).FirstOrDefaultAsync(s => s.UserId == user.Id);
        if (seller == null)
        {
            return Unauthorized();
        }

        var games = await context.Games.ToListAsync();
        var availableGames = games.Where(g => !seller.Offers.Any(o => o.GameId == g.Id)).ToList();

        return Ok(availableGames);
    }

    [Authorize]
    [HttpGet("seller-id/{sellerId}")]
    public async Task<IActionResult> GetBySellerId(GameStoreContext context, string sellerId)
    {
        var user = (User)HttpContext.Items["User"]!;

        if (user.Id != sellerId && user.Role != UserRole.support && user.Role != UserRole.admin)
        {
            return Unauthorized();
        }

        var offers = await context.Offers.Where(o => o.SellerId == sellerId).ToListAsync();
        return Ok(offers);
    }

    [HttpGet("{id}")]
    public async Task<IActionResult> GetById(GameStoreContext context, int id)
    {
        var offer = await context.Offers.FindAsync(id);

        if (offer == null || offer.IsActive == false)
        {
            return NotFound();
        }

        return Ok(offer);
    }

    [Authorize]
    [HttpPost("new")]
    public async Task<IActionResult> Create(GameStoreContext context, [FromBody] CreateOfferRequest request)
    {
        var user = (User)HttpContext.Items["User"]!;

        var seller = await context.Sellers.FirstOrDefaultAsync(s => s.UserId == user.Id);
        if (seller == null)
        {
            return Unauthorized();
        }

        if (request.Price <= 0)
        {
            return BadRequest("Price must be at least $0.01");
        }

        var game = await context.Games.FindAsync(request.GameId);
        if (game == null)
        {
            return BadRequest("Game not found");
        }

        var offerType = await context.OfferTypes.FindAsync(request.TypeId);
        if (offerType == null)
        {
            return BadRequest("Offer type not found");
        }

        var offer = new Offer
        {
            Id = new Cuid2().ToString(),
            GameId = game.Id,
            SellerId = seller.Id,
            Price = request.Price,
            IsActive = true,
            Type = offerType.Id,
            CreatedAt = DateTime.Now,
            UpdatedAt = DateTime.Now
        };

        context.Offers.Add(offer);
        await context.SaveChangesAsync();

        return Ok(offer);
    }

    public record CreateOfferRequest(string GameId, int Price, string TypeId);

    [Authorize]
    [HttpPut("{id}")]
    public async Task<IActionResult> Update(GameStoreContext context, string id, [FromBody] UpdateOfferRequest request)
    {
        var user = (User)HttpContext.Items["User"]!;

        var offer = await context.Offers.FindAsync(id);
        if (offer == null)
        {
            return NotFound();
        }

        if (offer.SellerId != user.Id && user.Role != UserRole.admin)
        {
            return Unauthorized();
        }

        if (request.Price <= 0)
        {
            return BadRequest("Price must be greater than 0");
        }

        offer.Price = request.Price;
        offer.IsActive = request.IsActive;
        offer.UpdatedAt = DateTime.Now;

        await context.SaveChangesAsync();

        return Ok(offer);
    }

    public record UpdateOfferRequest(int Price, bool IsActive);

    [Authorize]
    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete(GameStoreContext context, string id)
    {
        var user = (User)HttpContext.Items["User"]!;

        var offer = await context.Offers.FindAsync(id);
        if (offer == null)
        {
            return NotFound();
        }

        if (offer.SellerId != user.Id && user.Role != UserRole.admin)
        {
            return Unauthorized();
        }

        context.Offers.Remove(offer);
        await context.SaveChangesAsync();

        return Ok();
    }

    [Authorize]
    [HttpDelete("stock/{id}")]
    public async Task<IActionResult> ClearOfferStock(GameStoreContext context, string id)
    {
        var user = (User)HttpContext.Items["User"]!;

        var offer = await context.Offers.FindAsync(id);
        if (offer == null)
        {
            return NotFound();
        }

        if (offer.SellerId != user.Id && user.Role != UserRole.admin)
        {
            return Unauthorized();
        }

        context.OfferStocks.RemoveRange(context.OfferStocks.Where(os => os.OfferId == id));

        await context.SaveChangesAsync();

        return Ok();
    }

    [Authorize]
    [HttpPost("stock/bulk")]
    public async Task<IActionResult> AddStockBulk(GameStoreContext context, [FromBody] AddStockBulkRequest request)
    {
        var user = (User)HttpContext.Items["User"]!;

        var offer = await context.Offers.FindAsync(request.OfferId);
        if (offer == null)
        {
            return NotFound();
        }

        if (offer.SellerId != user.Id && user.Role != UserRole.admin)
        {
            return Unauthorized();
        }

        var items = request.Items.Select(i => new OfferStock
        {
            Id = new Cuid2().ToString(),
            OfferId = offer.Id,
            Item = i,
            IsLocked = false
        });

        context.OfferStocks.AddRange(items);
        await context.SaveChangesAsync();

        return Ok();
    }

    public record AddStockBulkRequest(string OfferId, List<string> Items);
}