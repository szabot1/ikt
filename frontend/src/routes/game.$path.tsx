import ErrorPage from "@/error-page";
import { Game, gameQuery } from "@/lib/query/games";
import { seoPathKey } from "@/lib/seo-path";
import { useQuery } from "@tanstack/react-query";
import { FileRoute } from "@tanstack/react-router";
import { useEffect, useState } from "react";

export const Route = new FileRoute("/game/$path").createRoute({
  component: GameComponent,
  errorComponent: ErrorPage,
});

function GameComponent() {
  const { path } = Route.useParams();
  const gameId = seoPathKey(path);

  const { data, isLoading } = useQuery(gameQuery(gameId));
  const game = data as Game | undefined;

  const [count, setCount] = useState(0);

  useEffect(() => {
    const interval = setInterval(() => {
      if (count + 1 == game?.images.length) {
        setCount(0);
      } else {
        setCount(count + 1);
      }
    }, 10000);
    return () => clearInterval(interval);
  }, [count]);

  return (
    <div>
      {isLoading && <p>Loading...</p>}

      {!isLoading && game && (
        <section className="grow flex items-center justify-center">
          <div className="max-w-sm border-2 rounded-2xl border-zinc-700 overflow-hidden shadow-lg">
            <img
              className="w-full rounded-t-2xl"
              src={game.images[count].imageUrl}
              alt={game.name}
            ></img>
            <div className="px-6 py-4">
              <div className="font-bold text-xl mb-2">{game.name}</div>
              <p className="text-zinc-300 text-base">{game.description}</p>
              <br></br>
              {game.tags.map((tag) => (
                <span className="inline-block bg-inherit rounded-full px-3 py-1 text-sm font-semibold text-white mr-2 mb-2">
                  #{tag.tag.name}
                </span>
              ))}
            </div>
          </div>
        </section>
      )}
    </div>
  );
}
