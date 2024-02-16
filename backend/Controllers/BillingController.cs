using backend.Data;
using backend.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using Stripe;
using Stripe.Checkout;

namespace backend.Controllers;

[Route("api/billing")]
[ApiController]
public class BillingController : ControllerBase
{
    private static readonly CustomerService _customerService = new();
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
    public async Task<IActionResult> Checkout()
    {
        var user = (User)HttpContext.Items["User"]!;

        var options = new Stripe.Checkout.SessionCreateOptions
        {
            LineItems = new List<SessionLineItemOptions>
            {
                new() {
                    PriceData = new() {
                        Currency = "usd",
                        ProductData = new() {
                            Name = "Test Item"
                        },
                        UnitAmount = 499
                    },
                    Quantity = 1
                }
            },
            Customer = user.StripeCustomerId,
            Mode = "payment",
            SuccessUrl = _stripeConfig.CheckoutSuccessUrl,
            CancelUrl = _stripeConfig.CheckoutCancelUrl
        };

        var session = await _checkoutSessionService.CreateAsync(options);

        return Ok(new { url = session.Url });
    }
}