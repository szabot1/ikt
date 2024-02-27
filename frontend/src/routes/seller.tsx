import ErrorPage from "@/error-page";
import { type User as UserInfo, userInfoQuery } from "@/lib/query/auth";
import { type Offer, offersBySellerIdQuery } from "@/lib/query/offer";
import { type Seller, sellerMeQuery } from "@/lib/query/seller";
import { cn } from "@/lib/style";
import { useQuery } from "@tanstack/react-query";
import { FileRoute, redirect } from "@tanstack/react-router";

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
          <h1 className="text-xl font-semibold mb-4">Account</h1>

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
              {new Date(sellerInfo.createdAt).toLocaleString()}
            </span>
          </div>
        </div>

        <div className="px-6 py-3 border-2 border-zinc-700 rounded-lg w-10/12 md:w-6/12 lg:w-3/12 flex flex-col gap-2">
          <h1 className="text-xl font-semibold mb-4">Offers</h1>

          <code className="whitespace-pre-wrap max-h-72 overflow-y-auto">
            {JSON.stringify(offers, null, 2)}
          </code>
        </div>
      </section>
    </main>
  );
}
