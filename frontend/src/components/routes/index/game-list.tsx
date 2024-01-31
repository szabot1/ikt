import { Table, TableBody, TableCell, TableRow } from "@/components/ui/table";

export type ListedGame = {
  id: string;
  displayName: string;
  description: string;
  imageUrl: string;
};

export type Props = {
  title: JSX.Element | string;
  games: ListedGame[];
};

export default function GameList({ title, games }: Props) {
  return (
    <div className="rounded-xl bg-transparent border-2 border-gray-700 px-4 py-2 text-center space-y-4">
      <span className="font-semibold">{title}</span>

      <Table>
        <TableBody>
          {games.map((game) => (
            <TableRow
              className="hover:bg-transparent cursor-pointer hover:text-green-500"
              key={game.id}
            >
              <TableCell>
                <img src={game.imageUrl} />
              </TableCell>
              <TableCell className="w-6/12">{game.displayName}</TableCell>
              <TableCell>$0.99</TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>
    </div>
  );
}
