import ErrorPage from "@/error-page";
import { FileRoute, redirect } from "@tanstack/react-router";

export const Route = new FileRoute("/profile").createRoute({
  component: Profile,
  errorComponent: ErrorPage,
  beforeLoad: async ({ context: { auth } }) => {
    if (!auth.isAuthenticated) {
      throw redirect({
        to: "/auth/signin",
        search: {
          redirect: "/profile",
        },
      });
    }
  },
});

function Profile() {
  return <></>;
}
