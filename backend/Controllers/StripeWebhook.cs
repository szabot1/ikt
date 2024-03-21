using backend.Data;
using backend.Utils;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using Stripe;

namespace backend.Controllers;

[Route("api/stripe-webhook")]
[ApiController]
public class StripeWebhook : ControllerBase
{
    private readonly EmailConfig _emailConfig;
    private readonly StripeConfig _stripeConfig;

    public StripeWebhook(IOptions<EmailConfig> emailConfig, IOptions<StripeConfig> stripeConfig)
    {
        _emailConfig = emailConfig.Value;
        _stripeConfig = stripeConfig.Value;

        StripeConfiguration.ApiKey = _stripeConfig.SecretKey;
    }

    [HttpPost]
    public async Task<IActionResult> Index([FromServices] GameStoreContext ctx)
    {
        var json = await new StreamReader(HttpContext.Request.Body).ReadToEndAsync();

        try
        {
            var stripeEvent = EventUtility.ConstructEvent(
              json,
              Request.Headers["Stripe-Signature"],
              _stripeConfig.SecretKey
            );

            if (stripeEvent.Type == Events.ChargeSucceeded)
            {
                var session = stripeEvent.Data.Object as Stripe.Checkout.Session;
                var metadata = session!.Metadata;

                if (!VerifyKeys(metadata, "userId", "offerId", "stockId"))
                {
                    return BadRequest("metadata is missing keys, event: " + stripeEvent.Id);
                }

                var userId = metadata["userId"];
                var offerId = metadata["offerId"];
                var stockId = metadata["stockId"];

                return await HandleSuccess(ctx, userId, offerId, stockId);
            }
            else if (stripeEvent.Type == Events.ChargeFailed)
            {
                var session = stripeEvent.Data.Object as Stripe.Checkout.Session;
                var metadata = session!.Metadata;

                if (!VerifyKeys(metadata, "userId", "offerId", "stockId"))
                {
                    return BadRequest("metadata is missing keys, event: " + stripeEvent.Id);
                }

                var userId = metadata["userId"];
                var offerId = metadata["offerId"];
                var stockId = metadata["stockId"];

                return await HandleFailure(ctx, userId, offerId, stockId);
            }

            return Ok();
        }
        catch (Exception e)
        {
            return BadRequest(e);
        }
    }

    private bool VerifyKeys(Dictionary<string, string> metadata, params string[] keys)
    {
        return keys.All(key => metadata.ContainsKey(key));
    }

    private async Task<IActionResult> HandleSuccess(GameStoreContext ctx, string userId, string offerId, string stockId)
    {
        var user = ctx.Users.Find(userId);
        var offer = ctx.Offers.Include(o => o.Game).Include(o => o.TypeNavigation).FirstOrDefault(o => o.Id == offerId);
        var stock = ctx.OfferStocks.Find(stockId);

        if (user == null || offer == null || stock == null)
        {
            return NotFound("something is null: user=" + user + " offer=" + offer + " stock=" + stock);
        }

        ctx.OfferStocks.Remove(stock);

        var exp = offer.Price * Random.Shared.Next();

        var userExperience = await ctx.UserExperiences.FindAsync(userId);
        userExperience!.Experience += exp;

        await ctx.SaveChangesAsync();

        await Email.SendEmailAsync(
            _emailConfig,
            user.Email,
            "Purchase Confirmation",
            $@"<h1>Thank you for your purchase!</h1>
                    <p>You have successfully purchased {offer.Game.Name} for ${offer.Price / 100.0}, and received {exp} experience points.</p>
                    <br>
                    <h2>Delivery Instructions</h2>
                    <code>
                    {offer.TypeNavigation.ClaimInstructions}
                    </code>
                    <br>
                    <h2>Item Details</h2>
                    <code>
                    {stock.Item}
                    </code>",
            Email.EmailType.Billing);

        return Ok();
    }

    private async Task<IActionResult> HandleFailure(GameStoreContext ctx, string userId, string offerId, string stockId)
    {
        var user = ctx.Users.Find(userId);
        var offer = ctx.Offers.Include(o => o.Game).Include(o => o.TypeNavigation).FirstOrDefault(o => o.Id == offerId);
        var stock = ctx.OfferStocks.Find(stockId);

        if (user == null || offer == null || stock == null)
        {
            return NotFound("something is null: user=" + user + " offer=" + offer + " stock=" + stock);
        }

        stock.IsLocked = false;

        await ctx.SaveChangesAsync();

        await Email.SendEmailAsync(
            _emailConfig,
            user.Email,
            "Purchase Failed",
            $@"<h1>Sorry, your purchase failed.</h1>
                    <p>Your purchase of {offer.Game.Name} for ${offer.Price / 100.0} has failed, the item has been released back into the store.</p>",
            Email.EmailType.Billing);

        return Ok();
    }
}