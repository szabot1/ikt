import ErrorPage from "@/error-page";
import { FileRoute, redirect } from "@tanstack/react-router";
import { z } from "zod";

const searchSchema = z.object({
  q: z.string(),
});

export const Route = new FileRoute("/search").createRoute({
  component: Search,
  errorComponent: ErrorPage,
  validateSearch: (search) => searchSchema.parse(search),
});

function Search() {
  const { q } = Route.useSearch();
  const showResults = q.length > 0;

  return <>{showResults && <p>Input: {q}</p>}</>;
}
