import ErrorPage from "@/error-page";
import { FileRoute } from "@tanstack/react-router";

export const Route = new FileRoute("/terms").createRoute({
  component: Terms,
  errorComponent: ErrorPage,
});

function Terms() {
  return <></>;
}
