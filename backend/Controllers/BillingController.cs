using backend.Data;
using backend.Models;
using backend.Utils;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using Stripe;
using Stripe.Checkout;

namespace backend.Controllers;

[Route("api/billing")]
[ApiController]
public class BillingController : ControllerBase
{
    private static readonly Stripe.BillingPortal.SessionService _billingSessionService = new();
    private static readonly Stripe.Checkout.SessionService _checkoutSessionService = new();

    private readonly StripeConfig _stripeConfig;

    public BillingController(IOptions<StripeConfig> stripeConfig)
    {
        _stripeConfig = stripeConfig.Value;

        StripeConfiguration.ApiKey = _stripeConfig.SecretKey;
    }

    [Authorize]
    [HttpGet("customer-portal")]
    public async Task<IActionResult> CustomerPortal()
    {
        var user = (User)HttpContext.Items["User"]!;

        var options = new Stripe.BillingPortal.SessionCreateOptions
        {
            Customer = user.StripeCustomerId,
            ReturnUrl = _stripeConfig.PortalReturnUrl,
        };

        var session = await _billingSessionService.CreateAsync(options);

        return Ok(new { url = session.Url });
    }

    [Authorize]
    [HttpPost("checkout")]
    public async Task<IActionResult> Checkout([FromServices] GameStoreContext ctx, [FromBody] CheckoutRequest request)
    {
        if (CSRF.IsInvalidCSRF(Request.Headers, Request.Method))
        {
            return BadRequest("Please try again. (CSRF)");
        }

        var offer = await ctx.Offers.Include(o => o.Game).Include(o => o.Seller).FirstOrDefaultAsync(o => o.Id == request.OfferId);

        if (offer == null || offer.IsActive == false || offer.Seller.IsClosed)
        {
            return NotFound(new { message = "Offer not found" });
        }

        var stock = await ctx.OfferStocks.FromSqlInterpolated($"select * from take_stock({offer.Id})").FirstOrDefaultAsync();

        if (stock == null)
        {
            return BadRequest(new { message = "Offer is out of stock" });
        }

        var user = (User)HttpContext.Items["User"]!;

        var options = new Stripe.Checkout.SessionCreateOptions
        {
            LineItems = new List<SessionLineItemOptions>
            {
                new() {
                    PriceData = new() {
                        Currency = "usd",
                        ProductData = new() {
                            Name = offer.Game.Name,
                        },
                        UnitAmount = offer.Price
                    },
                    Quantity = 1
                }
            },
            Customer = user.StripeCustomerId,
            Mode = "payment",
            SuccessUrl = _stripeConfig.CheckoutSuccessUrl,
            CancelUrl = _stripeConfig.CheckoutCancelUrl,
            Metadata = new Dictionary<string, string>
            {
                { "userId", user.Id },
                { "offerId", offer.Id },
                { "stockId", stock.Id }
            }
        };

        var session = await _checkoutSessionService.CreateAsync(options);

        return Ok(new { url = session.Url });
    }

    public record CheckoutRequest(string OfferId);
}