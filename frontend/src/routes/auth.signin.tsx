import ErrorPage from "@/error-page";
import { useAuth } from "@/lib/auth";
import { FileRoute, redirect, useNavigate } from "@tanstack/react-router";
import { useState } from "react";
import { z } from "zod";

const signInSchema = z.object({
  redirect: z.string().optional(),
});

export const Route = new FileRoute("/auth/signin").createRoute({
  component: SignIn,
  errorComponent: ErrorPage,
  validateSearch: (search) => signInSchema.parse(search),
  beforeLoad: async ({ context: { auth } }) => {
    if (auth.isAuthenticated) {
      throw redirect({ to: "/" });
    }
  },
});

function SignIn() {
  const auth = useAuth();
  const navigate = useNavigate();

  const { redirect } = Route.useSearch();

  const [isSubmitting, setIsSubmitting] = useState(false);

  const handleSubmit = async (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();
  };

  return (
    <section className="grow flex items-center justify-center">
      <div className="px-6 py-3 border-2 border-gray-700 rounded-lg">
        <form onSubmit={handleSubmit}>
          <button
            type="submit"
            className="px-6 py-3 bg-green-700 rounded-lg hover:bg-green-600 transition-all duration-200"
          >
            Sign In
          </button>
        </form>
      </div>
    </section>
  );
}
