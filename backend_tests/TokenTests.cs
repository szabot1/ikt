using backend.Utils;

namespace backend_tests
{
    public class TokenTests
    {
        [Test]
        public void RefreshTokenTest()
        {
            Assert.That(Convert.FromBase64String(Token.GenerateRefreshToken()), Has.Length.EqualTo(32));
        }

        [Test]
        public void EmailTokenTest()
        {
            Assert.That(Token.GenerateEmailOneTimeCode(), Has.Length.EqualTo(8));
        }
    }
}
