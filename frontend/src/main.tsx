import React from "react";
import ReactDOM from "react-dom/client";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { RouterProvider } from "@tanstack/react-router";

const queryClient = new QueryClient();

import "./index.css";
import { router } from "./router";
import { AuthProvider, useAuth } from "./lib/auth";
import { HelmetProvider } from "react-helmet-async";

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
