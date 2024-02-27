import ErrorPage from "@/error-page";
import { type User as UserInfo, userInfoQuery } from "@/lib/query/auth";
import {
  type Offer,
  offersBySellerIdQuery,
  deleteOffer,
} from "@/lib/query/offer";
import { type Seller, sellerMeQuery } from "@/lib/query/seller";
import { cn } from "@/lib/style";
import { useQuery, useQueryClient } from "@tanstack/react-query";
import { FileRoute, redirect } from "@tanstack/react-router";
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
import {
  ColumnDef,
  flexRender,
  getCoreRowModel,
  getFilteredRowModel,
  getPaginationRowModel,
  getSortedRowModel,
  useReactTable,
} from "@tanstack/react-table";
import { Button } from "@/components/ui/button";
import { MoreHorizontal, Pencil, Plus } from "lucide-react";
import { toast } from "@/components/ui/use-toast";
import { localDate } from "@/lib/date";
import { Helmet } from "react-helmet-async";

export const Route = new FileRoute("/seller").createRoute({
  component: Seller,
  errorComponent: ErrorPage,
  beforeLoad: async ({ context: { auth } }) => {
    if (!auth.isAuthenticated) {
      throw redirect({
        to: "/auth/signin",
        search: {
          redirect: "/seller",
        },
      });
    }
  },
});

function Seller() {
  const queryClient = useQueryClient();

  const { data: userData, isLoading: userIsLoading } =
    useQuery(userInfoQuery());
  const userInfo = userData as UserInfo;

  const { data: sellerData, isLoading: sellerIsLoading } =
    useQuery(sellerMeQuery());
  const sellerInfo = sellerData as Seller;

  const { data: offerData, isLoading: offersAreLoading } = useQuery(
    //@ts-ignore
    sellerInfo ? offersBySellerIdQuery(sellerInfo.id) : null
  );
  const offers = offerData as Offer[];

  const columns: ColumnDef<Offer>[] = [
    {
      accessorKey: "id",
      header: "ID",
      cell: ({ row }) => <div>{row.getValue("id")}</div>,
    },
    {
      accessorKey: "gameId",
      header: "Game ID",
      cell: ({ row }) => <div>{row.getValue("gameId")}</div>,
    },
    {
      accessorKey: "price",
      header: "Price",
      cell: ({ row }) => <div>${Number(row.getValue("price")) / 100}</div>,
    },
    {
      accessorKey: "createdAt",
      header: "Created at",
      cell: ({ row }) => <div>{localDate(row.getValue("createdAt"))}</div>,
    },
    {
      id: "actions",
      enableHiding: false,
      cell: ({ row }) => {
        const offer = row.original;

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
                onClick={() => navigator.clipboard.writeText(offer.id)}
              >
                Copy ID
              </DropdownMenuItem>

              <DropdownMenuItem
                className="text-red-500"
                onClick={() => {
                  deleteOffer(offer.id).then(() => {
                    toast({ title: "Offer deleted successfully" });

                    queryClient.refetchQueries(
                      offersBySellerIdQuery(sellerInfo.id)
                    );
                  });
                }}
              >
                Delete Offer
              </DropdownMenuItem>
            </DropdownMenuContent>
          </DropdownMenu>
        );
      },
    },
  ];

  const table = useReactTable({
    data: offers ?? [],
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

  if (userIsLoading || !userInfo) {
    return null;
  }

  if (sellerIsLoading || !sellerInfo) {
    return null;
  }

  if (offersAreLoading || !offers) {
    return null;
  }

  return (
    <main className="grow flex flex-col lg:flex-row gap-4 lg:gap-12 items-center justify-center">
      <Helmet prioritizeSeoTags>
        <title>Seller</title>
      </Helmet>

      {sellerInfo.isClosed && (
        <div className="bg-red-700 text-white p-4 text-center mb-8">
          Your seller account has been closed. Contact support if you believe
          this is an error.
        </div>
      )}

      <section
        className={cn(
          "flex flex-col lg:flex-row gap-16 p-4 items-center justify-center w-full",
          sellerInfo.isClosed &&
            "filter blur-sm pointer-events-none select-none"
        )}
      >
        <div className="px-6 py-3 border-2 border-zinc-700 rounded-lg w-10/12 md:w-6/12 lg:w-3/12 flex flex-col gap-2">
          <div className="flex flex-row justify-between mb-4">
            <h1 className="text-xl font-semibold">Profile</h1>

            <Pencil className="h-5 w-5 cursor-pointer" onClick={() => {}} />
          </div>

          <div className="flex items-center justify-center flex-col gap-2">
            <img
              src={sellerInfo.imageUrl}
              alt="Seller image"
              className="w-24 h-24"
            />

            <h2 className="flex flex-row gap-1 items-center justify-center">
              <span className="text-lg font-semibold">
                {sellerInfo.displayName}
              </span>

              <span className="text-sm text-gray-500">({sellerInfo.slug})</span>
            </h2>

            <span
              className={cn(
                "px-2 py-1 rounded-md",
                sellerInfo.isVerified
                  ? "bg-green-500 text-green-100"
                  : "bg-orange-500 text-orange-100",
                "text-sm font-semibold"
              )}
            >
              {sellerInfo.isVerified ? "Verified seller" : "Unverified seller"}
            </span>
          </div>

          <div className="flex flex-col gap-2 mt-4">
            <span>
              <span className="font-semibold">Created at:</span>{" "}
              {localDate(sellerInfo.createdAt)}
            </span>
          </div>
        </div>

        <div className="flex flex-col gap-2 max-w-full">
          <div className="flex flex-row justify-between mb-4">
            <h1 className="text-xl font-semibold">Offers</h1>

            <Plus className="h-5 w-5 cursor-pointer" onClick={() => {}} />
          </div>

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
    </main>
  );
}
