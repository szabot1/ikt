import ErrorPage from "@/error-page";
import { FileRoute } from "@tanstack/react-router";

export const Route = new FileRoute("/auth/signin").createRoute({
  component: SignIn,
  errorComponent: ErrorPage,
});

function SignIn() {
  return <></>;
}
