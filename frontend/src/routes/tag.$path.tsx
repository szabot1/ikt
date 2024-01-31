import ErrorPage from "@/error-page";
import { Game } from "@/lib/query/games";
import { Tag, tagGamesQuery, tagQuery } from "@/lib/query/tags";
import { seoPathKey } from "@/lib/seo-path";
import { useQuery } from "@tanstack/react-query";
import { FileRoute } from "@tanstack/react-router";

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
      <h1>Tag</h1>
      <p>Tag ID: {tagId}</p>

      {isTagLoading && <p>Tag loading...</p>}

      {!isTagLoading && tag && (
        <code className="bg-red-400 whitespace-pre-wrap">
          {JSON.stringify({ tag, isTagLoading }, null, 2)}
        </code>
      )}

      {isGamesLoading && <p>Games loading...</p>}

      {!isGamesLoading && games && (
        <code className="bg-green-400 whitespace-pre-wrap">
          {JSON.stringify({ games, isGamesLoading }, null, 2)}
        </code>
      )}
    </div>
  );
}
