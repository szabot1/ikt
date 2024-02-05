import ErrorPage from "@/error-page";
import { useAuth } from "@/lib/auth";
import { FileRoute, Link, redirect, useNavigate } from "@tanstack/react-router";
import { useState } from "react";
import { z } from "zod";
import { SubmitHandler, useForm } from "react-hook-form";
import { cn } from "@/lib/style";

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
    setError,
    formState: { errors },
  } = useForm<LoginInputs>();

  const onSubmit: SubmitHandler<LoginInputs> = (data) => console.log(data);

  return (
    <section className="grow flex items-center justify-center">
      <div className="px-12 py-6 border-2 border-green-700 rounded-lg w-10/12 md:w-6/12 lg:w-3/12">
        <h1 className="text-2xl mb-6">Sign In</h1>

        <form onSubmit={handleSubmit(onSubmit)} className="flex flex-col gap-4">
          <div className="flex flex-col gap-1">
            <input
              className={cn(
                errors.email && "!border-red-500",
                "px-3 py-2 bg-zinc-800/25 rounded-md border-2 border-zinc-700 transition-all duration-200 focus:border-green-600 ring-0 focus:ring-0 outline-none focus:outline-none"
              )}
              type="email"
              placeholder="Email address"
              {...register("email", { required: true })}
            />
            {errors.email && (
              <span className="text-red-500">
                {errors.email.message ||
                  (errors.email.type === "required" && "Email is required") ||
                  "Invalid email"}
              </span>
            )}
          </div>

          <div className="flex flex-col gap-1">
            <input
              className={cn(
                errors.password && "!border-red-500",
                "px-3 py-2 bg-zinc-800/25 rounded-md border-2 border-zinc-700 transition-all duration-200 focus:border-green-600 ring-0 focus:ring-0 outline-none focus:outline-none"
              )}
              type="password"
              placeholder="Password"
              {...register("password", { required: true })}
            />
            {errors.password && (
              <span className="text-red-500">
                {errors.password.message ||
                  (errors.password.type === "required" &&
                    "Password is required") ||
                  "Invalid password"}
              </span>
            )}
          </div>

          <button
            type="submit"
            className="py-2 bg-green-700 rounded-lg hover:bg-green-600 transition-all duration-200"
          >
            Continue
          </button>
        </form>

        <div className="flex flex-row gap-2 mt-4">
          <span>Don't have an account?</span>
          <Link to="/auth/register" className="text-green-500">
            Register here
          </Link>
        </div>
      </div>
    </section>
  );
}
