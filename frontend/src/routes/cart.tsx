import ErrorPage from "@/error-page";
import { FileRoute } from "@tanstack/react-router";

export const Route = new FileRoute("/cart").createRoute({
  component: Cart,
  errorComponent: ErrorPage,
});

function Cart() {
  return (
    <section className="grow flex flex-col lg:flex-row gap-4 lg:gap-12 items-center justify-center">
      <div className="flex flex-col gap-2 w-10/12 md:w-6/12 lg:w-3/12">
        <h1 className="text-2xl font-semibold">Cart</h1>

        <div className="px-12 py-6 border-2 border-zinc-700 rounded-lg">
          <span className="text-red-500 text-sm">
            You have no items in your cart
          </span>
        </div>
      </div>

      <div className="px-12 py-6 border-2 border-green-700 rounded-lg w-10/12 md:w-6/12 lg:w-3/12 flex flex-col gap-2">
        <button
          type="submit"
          disabled
          className="py-2 bg-green-700 rounded-lg hover:bg-green-600 transition-all duration-200 flex items-center justify-center disabled:opacity-50 disabled:hover:bg-green-700 disabled:cursor-not-allowed"
        >
          Checkout
        </button>

        <span className="text-zinc-400 text-sm text-justify">
          Payments are handled and secured by Stripe. By clicking "Checkout",
          you agree to our{" "}
          <a
            href="/terms"
            target="_blank"
            rel="noreferrer"
            className="text-green-500 hover:underline transition-all duration-200 hover:text-green-400"
          >
            terms and conditions
          </a>
          . We do not store any of your payment information, visit{" "}
          <a
            href="https://stripe.com"
            target="_blank"
            rel="noreferrer"
            className="text-green-500 hover:underline transition-all duration-200 hover:text-green-400"
          >
            stripe.com
          </a>{" "}
          for more information.
        </span>
      </div>
    </section>
  );
}
