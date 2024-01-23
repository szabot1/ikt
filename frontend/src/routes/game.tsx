import ErrorPage from "@/error-page";
import { FileRoute } from "@tanstack/react-router";

export const Route = new FileRoute("/game").createRoute({
  component: Game,
  errorComponent: ErrorPage,
});

function Game() {
  return <></>;
}
