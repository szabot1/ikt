import GameList, {
  gameToListedGame,
} from "@/components/routes/index/game-list";
import SearchForm from "@/components/routes/index/search-form";
import ErrorPage from "@/error-page";
import {
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
    <section className="flex flex-col gap-16 p-4 place-items-center">
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

  return (
    <GameList
      title="Featured Games"
      isLoaded={!isLoading && data ? true : false}
      games={!isLoading && data ? data.map(gameToListedGame) : []}
    />
  );
};

const RecentlyUpdatedGames = () => {
  const { data, isLoading } = useQuery(recentlyUpdatedGamesQuery());

  return (
    <GameList
      title="Recently Updated Games"
      isLoaded={!isLoading && data ? true : false}
      games={!isLoading && data ? data.map(gameToListedGame) : []}
    />
  );
};

const DiscountedGames = () => {
  const { data, isLoading } = useQuery(discountedGamesQuery());

  return (
    <GameList
      title="Discounted Games"
      isLoaded={!isLoading && data ? true : false}
      games={!isLoading && data ? data.map(gameToListedGame) : []}
    />
  );
};
