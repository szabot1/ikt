import ErrorPage from "@/error-page";
import { FileRoute, redirect } from "@tanstack/react-router";
import { userInfoQuery, type User as UserInfo } from "@/lib/query/auth";
import { useQuery } from "@tanstack/react-query";

export const Route = new FileRoute("/checkout/success").createRoute({
  component: CheckoutSuccess,
  errorComponent: ErrorPage,
  beforeLoad: async ({ context: { auth } }) => {
    if (!auth.isAuthenticated) {
      throw redirect({
        to: "/auth/signin",
        search: {
          redirect: "/checkout/success",
        },
      });
    }
  },
});

function CheckoutSuccess() {
  const { data, isLoading } = useQuery(userInfoQuery());
  const userInfo = data as UserInfo;
  return (
    <div className="flex justify-center items-center h-screen">
      <div className="px-6 py-3 border-2 border-green-700 rounded-lg w-10/12 md:w-6/12 lg:w-3/12 flex flex-col gap-2">
        <h1 className="text-xl font-semibold mb-4">Thank you</h1>
        <p className="mb-1">
          <p className="mb-5">Dear {userInfo.username},</p>
          <p className="mb-5">
            Thank you for choosing Game Key Store for your gaming needs! We
            appreciate your recent purchase and hope you're excited to dive into
            your new game. Your satisfaction is our priority, and we're here to
            assist you with any questions or concerns you may have. Don't
            hesitate to reach out to our customer support team if you need
            assistance. Enjoy your gaming experience, and we look forward to
            serving you again in the future.
          </p>
          <p>Best regards, </p>
          <p className="mb-5">Game Key Store Team</p>
        </p>
      </div>
    </div>
  );
}
