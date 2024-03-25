using backend.Data;
using backend.Models;
using backend.Utils;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Visus.Cuid;

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

        return Ok(seller.NormalizeForJson());
    }

    [Authorize]
    [HttpPost("close-account")]
    public async Task<IActionResult> Close(GameStoreContext context)
    {
        if (CSRF.IsCrossSite(Request.Headers, Request.Method))
        {
            return BadRequest("Please try again. (CSRF)");
        }

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
        if (CSRF.IsCrossSite(Request.Headers, Request.Method))
        {
            return BadRequest("Please try again. (CSRF)");
        }

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
        if (CSRF.IsCrossSite(Request.Headers, Request.Method))
        {
            return BadRequest("Please try again. (CSRF)");
        }

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

    [Authorize(Roles = "admin")]
    [HttpPost]
    public async Task<IActionResult> Create(GameStoreContext context, [FromBody] CreateSellerRequest request)
    {
        if (CSRF.IsCrossSite(Request.Headers, Request.Method))
        {
            return BadRequest("Please try again. (CSRF)");
        }

        var user = await context.Users
            .FirstOrDefaultAsync(u => u.Id == request.UserId);

        if (user == null)
        {
            return BadRequest(new { message = "User not found" });
        }

        var existingSeller = await context.Sellers
            .FirstOrDefaultAsync(s => s.UserId == request.UserId);

        if (existingSeller != null)
        {
            return BadRequest(new { message = "Seller already exists" });
        }

        var displayName = user.Email.Split('@')[0];

        var slug = displayName.Replace(" ", "-").ToLower();
        slug = new string(slug.Where(c => char.IsLetterOrDigit(c)).ToArray());

        var seller = new Seller
        {
            Id = new Cuid2().ToString(),
            UserId = user.Id,
            DisplayName = displayName,
            Slug = slug,
            ImageUrl = $"https://ui-avatars.com/api/?name={displayName}&background=random",
            IsVerified = false,
            IsClosed = false
        };

        await context.Sellers.AddAsync(seller);
        await context.SaveChangesAsync();

        return Ok(seller);
    }

    public record CreateSellerRequest(string UserId);
}