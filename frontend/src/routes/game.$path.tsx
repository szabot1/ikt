import ErrorPage from "@/error-page";
import { Game, gameQuery } from "@/lib/query/games";
import { seoPathKey } from "@/lib/seo-path";
import { useQuery } from "@tanstack/react-query";
import { FileRoute } from "@tanstack/react-router";

export const Route = new FileRoute("/game/$path").createRoute({
  component: GameComponent,
  errorComponent: ErrorPage,
});

function GameComponent() {
  const { path } = Route.useParams();
  const gameId = seoPathKey(path);

  const { data, isLoading } = useQuery(gameQuery(gameId));
  const game = data as Game | undefined;

  return (
    <div>
      <h1>Game</h1>
      <p>Game ID: {gameId}</p>

      {isLoading && <p>Loading...</p>}

      {!isLoading && game && (
        <code className="bg-orange-400">
          {JSON.stringify({ game, isLoading }, null, 2)}
        </code>
      )}
    </div>
  );
}
