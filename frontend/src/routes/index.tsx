import GameList, {
  gameToListedGame,
} from "@/components/routes/index/game-list";
import SearchForm from "@/components/routes/index/search-form";
import ErrorPage from "@/error-page";
import {
  Game,
  discountedGamesQuery,
  featuredGamesQuery,
  recentlyUpdatedGamesQuery,
} from "@/lib/query/games";
import { useQuery } from "@tanstack/react-query";
import { FileRoute } from "@tanstack/react-router";

export const Route = new FileRoute("/").createRoute({
  component: Index,
  errorComponent: ErrorPage,
});

function Index() {
  return (
    <section className="flex flex-col gap-16 p-4 place-items-center mt-16">
      <section className="w-full max-w-full lg:max-w-2xl">
        <SearchForm />
      </section>
      <section className="w-full flex flex-col lg:flex-row gap-8 max-w-full lg:max-w-5xl">
        <FeaturedGames />
        <RecentlyUpdatedGames />
        <DiscountedGames />
      </section>
    </section>
  );
}

const FeaturedGames = () => {
  const { data, isLoading } = useQuery(featuredGamesQuery());
  const games = data as Game[] | undefined;

  return (
    <GameList
      title="Featured Games"
      isLoaded={!isLoading && games ? true : false}
      games={!isLoading && games ? games.map(gameToListedGame) : []}
    />
  );
};

const RecentlyUpdatedGames = () => {
  const { data, isLoading } = useQuery(recentlyUpdatedGamesQuery());
  const games = data as Game[] | undefined;

  return (
    <GameList
      title="Recently Updated Games"
      isLoaded={!isLoading && games ? true : false}
      games={!isLoading && games ? games.map(gameToListedGame) : []}
    />
  );
};

const DiscountedGames = () => {
  const { data, isLoading } = useQuery(discountedGamesQuery());
  const games = data as Game[] | undefined;

  return (
    <GameList
      title="Discounted Games"
      isLoaded={!isLoading && games ? true : false}
      games={!isLoading && games ? games.map(gameToListedGame) : []}
    />
  );
};
