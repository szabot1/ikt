using System.Diagnostics.CodeAnalysis;

namespace backend.Utils;

public static class CSRF
{
    public static bool IsCrossSite(IHeaderDictionary headers, string method)
    {
        var secFetchSite = headers["Sec-Fetch-Site"].FirstOrDefault();

        if (secFetchSite == null)
        {
            return false;
        }

        if (secFetchSite == "same-origin" || secFetchSite == "same-site" || secFetchSite == "none")
        {
            return false;
        }

        var secFetchMode = headers["Sec-Fetch-Mode"].FirstOrDefault();
        var secFetchDest = headers["Sec-Fetch-Dest"].FirstOrDefault();

#pragma warning disable RCS1073
        if (secFetchMode == "navigate" && method == "GET" && secFetchDest != "object" && secFetchDest != "embed")
        {
            return false;
        }
#pragma warning restore RCS1073

        return true;
    }
}