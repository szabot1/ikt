namespace backend.Data;

public class EmailConfig
{
    public string Host { get; set; } = null!;
    public int Port { get; set; }
    public string Username { get; set; } = null!;
    public string Password { get; set; } = null!;
    public string AccountsAddress { get; set; } = null!;
    public string BillingAddress { get; set; } = null!;
    public string NoReplyAddress { get; set; } = null!;
    public string DisplayName { get; set; } = null!;
}