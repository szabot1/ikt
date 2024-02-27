import { AdminRoute } from "@/components/auth/protected";
import ErrorPage from "@/error-page";
import { AdminStats, adminStatsQuery } from "@/lib/query/admin";
import { useQuery } from "@tanstack/react-query";
import { FileRoute, redirect } from "@tanstack/react-router";
import { Helmet } from "react-helmet-async";

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
  const { data, isLoading } = useQuery(adminStatsQuery);
  let games = data as AdminStats;

  if (isLoading || !games) {
    return null;
  }

  return (
    <section className="flex flex-row items-center justify-center mt-16 gap-4 flex-wrap">
      <Helmet prioritizeSeoTags>
        <title>Admin</title>
      </Helmet>

      <Stat label="Tags" value={games.tags || 0} />
      <Stat label="Games" value={games.games || 0} />
      <Stat label="Sellers" value={games.sellers || 0} />
      <Stat label="Offers" value={games.offers || 0} />
      <Stat label="Users" value={games.users || 0} />
    </section>
  );
}

function Stat({ label, value }: { label: string; value: number }) {
  return (
    <div className="flex flex-col items-center justify-center gap-2 basis-full md:basis-[45%] lg:basis-[32%] p-4 bg-zinc-800 rounded-lg mx-4 lg:mx-0">
      <h2 className="text-2xl font-bold">{value}</h2>
      <p className="text-lg">{label}</p>
    </div>
  );
}
