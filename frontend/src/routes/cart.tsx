import ErrorPage from "@/error-page";
import { FileRoute } from "@tanstack/react-router";

export const Route = new FileRoute("/cart").createRoute({
  component: Cart,
  errorComponent: ErrorPage,
});

function Cart() {
  return <></>;
}
