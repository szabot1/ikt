import ErrorPage from "@/error-page";
import { FileRoute } from "@tanstack/react-router";

export const Route = new FileRoute("/search").createRoute({
  component: Search,
  errorComponent: ErrorPage,
});

function Search() {
  return <></>;
}
