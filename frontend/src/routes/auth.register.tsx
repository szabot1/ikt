import ErrorPage from "@/error-page";
import { useAuth } from "@/lib/auth";
import { FileRoute, redirect, useNavigate } from "@tanstack/react-router";
import { useState } from "react";
import { z } from "zod";
import { SubmitHandler, useForm } from "react-hook-form";

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
  username: string;
  password: string;
  confirmPassword: string;
};

function Register() {
  const auth = useAuth();
  const navigate = useNavigate();

  const { redirect } = Route.useSearch();

  const [isSubmitting, setIsSubmitting] = useState(false);

  const {
    register,
    handleSubmit,
    watch,
    formState: { errors },
  } = useForm<RegisterInputs>();

  const onSubmit: SubmitHandler<RegisterInputs> = (data) => console.log(data);

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
            <label htmlFor="username">Username</label>
            <input
              className="px-2 py-1 bg-transparent rounded-md border-2 border-gray-700 transition-all duration-200 focus:border-green-600 ring-0 focus:ring-0 outline-none focus:outline-none"
              {...register("username", { required: true })}
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

          <div className="flex flex-col gap-1">
            <label htmlFor="confirmPassword">Confirm Password</label>
            <input
              type="password"
              className="px-2 py-1 bg-transparent rounded-md border-2 border-gray-700 transition-all duration-200 focus:border-green-600 ring-0 focus:ring-0 outline-none focus:outline-none"
              {...register("confirmPassword", {
                required: true,
                validate: (value) => value === watch("password"),
              })}
            />
          </div>

          <button
            type="submit"
            className="px-6 py-3 bg-green-700 rounded-lg hover:bg-green-600 transition-all duration-200"
          >
            Register
          </button>
        </form>
      </div>
    </section>
  );
}
