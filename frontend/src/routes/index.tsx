import GameList from "@/components/routes/index/game-list";
import Search from "@/components/routes/index/search";
import ErrorPage from "@/error-page";
import { FileRoute } from "@tanstack/react-router";

export const Route = new FileRoute("/").createRoute({
  component: Index,
  errorComponent: ErrorPage,
});

function Index() {
  return (
    <section className="flex flex-col gap-16 p-4 place-items-center">
      <section className="w-full max-w-full lg:max-w-2xl">
        <Search />
      </section>
      <section className="w-full grid grid-cols-1 lg:grid-cols-3 gap-8 max-w-full lg:max-w-5xl">
        <PopularGames />
        <RecentlyUpdatedGames />
        <DiscountedGames />
      </section>
    </section>
  );
}

const PopularGames = () => {
  return (
    <GameList
      title="Popular Games"
      games={[
        {
          id: "fcfmf9p8szc7bvtirbv6mspn",
          displayName: "Counter-Strike 2",
          description:
            "For over two decades, Counter-Strike has offered an elite competitive experience, one shaped by millions of players from across the globe. And now the next chapter in the CS story is about to begin. This is Counter-Strike 2. A free upgrade to CS:GO, Counter-Strike 2 marks the largest technical leap in Counter-Strike’s history. Built on the Source 2 engine, Counter-Strike 2 is modernized with realistic physically-based rendering, state of the art networking, and upgraded Community Workshop tools.",
          imageUrl:
            "https://cdn.cloudflare.steamstatic.com/steam/apps/730/header.jpg?t=1627994920",
        },
      ]}
    />
  );
};

const RecentlyUpdatedGames = () => {
  return (
    <GameList
      title="Recently Updated Games"
      games={[
        {
          id: "fcfmf9p8szc7bvtirbv6mspn",
          displayName: "Counter-Strike 2",
          description:
            "For over two decades, Counter-Strike has offered an elite competitive experience, one shaped by millions of players from across the globe. And now the next chapter in the CS story is about to begin. This is Counter-Strike 2. A free upgrade to CS:GO, Counter-Strike 2 marks the largest technical leap in Counter-Strike’s history. Built on the Source 2 engine, Counter-Strike 2 is modernized with realistic physically-based rendering, state of the art networking, and upgraded Community Workshop tools.",
          imageUrl:
            "https://cdn.cloudflare.steamstatic.com/steam/apps/730/header.jpg?t=1627994920",
        },
      ]}
    />
  );
};

const DiscountedGames = () => {
  return (
    <GameList
      title="Discounted Games"
      games={[
        {
          id: "fcfmf9p8szc7bvtirbv6mspn",
          displayName: "Counter-Strike 2",
          description:
            "For over two decades, Counter-Strike has offered an elite competitive experience, one shaped by millions of players from across the globe. And now the next chapter in the CS story is about to begin. This is Counter-Strike 2. A free upgrade to CS:GO, Counter-Strike 2 marks the largest technical leap in Counter-Strike’s history. Built on the Source 2 engine, Counter-Strike 2 is modernized with realistic physically-based rendering, state of the art networking, and upgraded Community Workshop tools.",
          imageUrl:
            "https://cdn.cloudflare.steamstatic.com/steam/apps/730/header.jpg?t=1627994920",
        },
      ]}
    />
  );
};
