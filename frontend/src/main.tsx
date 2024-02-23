import React from "react";
import ReactDOM from "react-dom/client";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { RouterProvider } from "@tanstack/react-router";

import "./index.css";
import { router } from "./router";
import { AuthProvider, useAuth } from "./lib/auth";
import { HelmetProvider } from "react-helmet-async";
import { QueryError } from "./lib/query/util";

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      retry: (failureCount, error) => {
        if (error instanceof QueryError && error.status === 404) return false;
        return failureCount < 3;
      },
    },
  },
});

function InnerApp() {
  const auth = useAuth();
  return <RouterProvider router={router} context={{ auth }} />;
}

const rootElement = document.getElementById("root")!;
if (!rootElement.innerHTML) {
  const root = ReactDOM.createRoot(rootElement);
  root.render(
    <React.StrictMode>
      <QueryClientProvider client={queryClient}>
        <HelmetProvider>
          <AuthProvider>
            <InnerApp />
          </AuthProvider>
        </HelmetProvider>
      </QueryClientProvider>
    </React.StrictMode>
  );
}
