using backend.Data;
using backend.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace backend.Controllers;

[Route("api/seller")]
[ApiController]
public class SellerController : ControllerBase
{
    [Authorize(Roles = "admin")]
    [HttpGet("user-id/{userId}")]
    public async Task<IActionResult> GetByUserId(GameStoreContext context, string userId)
    {
        var seller = await context.Sellers
            .FirstOrDefaultAsync(s => s.UserId == userId);

        if (seller == null)
        {
            return NotFound();
        }

        return Ok(seller);
    }

    [HttpGet("id/{id}")]
    public async Task<IActionResult> GetById(GameStoreContext context, string id)
    {
        var seller = await context.Sellers
            .FirstOrDefaultAsync(s => s.Id == id);

        if (seller == null)
        {
            return NotFound();
        }

        return Ok(seller);
    }

    [HttpGet("slug/{slug}")]
    public async Task<IActionResult> GetBySlug(GameStoreContext context, string slug)
    {
        var seller = await context.Sellers
            .FirstOrDefaultAsync(s => s.Slug == slug);

        if (seller == null)
        {
            return NotFound();
        }

        return Ok(seller);
    }

    [Authorize]
    [HttpGet("me")]
    public async Task<IActionResult> Me(GameStoreContext context)
    {
        var user = (User)HttpContext.Items["User"]!;

        var seller = await context.Sellers
            .FirstOrDefaultAsync(s => s.UserId == user.Id);

        if (seller == null)
        {
            return NotFound();
        }

        return Ok(seller);
    }

    [Authorize]
    [HttpPost("close-account")]
    public async Task<IActionResult> Close(GameStoreContext context)
    {
        var user = (User)HttpContext.Items["User"]!;

        var seller = await context.Sellers
            .FirstOrDefaultAsync(s => s.UserId == user.Id);

        if (seller == null)
        {
            return NotFound();
        }

        if (seller.IsClosed)
        {
            return BadRequest(new { message = "Seller account has already been closed" });
        }

        seller.IsClosed = true;
        await context.SaveChangesAsync();

        return Ok(seller);
    }

    [Authorize]
    [HttpPost("display-name")]
    public async Task<IActionResult> SetDisplayName(GameStoreContext context, [FromBody] SetDisplayNameRequest request)
    {
        var user = (User)HttpContext.Items["User"]!;

        var seller = await context.Sellers
            .FirstOrDefaultAsync(s => s.UserId == user.Id);

        if (seller == null)
        {
            return NotFound();
        }

        if (seller.IsClosed)
        {
            return BadRequest(new { message = "Seller account has been closed" });
        }

        if (string.IsNullOrWhiteSpace(request.DisplayName))
        {
            return BadRequest(new { message = "Display name cannot be empty" });
        }

        var slug = request.DisplayName.Replace(" ", "-").ToLower();
        slug = new string(slug.Where(c => char.IsLetterOrDigit(c)).ToArray());

        seller.Slug = slug;
        seller.DisplayName = request.DisplayName;
        await context.SaveChangesAsync();

        return Ok(seller);
    }

    public record SetDisplayNameRequest(string DisplayName);

    [Authorize]
    [HttpPost("image-url")]
    public async Task<IActionResult> SetImageUrl(GameStoreContext context, [FromBody] SetImageUrlRequest request)
    {
        var user = (User)HttpContext.Items["User"]!;

        var seller = await context.Sellers
            .FirstOrDefaultAsync(s => s.UserId == user.Id);

        if (seller == null)
        {
            return NotFound();
        }

        if (seller.IsClosed)
        {
            return BadRequest(new { message = "Seller account has been closed" });
        }

        if (string.IsNullOrWhiteSpace(request.ImageUrl) || !Uri.IsWellFormedUriString(request.ImageUrl, UriKind.Absolute))
        {
            return BadRequest(new { message = "Invalid image URL" });
        }

        seller.ImageUrl = request.ImageUrl;
        await context.SaveChangesAsync();

        return Ok(seller);
    }

    public record SetImageUrlRequest(string ImageUrl);
}