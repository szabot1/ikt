import { AdminRoute } from "@/components/auth/protected";
import { Badge } from "@/components/ui/badge";
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
import {
  type AdminUser,
  adminUsersQuery,
  deleteSeller,
} from "@/lib/query/admin";
import { createSellerProfile, sellerMeQuery } from "@/lib/query/seller";
import { useQuery, useQueryClient } from "@tanstack/react-query";
import { FileRoute, redirect, useNavigate } from "@tanstack/react-router";
import {
  ColumnDef,
  flexRender,
  getCoreRowModel,
  getFilteredRowModel,
  getPaginationRowModel,
  getSortedRowModel,
  useReactTable,
} from "@tanstack/react-table";
import { Loader, MoreHorizontal } from "lucide-react";
import { Helmet } from "react-helmet-async";

export const Route = new FileRoute("/admin/users").createRoute({
  component: Admin,
  errorComponent: ErrorPage,
  beforeLoad: async ({ context: { auth } }) => {
    if (!auth.isAuthenticated) {
      throw redirect({
        to: "/auth/signin",
        search: {
          redirect: "/admin/users",
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

const roleStyles: Record<string, [string, string]> = {
  support: ["Support", "!bg-blue-500 !text-blue-100"],
  admin: ["Admin", "!bg-red-500 !text-red-100"],
  user: ["User", "!bg-green-500 !text-green-100"],
};

function Inner() {
  const queryClient = useQueryClient();
  const navigate = useNavigate();

  const { data, isLoading } = useQuery(adminUsersQuery);
  let users = data as AdminUser[];

  const columns: ColumnDef<AdminUser>[] = [
    {
      accessorKey: "email",
      header: "Email",
      cell: ({ row }) => <div>{row.getValue("email")}</div>,
    },
    {
      accessorKey: "username",
      header: "Username",
      cell: ({ row }) => <div>{row.getValue("username")}</div>,
    },
    {
      accessorKey: "createdAt",
      header: "Register date",
      cell: ({ row }) => <div>{localDate(row.getValue("createdAt"))}</div>,
    },
    {
      accessorKey: "role",
      header: "Role",
      cell: ({ row }) => {
        const role = row.getValue("role") as string;
        const [text, style] = roleStyles[role] || [role, "!bg-gray-500"];

        return <Badge className={style}>{text}</Badge>;
      },
    },
    {
      id: "actions",
      enableHiding: false,
      cell: ({ row }) => {
        const user = row.original;

        return (
          <DropdownMenu>
            <DropdownMenuTrigger asChild>
              <Button variant="ghost" className="h-8 w-8 p-0 float-right">
                <span className="sr-only">Open menu</span>
                <MoreHorizontal className="h-4 w-4" />
              </Button>
            </DropdownMenuTrigger>
            <DropdownMenuContent align="end">
              <DropdownMenuLabel>Actions</DropdownMenuLabel>
              <DropdownMenuItem
                onClick={() => navigator.clipboard.writeText(user.id)}
              >
                Copy ID
              </DropdownMenuItem>

              {!user.seller ? (
                <DropdownMenuItem
                  className="text-green-500"
                  onClick={() => {
                    createSellerProfile(user.id).then(() => {
                      toast({ title: "Seller profile created successfully" });

                      queryClient.refetchQueries(sellerMeQuery());
                      queryClient.refetchQueries(adminUsersQuery);
                    });
                  }}
                >
                  Create Seller Profile
                </DropdownMenuItem>
              ) : (
                <DropdownMenuItem
                  className="text-red-500"
                  onClick={() => {
                    deleteSeller(user.seller!.id).then(() => {
                      toast({ title: "Seller profile deleted successfully" });

                      queryClient.refetchQueries(sellerMeQuery());
                      queryClient.refetchQueries(adminUsersQuery);
                    });
                  }}
                >
                  Delete Seller Profile
                </DropdownMenuItem>
              )}
            </DropdownMenuContent>
          </DropdownMenu>
        );
      },
    },
  ];

  const table = useReactTable({
    data: users ?? [],
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
    return (
      <div className="flex items-center justify-center w-full h-full grow">
        <Loader className="h-4 w-4 animate-spin" />
      </div>
    );
  }

  return (
    <section className="grow flex flex-col lg:flex-row gap-4 lg:gap-12 items-center justify-center">
      <Helmet prioritizeSeoTags>
        <title>Admin - Users</title>
      </Helmet>

      <div className="px-6 py-3 w-11/12 md:w-10/12 lg:w-8/12">
        <div className="flex flex-row justify-between mb-4">
          <h1 className="text-xl font-semibold">Users</h1>
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
  );
}
