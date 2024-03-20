import GameList, {
  gameToListedGame,
} from "@/components/routes/index/game-list";
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
    <div className="flex flex-row items-center justify-center grow mt-16">
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

      {isGamesLoading && <p>Games loading...</p>}

      {!isGamesLoading && games && (
        <div className="flex flex-col gap-2 w-full lg:w-1/2">
          <h1 className="text-2xl font-semibold">Games with this tag</h1>

          {games.length === 0 ? (
            <div className="px-12 py-6 border-2 border-zinc-700 rounded-lg">
              <span className="text-red-500 text-sm">
                There are no games associated with this tag
              </span>
            </div>
          ) : (
            <GameList
              title=""
              isLoaded={true}
              games={games.map(gameToListedGame)}
            />
          )}
        </div>
      )}
    </div>
  );
}
