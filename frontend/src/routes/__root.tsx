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
import { Helmet } from "react-helmet-async";

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
    <>
      <Helmet>
        <link rel="preconnect" href={import.meta.env.VITE_BACKEND_PROD_URL} />
        <link rel="preconnect" href="https://secure.gravatar.com" />
      </Helmet>
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
    </>
  ),
});
