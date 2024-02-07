using backend.Data;
using backend.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using Stripe;
using Stripe.BillingPortal;

namespace backend.Controllers;

[Route("api/billing")]
[ApiController]
public class BillingController : ControllerBase
{
    private static readonly CustomerService _customerService = new();
    private static readonly SessionService _sessionService = new();

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

        var options = new SessionCreateOptions
        {
            Customer = user.StripeCustomerId,
            ReturnUrl = _stripeConfig.PortalReturnUrl,
        };

        var session = await _sessionService.CreateAsync(options);

        return Ok(new { url = session.Url });
    }
}