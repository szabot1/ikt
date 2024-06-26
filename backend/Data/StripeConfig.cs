namespace backend.Data;

public class StripeConfig
{
    public string ActiveKey { get; set; } = null!;
    public string LiveSecretKey { get; set; } = null!;
    public string TestSecretKey { get; set; } = null!;
    public string PortalReturnUrl { get; set; } = null!;
    public string CheckoutSuccessUrl { get; set; } = null!;
    public string CheckoutCancelUrl { get; set; } = null!;
    public string WebhookSigningSecret { get; set; } = null!;

    public string SecretKey => ActiveKey == "Live" ? LiveSecretKey : TestSecretKey;
}