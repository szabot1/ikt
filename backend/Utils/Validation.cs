using System.ComponentModel.DataAnnotations;
using System.Text.RegularExpressions;
using Microsoft.AspNetCore.Mvc;

namespace backend.Utils;

public class Validation
{
    public record Result(bool IsValid, string? Error);

    public interface IValidator
    {
        public Result IsValid(string value);
    }

    public static List<string> Validate(string value, IEnumerable<IValidator> validators)
    {
        return validators.Select(validator => validator.IsValid(value))
            .Where(result => !result.IsValid)
            .Select(result => result.Error!)
            .ToList();
    }

    public static IValidator MinLength(int length) => new ProxyingValidator(
        value => value.Length >= length,
        $"Value must be at least {length} characters long"
        );

    public static IValidator MaxLength(int length) => new ProxyingValidator(
        value => value.Length <= length,
        $"Value must be at most {length} characters long"
        );

    public static readonly IValidator Email = new ProxyingValidator(
        value => new EmailAddressAttribute().IsValid(value),
        "Invalid email");

    public static readonly IValidator Required = new ProxyingValidator(
        value => !string.IsNullOrWhiteSpace(value),
        "Value is required");

    public static readonly IValidator HasLowercase = new ProxyingValidator(
        value => value.Any(char.IsLower),
        "Value must contain at least one lowercase letter");

    public static readonly IValidator HasUppercase = new ProxyingValidator(
        value => value.Any(char.IsUpper),
        "Value must contain at least one uppercase letter");

    public static readonly IValidator HasDigit = new ProxyingValidator(
        value => value.Any(char.IsDigit),
        "Value must contain at least one digit");

    public static readonly IValidator HasSpecial = new ProxyingValidator(
        value => value.Any(char.IsPunctuation) || value.Any(char.IsSymbol),
        "Value must contain at least one special character");

    public static IValidator Matches(string pattern, string errorMessage) => new ProxyingValidator(
        value => Regex.IsMatch(value, pattern),
        errorMessage);


    public class ProxyingValidator : IValidator
    {
        private readonly Func<string, bool> _validator;
        private readonly string _errorMessage;

        public ProxyingValidator(Func<string, bool> validator, string errorMessage = "Invalid value")
        {
            _validator = validator;
            _errorMessage = errorMessage;
        }

        public Result IsValid(string value)
        {
            return _validator(value) ? new Result(true, null) : new Result(false, _errorMessage);
        }
    }
}