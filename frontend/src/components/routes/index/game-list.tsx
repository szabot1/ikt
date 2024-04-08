import { Table, TableBody, TableCell, TableRow } from "@/components/ui/table";
import { Game } from "@/lib/query/games";
import { seoPath } from "@/lib/seo-path";
import { useNavigate } from "@tanstack/react-router";
import { Loader } from "lucide-react";

export function gameToListedGame(game: Game): ListedGame {
  return {
    id: game.id,
    slug: game.slug,
    displayName: game.name,
    description: game.description,
    imageUrl:
      game.images.length > 0
        ? game.images[0].imageUrl
        : "https://placehold.co/600x400",
  };
}

export type ListedGame = {
  id: string;
  slug: string;
  displayName: string;
  description: string;
  imageUrl: string;
};

export type Props = {
  title: JSX.Element | string;
  isLoaded?: boolean;
  games: ListedGame[];
};

export default function GameList({ title, isLoaded, games }: Props) {
  const navigate = useNavigate();

  return (
    <div
      className={`basis-1/3 grow text-center space-y-6 ${(!isLoaded || games.length === 0) && "flex flex-col"}`}
    >
      <span className="font-semibold text-xl">{title}</span>

      <div
        className={`basis-1/3 grow rounded-xl bg-transparent border-2 border-zinc-700 text-center ${(!isLoaded || games.length === 0) && "flex flex-col"}`}
      >
        {!isLoaded ? (
          <span className="text-zinc-400 my-6 mx-6 flex items-center justify-center">
            <Loader className="h-4 w-4 animate-spin" />
          </span>
        ) : games.length === 0 ? (
          <span className="text-zinc-400 my-6 mx-6">No games found.</span>
        ) : (
          <Table className="border-separate border-spacing-4">
            <TableBody>
              {games.map((game) => (
                <TableRow
                  className="hover:bg-transparent cursor-pointer hover:text-cyan-500 border-none"
                  key={game.id}
                  onClick={() => {
                    navigate({
                      to: "/game/$path",
                      params: { path: seoPath(game.id, game.slug) },
                    });
                  }}
                >
                  <TableCell className="h-20 font-semibold text-xl relative [text-shadow:_0_2px_4px_rgb(0_0_0_/_100%)]">
                    <div
                      style={{
                        background:
                          "url(" + game.imageUrl + ") no-repeat center center",
                        backgroundSize: "cover",
                      }}
                      className="absolute w-full h-full top-0 left-0 -z-10 blur-[1px]"
                    ></div>

                    <span>{game.displayName}</span>
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        )}
      </div>
    </div>
  );
}
