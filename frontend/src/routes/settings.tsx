import ErrorPage from "@/error-page";
import { FileRoute } from "@tanstack/react-router";

export const Route = new FileRoute("/settings").createRoute({
  component: Settings,
  errorComponent: ErrorPage,
});

function Settings() {
  return (
    <section className="grow flex flex-col lg:flex-row gap-4 lg:gap-12 items-center justify-center">
      <div className="px-6 py-3 border-2 border-zinc-700 rounded-lg w-10/12 md:w-6/12 lg:w-3/12 flex flex-col gap-2">
        <h1 className="text-xl font-semibold mb-4">Account</h1>

        <div className="w-full flex flex-col gap-2">
          <button className="w-full py-2 bg-red-700 rounded-lg hover:bg-red-600 transition-all duration-200 flex items-center justify-center">
            Delete account
          </button>

          <span className="text-zinc-400 text-sm text-justify">
            Click the button to delete your account. This action is irreversible
            and will delete all your data. If you would like to export your data
            first, please{" "}
            <a
              href="/tickets"
              target="_blank"
              rel="noreferrer"
              className="text-green-500 hover:underline transition-all duration-200 hover:text-green-400"
            >
              contact support
            </a>
            .
          </span>
        </div>
      </div>

      <div className="px-6 py-3 border-2 border-green-700 rounded-lg w-10/12 md:w-6/12 lg:w-3/12 flex flex-col gap-2">
        <h1 className="text-xl font-semibold mb-4">Billing</h1>

        <a
          href="https://stripe.com"
          target="_blank"
          rel="noreferrer"
          className="py-2 bg-green-700 rounded-lg hover:bg-green-600 transition-all duration-200 flex items-center justify-center"
        >
          Manage billing
        </a>

        <span className="text-zinc-400 text-sm text-justify">
          Billing information is handled and secured by Stripe. Click the button
          to go to the Stripe Customer Portal where you can manage your billing
          information.
        </span>
      </div>
    </section>
  );
}
