import { ErrorRouteProps, ErrorComponent } from "@tanstack/react-router";

export type Error = {
  statusText?: string;
  message?: string;
};

export default function ErrorPage({ error }: ErrorRouteProps) {
  return (
    <div className="flex items-center justify-center">
      <h1 className="text-3xl font-semibold text-red-600">
        <ErrorComponent error={error} />
      </h1>
    </div>
  );
}
