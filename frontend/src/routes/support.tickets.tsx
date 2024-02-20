import { AdminRoute } from "@/components/auth/protected";
import ErrorPage from "@/error-page";
import { FileRoute, redirect } from "@tanstack/react-router";

export const Route = new FileRoute("/support/tickets").createRoute({
  component: SupportTickets,
  errorComponent: ErrorPage,
  beforeLoad: async ({ context: { auth } }) => {
    if (!auth.isAuthenticated) {
      throw redirect({
        to: "/auth/signin",
        search: {
          redirect: "/support/tickets",
        },
      });
    }
  },
});

function SupportTickets() {
  return (
    <AdminRoute>
      <Inner />
    </AdminRoute>
  );
}

function Inner() {
  return <div>Support Tickets Page</div>;
}
