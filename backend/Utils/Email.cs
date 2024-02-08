
using backend.Data;
using MailKit.Net.Smtp;
using MailKit.Security;
using MimeKit;

namespace backend.Utils;

public class Email
{
    public enum EmailType
    {
        Accounts,
        Billing,
        NoReply
    }

    public static async Task SendEmailAsync(EmailConfig emailConfig, string toEmail, string subject, string content, EmailType emailType)
    {
        var from = emailType switch
        {
            EmailType.Accounts => emailConfig.AccountsAddress,
            EmailType.Billing => emailConfig.BillingAddress,
            EmailType.NoReply => emailConfig.NoReplyAddress,
            _ => throw new ArgumentOutOfRangeException(nameof(emailType), emailType, null)
        };

        var email = new MimeMessage();
        email.Sender = new MailboxAddress(emailConfig.DisplayName, from);
        email.From.Add(new MailboxAddress(emailConfig.DisplayName, from));
        email.To.Add(MailboxAddress.Parse(toEmail));

        email.Subject = subject;

        var builder = new BodyBuilder
        {
            HtmlBody = content
        };

        email.Body = builder.ToMessageBody();

        using var smtp = new SmtpClient();
        await smtp.ConnectAsync(emailConfig.Host, emailConfig.Port, SecureSocketOptions.StartTls);
        await smtp.AuthenticateAsync(emailConfig.Username, emailConfig.Password);
        await smtp.SendAsync(email);
        await smtp.DisconnectAsync(true);
    }
}