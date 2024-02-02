import ErrorPage from "@/error-page";
import { useAuth } from "@/lib/auth";
import { FileRoute, redirect, useNavigate } from "@tanstack/react-router";
import { useState } from "react";
import { z } from "zod";
import { SubmitHandler, useForm } from "react-hook-form";

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

type LoginInputs = {
  email: string;
  password: string;
};

function SignIn() {
  const auth = useAuth();
  const navigate = useNavigate();

  const { redirect } = Route.useSearch();

  const [isSubmitting, setIsSubmitting] = useState(false);

  const {
    register,
    handleSubmit,
    watch,
    formState: { errors },
  } = useForm<LoginInputs>();

  const onSubmit: SubmitHandler<LoginInputs> = (data) => console.log(data);

  return (
    <section className="grow flex items-center justify-center">
      <div className="px-6 py-3 border-2 border-gray-700 rounded-lg">
        <form onSubmit={handleSubmit(onSubmit)} className="flex flex-col gap-4">
          <div className="flex flex-col gap-1">
            <label htmlFor="email">Email</label>
            <input
              className="px-2 py-1 bg-transparent rounded-md border-2 border-gray-700 transition-all duration-200 focus:border-green-600 ring-0 focus:ring-0 outline-none focus:outline-none"
              type="email"
              {...register("email", { required: true })}
            />
          </div>

          <div className="flex flex-col gap-1">
            <label htmlFor="password">Password</label>
            <input
              type="password"
              className="px-2 py-1 bg-transparent rounded-md border-2 border-gray-700 transition-all duration-200 focus:border-green-600 ring-0 focus:ring-0 outline-none focus:outline-none"
              {...register("password", { required: true })}
            />
          </div>

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
