import ErrorPage from "@/error-page";
import { Game } from "@/lib/query/games";
import { Tag, tagGamesQuery, tagQuery } from "@/lib/query/tags";
import { seoPath, seoPathKey } from "@/lib/seo-path";
import { useQuery } from "@tanstack/react-query";
import { FileRoute } from "@tanstack/react-router";
import { Helmet } from "react-helmet-async";

export const Route = new FileRoute("/tag/$path").createRoute({
  component: TagComponent,
  errorComponent: ErrorPage,
});

function TagComponent() {
  const { path } = Route.useParams();
  const tagId = seoPathKey(path);

  const { data: tagData, isLoading: isTagLoading } = useQuery(tagQuery(tagId));
  const tag = tagData as Tag | undefined;

  const { data: gamesData, isLoading: isGamesLoading } = useQuery(
    tagGamesQuery(tagId, 1, 20)
  );
  const games = gamesData as Game[] | undefined;

  return (
    <div>
      {tag && (
        <Helmet prioritizeSeoTags>
          <title>Tag - {tag.name}</title>
          <link
            rel="canonical"
            href={`${import.meta.env.VITE_FRONTEND_PROD_URL}/game/${seoPath(tag.id, tag.name)}`}
          />
          <meta property="og:title" content={tag.name} />
          <meta property="og:url" content={window.location.href} />
        </Helmet>
      )}
      {isTagLoading && <p>Tag loading...</p>}

      {!isTagLoading && tag && <div>{tag.name}</div>}

      {isGamesLoading && <p>Games loading...</p>}

      {!isGamesLoading && games && (
        <div className="grid grid-cols-1 place-items-right divide-y ml-5 mt-8 divide-slate-700">
          {games.map((tag) => (
            <div className="py-6 flex gap-2">
              <image></image>
              <span>{tag.name}</span>
            </div>
          ))}
          <div className="py-6 flex gap-2">
            <span>Teszt!</span>
          </div>
        </div>
      )}
    </div>
  );
}
