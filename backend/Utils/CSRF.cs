using Microsoft.Extensions.Primitives;
using System.Diagnostics.CodeAnalysis;

namespace backend.Utils;

public static class CSRF
{
    private static string? FirstOrNull(IDictionary<string, StringValues> data, string key)
    {
        if (data.ContainsKey(key))
        {
            return data[key];
        }

        return null;
    }

    public static bool IsInvalidCSRF(IHeaderDictionary headers, string method)
    {
        var secFetchSite = FirstOrNull(headers, "Sec-Fetch-Site");

        if (secFetchSite == null)
        {
            return false;
        }

        if (secFetchSite == "same-origin" || secFetchSite == "same-site" || secFetchSite == "none")
        {
            return false;
        }

        var secFetchMode = FirstOrNull(headers, "Sec-Fetch-Mode");
        var secFetchDest = FirstOrNull(headers, "Sec-Fetch-Dest");

#pragma warning disable RCS1073
        if (secFetchMode == "navigate" && method == "GET" && secFetchDest != "object" && secFetchDest != "embed")
        {
            return false;
        }
#pragma warning restore RCS1073

        var origin = FirstOrNull(headers, "Origin");

        if (origin == null)
        {
            return true;
        }

        if (origin != "https://ikt-dvt.pages.dev" && origin != "http://localhost:5173")
        {
            return true;
        }

        var referer = FirstOrNull(headers, "Referer");

        if (referer == null)
        {
            return true;
        }

        if (referer != "https://ikt-dvt.pages.dev/" && referer != "http://localhost:5173/")
        {
            return true;
        }

        return false;
    }
}