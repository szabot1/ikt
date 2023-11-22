import React from "react";
import { createBrowserRouter, RouterProvider } from "react-router-dom";
import ReactDOM from "react-dom/client";

import ErrorPage from "./error-page";
import Root from "./routes/root";
import Weather, { loader as weatherLoader } from "./routes/weather";
import Product, { loader as productLoader } from "./routes/product";
import Test, { loader as testLoader } from "./routes/test";

import "./index.css";

const router = createBrowserRouter([
  {
    path: "/",
    element: <Root />,
    errorElement: <ErrorPage />,
  },
  {
    path: "/weather",
    element: <Weather />,
    loader: weatherLoader,
    errorElement: <ErrorPage />,
  },
  {
    path: "/products/:id",
    element: <Product />,
    loader: productLoader,
    errorElement: <ErrorPage />,
  },
  {
    path: "/test",
    element: <Test />,
    loader: testLoader,
    errorElement: <ErrorPage />,
  },
]);

ReactDOM.createRoot(document.getElementById("root")!).render(
  <React.StrictMode>
    <RouterProvider router={router} />
  </React.StrictMode>
);
