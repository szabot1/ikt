import { AdminRoute } from "@/components/auth/protected";
import ErrorPage from "@/error-page";
import { FileRoute, redirect } from "@tanstack/react-router";

export const Route = new FileRoute("/admin/").createRoute({
  component: Admin,
  errorComponent: ErrorPage,
  beforeLoad: async ({ context: { auth } }) => {
    if (!auth.isAuthenticated) {
      throw redirect({
        to: "/auth/signin",
        search: {
          redirect: "/admin",
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
  return <div>Admin Index Page</div>;
}
