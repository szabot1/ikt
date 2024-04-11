using backend.Utils;

namespace backend_tests
{
    public class SearchTests
    {
        [Test]
        public void SimilarityTest()
        {
            Assert.Multiple(() =>
            {
                Assert.That(Search.Similarity("a b c d", "a b c d"), Is.EqualTo(1));
                Assert.That(Search.Similarity("a b c d", "z"), Is.EqualTo(0));
                Assert.That(Search.Similarity("hello", "hlelo"), Is.InRange(0.8, 0.9));
                Assert.That(Search.Similarity("hello", "HELLO"), Is.EqualTo(1));
                Assert.That(Search.Similarity("hello world", "hello"), Is.InRange(0.9, 1));
            });
        }
    }
}
