import ErrorPage from "@/error-page";
import { Game, gameQuery } from "@/lib/query/games";
import { seoPath, seoPathKey } from "@/lib/seo-path";
import { useQuery } from "@tanstack/react-query";
import { FileRoute } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { Helmet } from "react-helmet-async";

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
      {game && (
        <Helmet prioritizeSeoTags>
          <title>Game - {game.name}</title>
          <link
            rel="canonical"
            href={`${import.meta.env.VITE_FRONTEND_PROD_URL}/game/${seoPath(game.id, game.name)}`}
          />
          <meta name="description" content={game.description} />
          <meta property="og:title" content={game.name} />
          <meta property="og:description" content={game.description} />
          <meta property="og:image" content={game.images[count].imageUrl} />
          <meta property="og:url" content={window.location.href} />
        </Helmet>
      )}

      {isLoading && <p>Loading...</p>}

      {!isLoading && game && (
        <div className="flex items-center justify-center gap-4">
          <section className="flex items-start justify-start mt-8 ml-5">
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
                  <span
                    key={tag.tag.name}
                    className="inline-block bg-inherit rounded-full px-3 py-1 text-sm font-semibold text-white mr-2 mb-2"
                  >
                    #{tag.tag.name}
                  </span>
                ))}
              </div>
            </div>
          </section>
          <div className="grid grid-cols-1 place-items-right divide-y ml-5 mt-8 divide-slate-700">
            {game.tags.map((tag) => (
              <div className="py-6 flex gap-2">
                <span>
                  Lorem Ipsum is simply dummy text of the printing and
                  typesetting industry. Lorem Ipsum has been the industry's
                </span>
                <button className="bg-green-600 text-gray font-bold py-2 px-5  hover:border-gray-600 rounded-lg  mr-2">
                  Buy
                </button>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}
