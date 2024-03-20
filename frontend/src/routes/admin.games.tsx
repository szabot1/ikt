import { AdminRoute } from "@/components/auth/protected";
import { Button } from "@/components/ui/button";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { toast } from "@/components/ui/use-toast";
import ErrorPage from "@/error-page";
import { localDate } from "@/lib/date";
import { adminGamesQuery, deleteGame } from "@/lib/query/admin";
import { type Game } from "@/lib/query/games";
import { useQuery, useQueryClient } from "@tanstack/react-query";
import { FileRoute, redirect } from "@tanstack/react-router";
import {
  ColumnDef,
  flexRender,
  getCoreRowModel,
  getFilteredRowModel,
  getPaginationRowModel,
  getSortedRowModel,
  useReactTable,
} from "@tanstack/react-table";
import { MoreHorizontal } from "lucide-react";
import { Helmet } from "react-helmet-async";

export const Route = new FileRoute("/admin/games").createRoute({
  component: Admin,
  errorComponent: ErrorPage,
  beforeLoad: async ({ context: { auth } }) => {
    if (!auth.isAuthenticated) {
      throw redirect({
        to: "/auth/signin",
        search: {
          redirect: "/admin/games",
        },
      });
    }
  },
});

function Admin() {
  return (
    <AdminRoute>
      <Inner />
    </AdminRoute>
  );
}

function Inner() {
  const queryClient = useQueryClient();

  const { data, isLoading } = useQuery(adminGamesQuery);
  let games = data as Game[];

  const columns: ColumnDef<Game>[] = [
    {
      accessorKey: "slug",
      header: "Slug",
      cell: ({ row }) => <div>{row.getValue("slug")}</div>,
    },
    {
      accessorKey: "name",
      header: "Name",
      cell: ({ row }) => (
        <div className="capitalize">{row.getValue("name")}</div>
      ),
    },
    {
      accessorKey: "createdAt",
      header: "Created at",
      cell: ({ row }) => <div>{localDate(row.getValue("createdAt"))}</div>,
    },
    {
      accessorKey: "isActive",
      header: "Active",
      cell: ({ row }) => <div>{row.getValue("isActive") ? "Yes" : "No"}</div>,
    },
    {
      accessorKey: "isFeatured",
      header: "Featured",
      cell: ({ row }) => <div>{row.getValue("isFeatured") ? "Yes" : "No"}</div>,
    },
    {
      id: "actions",
      enableHiding: false,
      cell: ({ row }) => {
        const game = row.original;

        return (
          <DropdownMenu>
            <DropdownMenuTrigger asChild>
              <Button variant="ghost" className="h-8 w-8 p-0">
                <span className="sr-only">Open menu</span>
                <MoreHorizontal className="h-4 w-4" />
              </Button>
            </DropdownMenuTrigger>
            <DropdownMenuContent align="end">
              <DropdownMenuLabel>Actions</DropdownMenuLabel>
              <DropdownMenuItem
                onClick={() => navigator.clipboard.writeText(game.id)}
              >
                Copy ID
              </DropdownMenuItem>
              <DropdownMenuItem
                className="text-red-500"
                onClick={() => {
                  deleteGame(game.id).then(() => {
                    toast({ title: "Game deleted successfully" });

                    games = games.filter((g) => g.id !== game.id);
                    queryClient.setQueryData(adminGamesQuery.queryKey, games);
                  });
                }}
              >
                Delete game
              </DropdownMenuItem>
            </DropdownMenuContent>
          </DropdownMenu>
        );
      },
    },
  ];

  const table = useReactTable({
    data: games ?? [],
    columns,
    getCoreRowModel: getCoreRowModel(),
    getPaginationRowModel: getPaginationRowModel(),
    getSortedRowModel: getSortedRowModel(),
    getFilteredRowModel: getFilteredRowModel(),
    initialState: {
      pagination: {
        pageSize: 5,
      },
    },
  });

  if (isLoading || !data) {
    return null;
  }

  return (
    <section className="grow flex flex-col lg:flex-row gap-4 lg:gap-12 items-center justify-center">
      <Helmet prioritizeSeoTags>
        <title>Admin - Games</title>
      </Helmet>

      <div className="px-6 py-3 w-11/12 md:w-10/12 lg:w-8/12">
        <div className="border-2 border-zinc-700 rounded-lg">
          <Table className="border-zinc-700">
            <TableHeader className="border-zinc-700">
              {table.getHeaderGroups().map((headerGroup) => (
                <TableRow className="border-zinc-700" key={headerGroup.id}>
                  {headerGroup.headers.map((header) => {
                    return (
                      <TableHead className="border-zinc-700" key={header.id}>
                        {header.isPlaceholder
                          ? null
                          : flexRender(
                              header.column.columnDef.header,
                              header.getContext()
                            )}
                      </TableHead>
                    );
                  })}
                </TableRow>
              ))}
            </TableHeader>
            <TableBody className="border-zinc-700">
              {table.getRowModel().rows?.length ? (
                table.getRowModel().rows.map((row) => (
                  <TableRow className="border-zinc-700" key={row.id}>
                    {row.getVisibleCells().map((cell) => (
                      <TableCell className="border-zinc-700" key={cell.id}>
                        {flexRender(
                          cell.column.columnDef.cell,
                          cell.getContext()
                        )}
                      </TableCell>
                    ))}
                  </TableRow>
                ))
              ) : (
                <TableRow className="border-zinc-700">
                  <TableCell
                    colSpan={columns.length}
                    className="h-24 text-center border-zinc-700"
                  >
                    No results.
                  </TableCell>
                </TableRow>
              )}
            </TableBody>
          </Table>
        </div>

        <div className="flex items-center justify-end space-x-2 py-4">
          <div className="space-x-2">
            <Button
              variant="outline"
              size="sm"
              onClick={() => table.previousPage()}
              disabled={!table.getCanPreviousPage()}
            >
              Previous
            </Button>
            <Button
              variant="outline"
              size="sm"
              onClick={() => table.nextPage()}
              disabled={!table.getCanNextPage()}
            >
              Next
            </Button>
          </div>
        </div>
      </div>
    </section>
  );
}
