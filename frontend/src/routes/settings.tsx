import ErrorPage from "@/error-page";
import { FileRoute } from "@tanstack/react-router";

export const Route = new FileRoute("/settings").createRoute({
  component: Settings,
  errorComponent: ErrorPage,
});

function Settings() {
  return <></>;
}
