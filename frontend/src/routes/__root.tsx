import MainNavigation from "@/layouts/navigation";
import { AuthState } from "@/lib/auth";
import {
  rootRouteWithContext,
  Outlet,
  ScrollRestoration,
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

export const Route = rootRouteWithContext<RouterContext>()({
  component: () => (
    <main className="flex flex-col w-full h-full min-h-screen">
      <MainNavigation />
      <ScrollRestoration />
      <Outlet />
      <Suspense fallback={null}>
        <TanStackRouterDevtools />
        <ReactQueryDevtools />
      </Suspense>
    </main>
  ),
});
