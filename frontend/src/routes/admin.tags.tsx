import { AdminRoute } from "@/components/auth/protected";
import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { Input } from "@/components/ui/input";
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
import { adminTagsQuery, deleteTag } from "@/lib/query/admin";
import { createTag, type Tag } from "@/lib/query/tags";
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
import { Loader, MoreHorizontal, Plus, Tag as TagIcon } from "lucide-react";
import { useState } from "react";
import { Helmet } from "react-helmet-async";
import { type SubmitHandler, useForm } from "react-hook-form";

export const Route = new FileRoute("/admin/tags").createRoute({
  component: Admin,
  errorComponent: ErrorPage,
  beforeLoad: async ({ context: { auth } }) => {
    if (!auth.isAuthenticated) {
      throw redirect({
        to: "/auth/signin",
        search: {
          redirect: "/admin/tags",
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

  const { data, isLoading } = useQuery(adminTagsQuery);
  let tags = data as Tag[];

  const columns: ColumnDef<Tag>[] = [
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
      id: "actions",
      enableHiding: false,
      cell: ({ row }) => {
        const tag = row.original;

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
                onClick={() => navigator.clipboard.writeText(tag.id)}
              >
                Copy ID
              </DropdownMenuItem>
              <DropdownMenuItem
                className="text-red-500"
                onClick={() => {
                  deleteTag(tag.id).then(() => {
                    toast({ title: "Tag deleted successfully" });

                    tags = tags.filter((t) => t.id !== tag.id);
                    queryClient.setQueryData(adminTagsQuery.queryKey, tags);
                  });
                }}
              >
                Delete tag
              </DropdownMenuItem>
            </DropdownMenuContent>
          </DropdownMenu>
        );
      },
    },
  ];

  const table = useReactTable({
    data: tags ?? [],
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
        <title>Admin - Tags</title>
      </Helmet>

      <div className="px-6 py-3 w-11/12 md:w-10/12 lg:w-8/12">
        <div className="flex flex-row justify-between mb-4">
          <h1 className="text-xl font-semibold">Tags</h1>

          <CreateTagModal>
            <Plus className="h-5 w-5 cursor-pointer" />
          </CreateTagModal>
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

type CreateTagInputs = {
  name: string;
};

const CreateTagModal = ({ children }: { children: React.ReactNode }) => {
  const queryClient = useQueryClient();

  const [isSubmitting, setIsSubmitting] = useState(false);

  const [open, setOpen] = useState(false);

  const { register, handleSubmit } = useForm<CreateTagInputs>();

  const onSubmit: SubmitHandler<CreateTagInputs> = (data: CreateTagInputs) => {
    setIsSubmitting(true);

    createTag(data.name).then((error) => {
      if (error == null) {
        toast({ title: "Tag created successfully" });

        setIsSubmitting(false);
        setOpen(false);

        queryClient.invalidateQueries(adminTagsQuery);
      } else {
        toast({
          title: "An error occurred while creating the tag",
          description: error + ". Please try again.",
        });

        setIsSubmitting(false);
      }
    });
  };

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger asChild>{children}</DialogTrigger>
      <DialogContent className="sm:max-w-[425px]">
        <DialogHeader>
          <DialogTitle>Create tag</DialogTitle>
          <DialogDescription>
            Enter the details of the new tag. Click the create button when
            you're done.
          </DialogDescription>
        </DialogHeader>

        <form
          id="edit-profile-form"
          className="grid gap-4 py-4"
          onSubmit={handleSubmit(onSubmit)}
        >
          <div className="flex flex-row items-center justify-center gap-2 w-full">
            <TagIcon className="w-6 h-6" />

            <Input
              type="text"
              placeholder="Name"
              {...register("name", { required: true })}
            />
          </div>
        </form>

        <DialogFooter>
          <Button
            type="submit"
            form="edit-profile-form"
            disabled={isSubmitting}
            className="flex flex-row items-center gap-2"
          >
            {isSubmitting && <Loader className="h-4 w-4 animate-spin" />}
            <span>Create tag</span>
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
};
