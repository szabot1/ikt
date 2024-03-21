import ErrorPage from "@/error-page";
import { userInfoQuery } from "@/lib/query/auth";
import { useQuery } from "@tanstack/react-query";
import { FileRoute, redirect } from "@tanstack/react-router";
import { type User as UserInfo } from "@/lib/query/auth";

export const Route = new FileRoute("/checkout/cancel").createRoute({
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
      <div className="px-6 py-3 border-2 border-red-700 rounded-lg w-10/12 md:w-6/12 lg:w-3/12 flex flex-col gap-2">
        <h1 className="text-xl font-semibold mb-4">Unsuccessful Payment</h1>
        <p className="mb-5">Dear {userInfo.username},</p>
        <p className="mb-5">
          We regret to inform you that your recent payment attempt was
          unsuccessful. We apologize for any inconvenience this may have caused.
          There could be various reasons for the failed transaction, including
          insufficient funds, incorrect payment details, or issues with the
          payment processor. We kindly ask you to double-check the payment
          information provided and ensure that all details are accurate. If the
          issue persists, we recommend contacting your bank or payment provider
          for further assistance. If you have any questions or require
          assistance, please don't hesitate to reach out to our customer support
          team. We're here to help resolve any issues and ensure a smooth
          shopping experience for you. Thank you for your understanding.
        </p>
        <p>Best regards, </p>
        <p className="mb-5">Game Key Store Team</p>
      </div>
    </div>
  );
}
