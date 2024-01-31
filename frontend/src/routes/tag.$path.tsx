import ErrorPage from "@/error-page";
import { seoPathKey } from "@/lib/seo-path";
import { FileRoute } from "@tanstack/react-router";

export const Route = new FileRoute("/tag/$path").createRoute({
  component: Tag,
  errorComponent: ErrorPage,
});

function Tag() {
  const { path } = Route.useParams();
  const tagId = seoPathKey(path);

  return <p>Tag: {tagId}</p>;
}
