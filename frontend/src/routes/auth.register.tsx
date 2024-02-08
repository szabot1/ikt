import ErrorPage from "@/error-page";
import { useAuth } from "@/lib/auth";
import { FileRoute, Link, redirect, useNavigate } from "@tanstack/react-router";
import { useState } from "react";
import { z } from "zod";
import { SubmitHandler, useForm } from "react-hook-form";
import { cn } from "@/lib/style";
import { Loader2 } from "lucide-react";
import {
  setFormError,
  register as registerFn,
  Register as TRegister,
} from "@/lib/query/auth";

const registerSchema = z.object({
  redirect: z.string().optional(),
});

export const Route = new FileRoute("/auth/register").createRoute({
  component: Register,
  errorComponent: ErrorPage,
  validateSearch: (search) => registerSchema.parse(search),
  beforeLoad: async ({ context: { auth } }) => {
    if (auth.isAuthenticated) {
      throw redirect({ to: "/" });
    }
  },
});

type RegisterInputs = {
  email: string;
  emailCode: string;
  username: string;
  password: string;
  confirmPassword: string;
};

function Register() {
  const auth = useAuth();
  const navigate = useNavigate();

  const { redirect } = Route.useSearch();
  const secureRedirect = (redirect || "/").startsWith("http")
    ? "/"
    : redirect || "/";

  const [isSubmitting, setIsSubmitting] = useState(false);

  const {
    register,
    handleSubmit,
    watch,
    setError,
    clearErrors,
    formState: { errors },
  } = useForm<RegisterInputs>();

  const [generalError, setGeneralError] = useState<string | null>(null);
  const [generalSuccess, setGeneralSuccess] = useState<string | null>(null);
  const [codeInputVisible, setCodeInputVisible] = useState(false);

  const onSubmit: SubmitHandler<RegisterInputs> = (data) => {
    setIsSubmitting(true);

    registerFn({
      email: data.email,
      emailCode: data.emailCode || "",
      username: data.username,
      password: data.password,
    } as TRegister).then((res) => {
      if (res.success) {
        setGeneralError(null);
        setGeneralSuccess(null);

        navigate({
          to: "/auth/signin",
          search: {
            redirect: secureRedirect,
          },
        });
      } else if (res.emailCodeRequired) {
        setCodeInputVisible(true);
        setGeneralError(null);
        setGeneralSuccess(
          "We sent you an email with a confirmation code. Please enter it below."
        );

        setIsSubmitting(false);
      } else {
        if (res.statusCode >= 400 && res.statusCode < 500) {
          setGeneralError(res.errors.server?.[0]);
          setGeneralSuccess(null);

          setFormError(setError, clearErrors, "email", res.errors.email);
          setFormError(
            setError,
            clearErrors,
            "emailCode",
            res.errors.emailCode
          );
          setFormError(setError, clearErrors, "username", res.errors.username);
          setFormError(setError, clearErrors, "password", res.errors.password);
          setFormError(
            setError,
            clearErrors,
            "confirmPassword",
            res.errors.confirmPassword
          );
        } else {
          setGeneralError(
            "Backend request failed (status: " +
              res.statusCode +
              "), please try again."
          );
          setGeneralSuccess(null);

          clearErrors([
            "email",
            "emailCode",
            "username",
            "password",
            "confirmPassword",
          ]);
        }

        setIsSubmitting(false);
      }
    });
  };

  return (
    <section className="grow flex items-center justify-center">
      <div className="px-12 py-6 border-2 border-green-700 rounded-lg w-10/12 md:w-6/12 lg:w-3/12">
        <h1 className="text-2xl mb-6">Register</h1>

        {generalSuccess && (
          <div className="text-green-500 text-sm my-4 text-center px-4 py-2 border-2 border-green-500 rounded-md">
            {generalSuccess}
          </div>
        )}

        <form onSubmit={handleSubmit(onSubmit)} className="flex flex-col gap-4">
          <div className="flex flex-col gap-1">
            <input
              className={cn(
                errors.email && "!border-red-500",
                "px-3 py-2 bg-zinc-800/25 rounded-md border-2 border-zinc-700 transition-all duration-200 focus:border-green-600 ring-0 focus:ring-0 outline-none focus:outline-none disabled:bg-zinc-800/25 disabled:border-zinc-700 disabled:text-zinc-500 disabled:cursor-not-allowed"
              )}
              type="email"
              placeholder="Email address"
              disabled={codeInputVisible}
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

          {codeInputVisible && (
            <div className="flex flex-col gap-1">
              <input
                className={cn(
                  errors.emailCode && "!border-red-500",
                  "px-3 py-2 bg-zinc-800/25 rounded-md border-2 border-zinc-700 transition-all duration-200 focus:border-green-600 ring-0 focus:ring-0 outline-none focus:outline-none"
                )}
                type="text"
                placeholder="Email code"
                {...register("emailCode", { required: true })}
              />
              {errors.emailCode && (
                <span className="text-red-500">
                  {errors.emailCode.message ||
                    (errors.emailCode.type === "required" &&
                      "Email code is required") ||
                    "Invalid email code"}
                </span>
              )}
            </div>
          )}

          {!codeInputVisible && (
            <>
              <div className="flex flex-col gap-1">
                <input
                  className={cn(
                    errors.username && "!border-red-500",
                    "px-3 py-2 bg-zinc-800/25 rounded-md border-2 border-zinc-700 transition-all duration-200 focus:border-green-600 ring-0 focus:ring-0 outline-none focus:outline-none"
                  )}
                  type="username"
                  placeholder="Username"
                  {...register("username", { required: true })}
                />
                {errors.username && (
                  <span className="text-red-500">
                    {errors.username.message ||
                      (errors.username.type === "required" &&
                        "Username is required") ||
                      "Invalid username"}
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

              <div className="flex flex-col gap-1">
                <input
                  className={cn(
                    errors.confirmPassword && "!border-red-500",
                    "px-3 py-2 bg-zinc-800/25 rounded-md border-2 border-zinc-700 transition-all duration-200 focus:border-green-600 ring-0 focus:ring-0 outline-none focus:outline-none"
                  )}
                  type="password"
                  placeholder="Confirm Password"
                  {...register("confirmPassword", {
                    required: true,
                    validate: (value) => value === watch("password"),
                  })}
                />
                {errors.confirmPassword && (
                  <span className="text-red-500">
                    {errors.confirmPassword.message ||
                      (errors.confirmPassword.type === "required" &&
                        "Password confirmation is required") ||
                      "Invalid password confirmation"}
                  </span>
                )}
              </div>
            </>
          )}

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
          <span>Already have an account?</span>
          <Link
            to="/auth/signin"
            search={{ redirect: secureRedirect }}
            className="text-green-500"
          >
            Sign in here
          </Link>
        </div>
      </div>
    </section>
  );
}
