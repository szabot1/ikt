import ErrorPage from "@/error-page";
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
  return <span>Seller</span>;
}
