import { AdminRoute } from "@/components/auth/protected";
import ErrorPage from "@/error-page";
import { AdminStats, adminStatsQuery } from "@/lib/query/admin";
import { useQuery } from "@tanstack/react-query";
import { FileRoute, redirect, useNavigate } from "@tanstack/react-router";
import { Loader } from "lucide-react";
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
    return (
      <div className="flex items-center justify-center w-full h-full grow">
        <Loader className="h-4 w-4 animate-spin" />
      </div>
    );
  }

  return (
    <section className="flex flex-row items-center justify-center mt-16 gap-4 flex-wrap">
      <Helmet prioritizeSeoTags>
        <title>Admin</title>
      </Helmet>

      <Stat label="Tags" value={games.tags || 0} to="/admin/tags" />
      <Stat label="Games" value={games.games || 0} to="/admin/games" />
      <Stat label="Sellers" value={games.sellers || 0} to="/admin/users" />
      <Stat label="Offers" value={games.offers || 0} to="/admin/users" />
      <Stat label="Users" value={games.users || 0} to="/admin/users" />
    </section>
  );
}

const colors: Record<string, { accent: string }> = {
  tags: { accent: "bg-blue-500" },
  games: { accent: "bg-green-500" },
  sellers: { accent: "bg-yellow-500" },
  offers: { accent: "bg-indigo-500" },
  users: { accent: "bg-red-500" },
};

function Stat({
  label,
  value,
  to,
}: {
  label: string;
  value: number;
  to: string;
}) {
  const navigate = useNavigate();

  const color = colors[label.toLowerCase()];

  return (
    <div
      className="flex flex-col items-center justify-center gap-2 basis-full md:basis-[45%] lg:basis-[32%] p-4 bg-zinc-800 rounded-lg mx-4 lg:mx-0 cursor-pointer"
      role="button"
      onClick={() => navigate({ to })}
    >
      <div
        className={`w-16 h-16 rounded-full flex items-center justify-center ${color.accent}`}
      >
        <span className="text-white text-2xl font-bold">{value}</span>
      </div>
      <span className="text-center text-lg font-bold">{label}</span>
    </div>
  );
}
