import ErrorPage from "@/error-page";
import { FileRoute } from "@tanstack/react-router";

export const Route = new FileRoute("/tickets").createRoute({
  component: Tickets,
  errorComponent: ErrorPage,
});

function Tickets() {
  return <></>;
}
