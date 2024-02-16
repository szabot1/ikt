import ErrorPage from "@/error-page";
import { Game, featuredGamesQuery } from "@/lib/query/games";
import { useQuery } from "@tanstack/react-query";
import { FileRoute, redirect, useNavigate } from "@tanstack/react-router";
import { Helmet } from "react-helmet-async";
import { z } from "zod";

const searchSchema = z.object({
  q: z.string(),
});

export const Route = new FileRoute("/search").createRoute({
  component: Search,
  errorComponent: ErrorPage,
  validateSearch: (search) => searchSchema.parse(search),
});

function Search() {
  const navigate = useNavigate();

  const { q } = Route.useSearch();
  const showResults = q.length > 0;

  const { data, isLoading } = useQuery(featuredGamesQuery());
  const games = data as Game[] | undefined;

  return (
    <section className="grow flex flex-col gap-16 p-4 items-center mt-16">
      <Helmet prioritizeSeoTags>
        <title>Search</title>
      </Helmet>

      <div className="w-full max-w-full lg:max-w-2xl">
        <form
          onSubmit={(e) => {
            e.preventDefault();

            navigate({
              to: "/search",
              search: { q: e.currentTarget.search.value },
            });
          }}
        >
          <input
            type="text"
            name="search"
            defaultValue={q}
            placeholder="Search for a game..."
            className="w-full h-16 rounded-xl bg-transparent border-2 border-zinc-700 focus:border-green-700 px-6 py-4 ring-0 focus:ring-0 outline-none focus:outline-none transition-all duration-100"
          />
        </form>
      </div>

      {showResults && (
        <>
          <div className="h-[1px] w-full max-w-full lg:max-w-3xl bg-zinc-700" />

          <div className="w-full max-w-full lg:max-w-2xl">
            <ul>
              {games &&
                !isLoading &&
                games?.map((game) => <SearchItem key={game.id} game={game} />)}
            </ul>
          </div>
        </>
      )}
    </section>
  );
}

type SearchItemProps = {
  game: Game;
};

function SearchItem({ game }: SearchItemProps) {
  return (
    <div className="group cursor-pointer border-2 border-zinc-700 w-full min-h-12 rounded-xl px-6 py-3 flex flex-row justify-between hover:scale-105 hover:-translate-y-1 transition-all duration-200">
      <div className="w-10/12 flex flex-col">
        <h2 className="text-xl font-semibold">{game.name}</h2>
        <p className="text-zinc-400 line-clamp-1 text-ellipsis">
          {game.description}
        </p>
      </div>

      <div className="w-2/12 flex justify-end items-center">
        <span className="text-green-500 group-hover:text-green-400 transition-all duration-200">
          5 offers
        </span>
      </div>
    </div>
  );
}
