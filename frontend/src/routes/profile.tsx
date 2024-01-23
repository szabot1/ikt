import ErrorPage from "@/error-page";
import { FileRoute } from "@tanstack/react-router";

export const Route = new FileRoute("/profile").createRoute({
  component: Profile,
  errorComponent: ErrorPage,
});

function Profile() {
  return <></>;
}
