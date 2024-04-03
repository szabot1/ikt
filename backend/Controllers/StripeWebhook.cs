using System.Net;
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
    private const string EmailSuccessTemplate = """
<div
  style="
    max-width: 600px;
    margin: 0 auto;
    background-color: #ffffff;
    padding: 20px;
    border-radius: 5px;
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
  "
>
  <h1 style="color: #333333; text-align: center">
    Thank You for Your Purchase!
  </h1>
  <p style="text-align: center; color: #666666">
    You have successfully purchased {game} for
    <strong>${price}</strong> and received
    <strong>{exp} experience points</strong>.
  </p>
  <div
    style="
      background-color: #f0f0f0;
      padding: 20px;
      border-radius: 5px;
      margin-top: 30px;
    "
  >
    <h2 style="color: #333333">Delivery Instructions</h2>
    <pre
      style="
        font-family: Courier, monospace;
        background-color: #ffffff;
        padding: 10px;
        border-radius: 5px;
        white-space: pre-wrap;
        word-wrap: break-word;
      "
    >
{instructions}</pre
    >
  </div>
  <div
    style="
      background-color: #f0f0f0;
      padding: 20px;
      border-radius: 5px;
      margin-top: 30px;
    "
  >
    <h2 style="color: #333333">Item Details</h2>
    <pre
      style="
        font-family: Courier, monospace;
        background-color: #ffffff;
        padding: 10px;
        border-radius: 5px;
        white-space: pre-wrap;
        word-wrap: break-word;
      "
    >
{item}</pre
    >
  </div>
</div>
""";

    private const string EmailFailedTemplate = """
<div
  style="
    max-width: 600px;
    margin: 0 auto;
    background-color: #ffffff;
    padding: 20px;
    border-radius: 5px;
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
  "
>
  <h1 style="color: #ff0000; text-align: center">
    Sorry, Your Purchase Failed
  </h1>
  <p style="text-align: center; color: #666666">
    We regret to inform you that your purchase of
    <strong>{game}</strong> for <strong>${price}</strong> has failed.
  </p>
  <div
    style="
      background-color: #f0f0f0;
      padding: 20px;
      border-radius: 5px;
      margin-top: 30px;
    "
  >
    <h2 style="color: #333333">What Happens Next?</h2>
    <ul style="color: #666666">
      <li>
        The item has been released back into the store and is available for
        purchase by other customers.
      </li>
      <li>
        Any funds that were pending authorization have been released and will
        not be charged to your account.
      </li>
      <li>
        You can attempt to make the purchase again at a later time or contact
        our support team for assistance.
      </li>
    </ul>
  </div>
  <div style="text-align: center; margin-top: 30px">
    <a
      href="mailto:{supportEmail}"
      style="
        display: inline-block;
        padding: 10px 20px;
        background-color: #ff0000;
        color: #ffffff;
        text-decoration: none;
        border-radius: 5px;
      "
      >Contact Support</a
    >
  </div>
</div>
""";

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
              _stripeConfig.WebhookSigningSecret
            );

            if (stripeEvent.Type == Events.CheckoutSessionCompleted)
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

                if (session.PaymentStatus != "unpaid" && session.Status == "complete")
                {
                    return await HandleSuccess(ctx, userId, offerId, stockId);
                }
                else
                {
                    return await HandleFailure(ctx, userId, offerId, stockId);
                }
            }

            return Ok();
        }
        catch (Exception e)
        {
            return StatusCode(500, e.Message);
        }
    }

    private static bool VerifyKeys(Dictionary<string, string> metadata, params string[] keys)
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

        var exp = (int)(offer.Price * Random.Shared.NextDouble());

        var userExperience = await ctx.UserExperiences.FindAsync(userId);
        userExperience!.Experience += exp;

        await ctx.SaveChangesAsync();

        await Email.SendEmailAsync(
            _emailConfig,
            user.Email,
            "Purchase Confirmation",
            EmailSuccessTemplate
                .Replace("{game}", WebUtility.HtmlEncode(offer.Game.Name))
                .Replace("{price}", (offer.Price / 100.0).ToString())
                .Replace("{exp}", exp.ToString())
                .Replace("{instructions}", WebUtility.HtmlEncode(offer.TypeNavigation.ClaimInstructions))
                .Replace("{item}", WebUtility.HtmlEncode(stock.Item)),
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
            EmailFailedTemplate
                .Replace("{game}", WebUtility.HtmlEncode(offer.Game.Name))
                .Replace("{price}", (offer.Price / 100.0).ToString())
                .Replace("{supportEmail}", _emailConfig.AccountsAddress),
            Email.EmailType.Billing);

        return Ok();
    }
}