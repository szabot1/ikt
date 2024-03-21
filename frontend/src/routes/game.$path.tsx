import ErrorPage from "@/error-page";
import { checkout } from "@/lib/query/billing";
import { type Game, gameQuery } from "@/lib/query/games";
import { type Offer, offersByGameIdQuery } from "@/lib/query/offer";
import { seoPath, seoPathKey } from "@/lib/seo-path";
import { cn } from "@/lib/style";
import { useQuery } from "@tanstack/react-query";
import { FileRoute } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { Helmet } from "react-helmet-async";

export const Route = new FileRoute("/game/$path").createRoute({
  component: GameComponent,
  errorComponent: ErrorPage,
});

const hashToColor: Record<number, string> = {
  0: "bg-red-600",
  1: "bg-green-600",
  2: "bg-blue-600",
  3: "bg-yellow-600",
  4: "bg-indigo-600",
  5: "bg-purple-600",
  6: "bg-pink-600",
};

const getTagColor = (tagId: string) => {
  const hash = tagId
    .split("")
    .reduce((acc, char) => acc + char.charCodeAt(0), 0);
  return hashToColor[hash % 7];
};

function GameComponent() {
  const { path } = Route.useParams();
  const gameId = seoPathKey(path);

  const { data, isLoading } = useQuery(gameQuery(gameId));
  const game = data as Game | undefined;

  const { data: offersData, isLoading: offersLoading } = useQuery(
    offersByGameIdQuery(gameId)
  );
  const offers = offersData as Offer[] | undefined;

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
    <section className="flex flex-col lg:flex-row items-center justify-center gap-16 max-w-5xl mx-auto mt-8 grow">
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
        <>
          <div className="border-2 rounded-2xl border-zinc-700 overflow-hidden shadow-lg w-full lg:w-1/2">
            <img
              className="rounded-t-2xl w-full h-48"
              src={game.images[count].imageUrl}
              alt={game.name}
            ></img>
            <div className="px-6 py-4">
              <div className="font-bold text-xl mb-2">{game.name}</div>
              <p className="text-zinc-300 text-base line-clamp-4">
                {game.description}
              </p>
              <br></br>
              {game.tags.map((tag) => (
                <span
                  key={tag.tag.name}
                  className={cn(
                    "inline-block bg-inherit rounded-full px-3 py-1 text-sm font-semibold text-white mr-2 mb-2",
                    getTagColor(tag.tag.id)
                  )}
                >
                  #{tag.tag.name}
                </span>
              ))}
            </div>
          </div>

          <div className="flex flex-col gap-2 w-full lg:w-1/2">
            <h1 className="text-2xl font-semibold">Available Offers</h1>

            {offersLoading || !offers || offers.length === 0 ? (
              <div className="px-12 py-6 border-2 border-zinc-700 rounded-lg">
                <span className="text-red-500 text-sm">
                  There are no offers available for this game
                </span>
              </div>
            ) : (
              <div className="flex flex-col gap-4">
                {offers.map((offer) => (
                  <div className="px-4 py-2 border-2 border-zinc-700 rounded-lg flex items-center justify-between">
                    <div className="text-lg">
                      <p>Hidden Seller</p>
                    </div>

                    <div className="flex flex-row items-center justify-center gap-2">
                      <span>${offer.price / 100}</span>

                      <button
                        className="px-4 py-2 bg-green-700 rounded-lg hover:bg-green-600 transition-all duration-200 flex items-center justify-center"
                        onClick={() => {
                          checkout(offer.id).then((checkoutUrl) => {
                            window.location.href = checkoutUrl!;
                          });
                        }}
                      >
                        Purchase
                      </button>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>
        </>
      )}
    </section>
  );
}
