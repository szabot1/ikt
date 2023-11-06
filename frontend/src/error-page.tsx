import { useRouteError } from "react-router-dom";

export type Error = {
  statusText?: string;
  message?: string;
};

export default function ErrorPage() {
  const error = useRouteError() as Error;

  return (
    <div className="min-h-screen flex items-center justify-center">
      <h1 className="text-3xl font-semibold text-red-600">
        {error.statusText || error.message}
      </h1>
    </div>
  );
}
