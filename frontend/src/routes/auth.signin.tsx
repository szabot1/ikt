import ErrorPage from "@/error-page";
import { setSession } from "@/lib/auth";
import { FileRoute, Link, redirect, useNavigate } from "@tanstack/react-router";
import { useState } from "react";
import { z } from "zod";
import { SubmitHandler, useForm } from "react-hook-form";
import { cn } from "@/lib/style";
import { Loader2 } from "lucide-react";
import { Login, login, setFormError } from "@/lib/query/auth";
import { Helmet } from "react-helmet-async";

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
  const navigate = useNavigate();

  const { redirect } = Route.useSearch();
  const secureRedirect = (redirect || "/").startsWith("http")
    ? "/"
    : redirect || "/";

  const [isSubmitting, setIsSubmitting] = useState(false);

  const {
    register,
    handleSubmit,
    setError,
    clearErrors,
    formState: { errors },
  } = useForm<LoginInputs>();

  const [generalError, setGeneralError] = useState<string | null>(null);

  const onSubmit: SubmitHandler<LoginInputs> = (data) => {
    setIsSubmitting(true);

    login({
      email: data.email,
      password: data.password,
    } as Login).then((res) => {
      if (res.success) {
        setSession(res.accessToken, res.refreshToken);

        navigate({
          to: secureRedirect,
        });
      } else {
        if (res.statusCode >= 400 && res.statusCode < 500) {
          setGeneralError(res.errors.general?.[0]);

          setFormError(setError, clearErrors, "email", res.errors.email);
          setFormError(setError, clearErrors, "password", res.errors.password);
        } else {
          setGeneralError(
            "Backend request failed (status: " +
              res.statusCode +
              "), please try again."
          );

          clearErrors(["email", "password"]);
        }

        setIsSubmitting(false);
      }
    });
  };

  return (
    <section className="grow flex items-center justify-center mt-16">
      <Helmet prioritizeSeoTags>
        <title>Sign In</title>
      </Helmet>

      <div className="px-12 py-6 border-2 border-green-700 rounded-lg w-10/12 md:w-6/12 lg:w-[29%]">
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
            className="py-2 bg-green-700 rounded-lg hover:bg-green-600 transition-all duration-200 flex items-center justify-center disabled:opacity-50 disabled:hover:bg-green-700 disabled:cursor-not-allowed"
            disabled={isSubmitting}
          >
            {isSubmitting && <Loader2 className="w-4 h-4 mr-2 animate-spin" />}
            Continue
          </button>
        </form>

        {generalError && (
          <div className="text-red-500 text-sm my-4 text-center px-4 py-2 border-2 border-red-500 rounded-md">
            {generalError}
          </div>
        )}

        <div className="flex flex-col md:flex-row md:gap-2 mt-4">
          <span>Don't have an account?</span>
          <Link
            to="/auth/register"
            search={{ redirect: secureRedirect }}
            className="text-green-500"
          >
            Register here
          </Link>
        </div>
      </div>
    </section>
  );
}
