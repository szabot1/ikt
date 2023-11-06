import { useRouteError } from "react-router-dom";

export default function ErrorPage() {
  const error = useRouteError();
  console.error(error);

  return (
    <div className="min-h-screen flex items-center justify-center">
      <h1 className="text-3xl font-semibold">
        {error.statusText || error.message}
      </h1>
    </div>
  );
}
