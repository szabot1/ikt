namespace backend.Utils;

public static class CSRF
{
    public static bool IsCrossSite(IHeaderDictionary headers)
    {
        var secFetchSite = headers["Sec-Fetch-Site"];
        return secFetchSite.Count != 1 || secFetchSite[0] == "cross-site";
    }
}