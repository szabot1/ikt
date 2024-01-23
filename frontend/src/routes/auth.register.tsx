import ErrorPage from "@/error-page";
import { FileRoute } from "@tanstack/react-router";

export const Route = new FileRoute("/auth/register").createRoute({
  component: Register,
  errorComponent: ErrorPage,
});

function Register() {
  return <></>;
}
