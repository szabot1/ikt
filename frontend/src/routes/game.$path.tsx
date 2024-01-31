import ErrorPage from "@/error-page";
import { gameQuery } from "@/lib/query/games";
import { seoPathKey } from "@/lib/seo-path";
import { useQuery } from "@tanstack/react-query";
import { FileRoute } from "@tanstack/react-router";

export const Route = new FileRoute("/game/$path").createRoute({
  component: Game,
  errorComponent: ErrorPage,
});

function Game() {
  const { path } = Route.useParams();
  const gameId = seoPathKey(path);

  const { data, isLoading } = useQuery(gameQuery(gameId));

  return (
    <div>
      <h1>Game</h1>
      <p>Game ID: {gameId}</p>

      {isLoading && <p>Loading...</p>}

      {!isLoading && data && (
        <code>{JSON.stringify({ data, isLoading }, null, 2)}</code>
      )}
    </div>
  );
}
