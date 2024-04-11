using backend.Utils;

namespace backend_tests
{
    public class ValidationTests
    {
        [Test]
        public void MinLengthTest()
        {
            Assert.Multiple(() =>
            {
                Assert.That(Validation.MinLength(2).IsValid("a").IsValid, Is.False);
                Assert.That(Validation.MinLength(2).IsValid("ab").IsValid, Is.True);
            });
        }

        [Test]
        public void MaxLengthTest()
        {
            Assert.Multiple(() =>
            {
                Assert.That(Validation.MaxLength(2).IsValid("a").IsValid, Is.True);
                Assert.That(Validation.MaxLength(2).IsValid("ab").IsValid, Is.True);
                Assert.That(Validation.MaxLength(2).IsValid("abc").IsValid, Is.False);
            });
        }

        [Test]
        public void RequiredTest()
        {
            Assert.Multiple(() =>
            {
                Assert.That(Validation.Required().IsValid("a").IsValid, Is.True);
                Assert.That(Validation.Required().IsValid("").IsValid, Is.False);
            });
        }

        [Test]
        public void SpecialCharactersTest()
        {
            Assert.Multiple(() =>
            {
                Assert.That(Validation.HasLowercase().IsValid("a").IsValid, Is.True);
                Assert.That(Validation.HasLowercase().IsValid("A").IsValid, Is.False);

                Assert.That(Validation.HasUppercase().IsValid("A").IsValid, Is.True);
                Assert.That(Validation.HasUppercase().IsValid("a").IsValid, Is.False);

                Assert.That(Validation.HasDigit().IsValid("a1b").IsValid, Is.True);
                Assert.That(Validation.HasDigit().IsValid("ab").IsValid, Is.False);

                Assert.That(Validation.HasSpecial().IsValid("a1b!").IsValid, Is.True);
                Assert.That(Validation.HasSpecial().IsValid("a1b").IsValid, Is.False);
            });
        }
    }
}