import ErrorPage from "@/error-page";
import { type User as UserInfo, userInfoQuery } from "@/lib/query/auth";
import {
  type Offer,
  offersBySellerIdQuery,
  deleteOffer,
  offerTypesQuery,
  type OfferType,
  createOfferGameListQuery,
  createOffer,
  clearStock,
  addStockBulk,
} from "@/lib/query/offer";
import {
  type Seller,
  sellerMeQuery,
  setSellerDisplayName,
  setSellerImageUrl,
} from "@/lib/query/seller";
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
import {
  Image,
  Info,
  Loader,
  MoreHorizontal,
  PackageOpen,
  Pencil,
  Plus,
  User,
} from "lucide-react";
import { toast } from "@/components/ui/use-toast";
import { localDate } from "@/lib/date";
import { Helmet } from "react-helmet-async";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import { Label } from "@/components/ui/label";
import { Input } from "@/components/ui/input";
import { type Game } from "@/lib/query/games";
import {
  Select,
  SelectContent,
  SelectGroup,
  SelectItem,
  SelectLabel,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { useState } from "react";
import { type SubmitHandler, useForm, Controller } from "react-hook-form";
import { Textarea } from "@/components/ui/textarea";

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
          <>
            <DropdownMenu>
              <DropdownMenuTrigger asChild>
                <Button variant="ghost" className="h-8 w-8 p-0">
                  <span className="sr-only">Open menu</span>
                  <PackageOpen className="h-4 w-4" />
                </Button>
              </DropdownMenuTrigger>
              <DropdownMenuContent align="end">
                <DropdownMenuLabel>Actions</DropdownMenuLabel>

                <DropdownMenuItem onSelect={(e) => e.preventDefault()}>
                  <AddStockModal offer={offer}>
                    <span>Add Stock</span>
                  </AddStockModal>
                </DropdownMenuItem>

                <DropdownMenuItem
                  className="text-red-500"
                  onClick={() => {
                    clearStock(offer.id).then((error) => {
                      if (error == null) {
                        toast({ title: "Stock cleared successfully" });

                        queryClient.refetchQueries(
                          offersBySellerIdQuery(sellerInfo.id)
                        );
                      } else {
                        toast({
                          title: "An error occurred while clearing stock",
                          description: error + ". Please try again.",
                        });
                      }
                    });
                  }}
                >
                  Clear Stock
                </DropdownMenuItem>
              </DropdownMenuContent>
            </DropdownMenu>

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
          </>
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

            <EditProfileModal seller={sellerInfo}>
              <Pencil className="h-5 w-5 cursor-pointer" />
            </EditProfileModal>
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

              <span className="text-sm text-zinc-500">({sellerInfo.slug})</span>
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

            <CreateOfferModal sellerId={sellerInfo.id}>
              <Plus className="h-5 w-5 cursor-pointer" />
            </CreateOfferModal>
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

type EditProfileInputs = {
  displayName: string;
  imageUrl: string;
};

const EditProfileModal = ({
  seller,
  children,
}: {
  seller: Seller;
  children: React.ReactNode;
}) => {
  const queryClient = useQueryClient();

  const [isSubmitting, setIsSubmitting] = useState(false);

  const [open, setOpen] = useState(false);

  const { register, handleSubmit } = useForm<EditProfileInputs>();

  const onSubmit: SubmitHandler<EditProfileInputs> = (
    data: EditProfileInputs
  ) => {
    setIsSubmitting(true);

    const displayNamePromise =
      data.displayName !== seller.displayName
        ? setSellerDisplayName(data.displayName)
        : Promise.resolve(null);

    const imageUrlPromise =
      data.imageUrl !== seller.imageUrl
        ? setSellerImageUrl(data.imageUrl)
        : Promise.resolve(null);

    Promise.all([displayNamePromise, imageUrlPromise]).then((errors) => {
      if (errors.every((error) => error == null)) {
        toast({ title: "Profile updated successfully" });

        setIsSubmitting(false);
        setOpen(false);

        queryClient.refetchQueries(sellerMeQuery());
      } else {
        toast({
          title: "An error occurred while updating the profile",
          description: errors.join(". ") + ". Please try again.",
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
          <DialogTitle>Edit seller profile</DialogTitle>
          <DialogDescription>
            Edit your brand name, and profile image. Click the save button when
            you're done.
          </DialogDescription>
        </DialogHeader>

        <form
          id="edit-profile-form"
          className="grid gap-4 py-4"
          onSubmit={handleSubmit(onSubmit)}
        >
          <div className="flex flex-row items-center justify-center gap-2 w-full">
            <User className="w-6 h-6" />

            <Input
              type="text"
              placeholder="Display name"
              defaultValue={seller.displayName}
              {...register("displayName", { required: true })}
            />
          </div>

          <div className="flex flex-row items-center justify-center gap-2 w-full">
            <Image className="w-6 h-6" />

            <Input
              type="text"
              placeholder="Profile image URL"
              defaultValue={seller.imageUrl}
              {...register("imageUrl", { required: true })}
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
            <span>Save changes</span>
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
};

type AddInputs = {
  items: string;
};

const AddStockModal = ({
  offer,
  children,
}: {
  offer: Offer;
  children: React.ReactNode;
}) => {
  const [isSubmitting, setIsSubmitting] = useState(false);

  const [open, setOpen] = useState(false);

  const { register, control, handleSubmit } = useForm<AddInputs>();

  const onSubmit: SubmitHandler<AddInputs> = (data: AddInputs) => {
    setIsSubmitting(true);

    const items = data.items.split("\n").filter((item) => item.trim() !== "");

    addStockBulk({
      offerId: offer.id,
      items,
    }).then((error) => {
      if (error == null) {
        toast({ title: "Stock added successfully" });

        setIsSubmitting(false);
        setOpen(false);
      } else {
        toast({
          title: "An error occurred while adding stock",
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
          <DialogTitle>Add stock</DialogTitle>
          <DialogDescription>
            Add stock for an offer. Every line is treated as a new item. Click
            the add button when you're done.
          </DialogDescription>
        </DialogHeader>

        <form
          id={`add-stock-form-${offer.id}`}
          className="grid gap-4 py-4"
          onSubmit={handleSubmit(onSubmit)}
        >
          <Textarea
            placeholder="Items (one per line)"
            onKeyDown={(e) => {
              if (e.key === "Enter") {
                e.stopPropagation();
              }
            }}
            {...register("items", { required: true })}
          />
        </form>

        <DialogFooter>
          <Button
            type="submit"
            form={`add-stock-form-${offer.id}`}
            disabled={isSubmitting}
            className="flex flex-row items-center gap-2"
          >
            {isSubmitting && <Loader className="h-4 w-4 animate-spin" />}
            <span>Add stock</span>
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
};

type CreateInputs = {
  gameId: string;
  typeId: string;
  price: number;
};

const CreateOfferModal = ({
  sellerId,
  children,
}: {
  sellerId: string;
  children: React.ReactNode;
}) => {
  const queryClient = useQueryClient();

  const { data: gamesData, isLoading: gamesLoading } = useQuery(
    createOfferGameListQuery
  );
  let games = gamesData as Game[];

  const { data: offerTypesData, isLoading: offerTypesLoading } =
    useQuery(offerTypesQuery);
  let offerTypes = offerTypesData as OfferType[];

  const [isSubmitting, setIsSubmitting] = useState(false);

  const [open, setOpen] = useState(false);

  const { register, control, handleSubmit } = useForm<CreateInputs>();

  const onSubmit: SubmitHandler<CreateInputs> = (data: CreateInputs) => {
    setIsSubmitting(true);

    const cents = Math.round(data.price * 100);

    if (cents <= 0 || isNaN(cents)) {
      toast({
        title: "Invalid price",
        description: "Please enter a valid price greater than 0.",
      });

      setIsSubmitting(false);
      return;
    }

    createOffer(data.gameId, data.typeId, cents).then((error) => {
      if (error == null) {
        toast({ title: "Offer created successfully" });

        queryClient.refetchQueries(sellerMeQuery());
        queryClient.refetchQueries(offersBySellerIdQuery(sellerId));

        setIsSubmitting(false);
        setOpen(false);
      } else {
        toast({
          title: "An error occurred while creating the offer",
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
          <DialogTitle>Create offer</DialogTitle>
          <DialogDescription>
            Create a new offer for a game. Click the create button when you're
            done.
          </DialogDescription>
        </DialogHeader>

        <form
          id="create-offer-form"
          className="grid gap-4 py-4"
          onSubmit={handleSubmit(onSubmit)}
        >
          <Controller
            name="gameId"
            control={control}
            render={({ field }) => (
              <Select onValueChange={field.onChange}>
                <SelectTrigger>
                  <SelectValue placeholder="Select a game" />
                </SelectTrigger>
                <SelectContent>
                  <SelectGroup>
                    {gamesLoading || !games ? (
                      <SelectLabel>
                        <Loader className="h-4 w-4 animate-spin" />
                      </SelectLabel>
                    ) : (
                      <>
                        <SelectLabel>Games</SelectLabel>

                        {games.map((game) => (
                          <SelectItem key={game.id} value={game.id}>
                            {game.name}
                          </SelectItem>
                        ))}
                      </>
                    )}
                  </SelectGroup>
                </SelectContent>
              </Select>
            )}
          />

          <Controller
            name="typeId"
            control={control}
            render={({ field }) => (
              <Select onValueChange={field.onChange}>
                <SelectTrigger>
                  <SelectValue placeholder="Select a delivery type" />
                </SelectTrigger>
                <SelectContent>
                  <SelectGroup>
                    {offerTypesLoading || !offerTypes ? (
                      <SelectLabel>
                        <Loader className="h-4 w-4 animate-spin" />
                      </SelectLabel>
                    ) : (
                      <>
                        <SelectLabel>Delivery types</SelectLabel>

                        {offerTypes.map((offerType) => (
                          <SelectItem key={offerType.id} value={offerType.id}>
                            {offerType.name} ({offerType.slug})
                          </SelectItem>
                        ))}
                      </>
                    )}
                  </SelectGroup>
                </SelectContent>
              </Select>
            )}
          />

          <Input
            type="number"
            min={0.01}
            step={"any"}
            placeholder="Price in USD (e.g. 9.99)"
            {...register("price", { required: true })}
          />
        </form>

        <DialogFooter>
          <Button
            type="submit"
            form="create-offer-form"
            disabled={isSubmitting}
            className="flex flex-row items-center gap-2"
          >
            {isSubmitting && <Loader className="h-4 w-4 animate-spin" />}
            <span>Create offer</span>
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
};
