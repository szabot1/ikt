namespace backend.Utils;

public static class Search
{
    public static double Similarity(string source, string target)
    {
        var score = FuzzySharp.Fuzz.WeightedRatio(source, target);
        return score / 100.0;
        // var distance = CalculateDistance(source, target);
        // return 1 - (double)distance / Math.Max(source.Length, target.Length);
    }

    public static int CalculateDistance(string source, string target)
    {
        var sourceLength = source.Length;
        var targetLength = target.Length;

        if (sourceLength == 0) return targetLength;
        if (targetLength == 0) return sourceLength;

        var distance = new int[sourceLength + 1, targetLength + 1];

        for (var i = 0; i <= sourceLength; distance[i, 0] = i++) { }
        for (var j = 0; j <= targetLength; distance[0, j] = j++) { }

        for (var i = 1; i <= sourceLength; i++)
        {
            for (var j = 1; j <= targetLength; j++)
            {
                var cost = target[j - 1] == source[i - 1] ? 0 : 1;

                distance[i, j] = Math.Min(
                    Math.Min(
                        distance[i - 1, j] + 1,
                        distance[i, j - 1] + 1
                    ),
                    distance[i - 1, j - 1] + cost
                );

                if (i > 1 && j > 1 && source[i - 1] == target[j - 2] && source[i - 2] == target[j - 1])
                {
                    distance[i, j] = Math.Min(
                        distance[i, j],
                        distance[i - 2, j - 2] + cost
                    );
                }
            }
        }

        return distance[sourceLength, targetLength];
    }
}