import { Toaster } from "@/components/ui/toaster";
import AdminNavigation from "@/layouts/admin-navigation";
import MainNavigation from "@/layouts/navigation";
import { AuthState } from "@/lib/auth";
import {
  rootRouteWithContext,
  Outlet,
  ScrollRestoration,
  useRouterState,
} from "@tanstack/react-router";
import React, { Suspense } from "react";

const TanStackRouterDevtools =
  process.env.NODE_ENV === "production"
    ? () => null
    : React.lazy(() =>
        import("@tanstack/router-devtools").then((res) => ({
          default: res.TanStackRouterDevtools,
        }))
      );

const ReactQueryDevtools =
  process.env.NODE_ENV === "production"
    ? () => null
    : React.lazy(() =>
        import("@tanstack/react-query-devtools").then((res) => ({
          default: res.ReactQueryDevtools,
        }))
      );

interface RouterContext {
  auth: AuthState;
}

function ContextAwareNavigation() {
  const path = useRouterState().location.pathname;

  return path.startsWith("/admin") ? <AdminNavigation /> : <MainNavigation />;
}

export const Route = rootRouteWithContext<RouterContext>()({
  component: () => (
    <main className="flex flex-col w-full h-full min-h-screen">
      <ContextAwareNavigation />
      <ScrollRestoration />
      <Outlet />
      <Toaster />
      <Suspense fallback={null}>
        <TanStackRouterDevtools />
        <ReactQueryDevtools />
      </Suspense>
    </main>
  ),
});
