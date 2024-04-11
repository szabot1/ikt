using backend.Utils;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Primitives;

namespace backend_tests
{
    public class CSRFTests
    {
        [Test]
        public void MissingOriginTest()
        {
            Assert.That(CSRF.IsInvalidCSRF(
                new HeaderDictionary(new Dictionary<string, StringValues>{
                    { "Sec-Fetch-Site", "cross-site" }
                }),
                "POST"
                ), Is.True);
        }
        [Test]
        public void InvalidOriginTest()
        {
            Assert.That(CSRF.IsInvalidCSRF(
                new HeaderDictionary(new Dictionary<string, StringValues>{
                    { "Sec-Fetch-Site", "cross-site" },
                    { "Origin", "https://google.com" }
                }),
                "POST"
                ), Is.True);
        }

        [Test]
        public void MissingRefererTest()
        {
            Assert.That(CSRF.IsInvalidCSRF(
                new HeaderDictionary(new Dictionary<string, StringValues>{
                    { "Sec-Fetch-Site", "cross-site" },
                    { "Origin", "http://localhost:5173" }
                }),
                "POST"
                ), Is.True);
        }

        [Test]
        public void InvalidRefererTest()
        {
            Assert.That(CSRF.IsInvalidCSRF(
                new HeaderDictionary(new Dictionary<string, StringValues>{
                    { "Sec-Fetch-Site", "cross-site" },
                    { "Origin", "http://localhost:5173" },
                    { "Referer", "https://google.com/" }
                }),
                "POST"
                ), Is.True);
        }

        [Test]
        public void AllowsUnsupportedBrowserTest()
        {
            Assert.That(CSRF.IsInvalidCSRF(
                new HeaderDictionary(new Dictionary<string, StringValues>{}),
                "POST"
                ), Is.False);
        }

        [Test]
        public void AllowsNavigationTest()
        {
            Assert.That(CSRF.IsInvalidCSRF(
                new HeaderDictionary(new Dictionary<string, StringValues> {
                    { "Sec-Fetch-Site", "cross-site" },
                    { "Sec-Fetch-Mode", "navigate" }
                }),
                "GET"
                ), Is.False);
        }

        [Test]
        public void ValidSameSiteTest()
        {
            Assert.That(CSRF.IsInvalidCSRF(
                new HeaderDictionary(new Dictionary<string, StringValues>{
                    { "Sec-Fetch-Site", "same-site" }
                }),
                "POST"
                ), Is.False);
        }

        [Test]
        public void ValidCrossSiteTest()
        {
            Assert.That(CSRF.IsInvalidCSRF(
                new HeaderDictionary(new Dictionary<string, StringValues>{
                    { "Sec-Fetch-Site", "cross-site" },
                    { "Origin", "http://localhost:5173" },
                    { "Referer", "http://localhost:5173/" }
                }),
                "POST"
                ), Is.False);
        }
    }
}
