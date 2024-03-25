import ErrorPage from "@/error-page";
import { getCustomerPortalUrl } from "@/lib/query/billing";
import { FileRoute, Link, redirect } from "@tanstack/react-router";
import { Loader2 } from "lucide-react";
import { useState } from "react";
import { Helmet } from "react-helmet-async";
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
  AlertDialogTrigger,
} from "@/components/ui/alert-dialog";
import { deleteAccount } from "@/lib/query/auth";
import { useToast } from "@/components/ui/use-toast";

export const Route = new FileRoute("/settings").createRoute({
  component: Settings,
  errorComponent: ErrorPage,
  beforeLoad: async ({ context: { auth } }) => {
    if (!auth.isAuthenticated) {
      throw redirect({
        to: "/auth/signin",
        search: {
          redirect: "/settings",
        },
      });
    }
  },
});

function Settings() {
  const { toast } = useToast();

  const [isOpeningPortal, setIsOpeningPortal] = useState(false);

  return (
    <section className="grow flex flex-col lg:flex-row gap-4 lg:gap-12 items-center justify-center">
      <Helmet prioritizeSeoTags>
        <title>Settings</title>
      </Helmet>

      <div className="px-6 py-3 border-2 border-zinc-700 rounded-lg w-10/12 md:w-6/12 lg:w-3/12 flex flex-col gap-2">
        <h1 className="text-xl font-semibold mb-4">Account</h1>

        <div className="w-full flex flex-col gap-2">
          <AlertDialog>
            <AlertDialogTrigger asChild>
              <button className="w-full py-2 bg-red-700 rounded-lg hover:bg-red-600 transition-all duration-200 flex items-center justify-center">
                Delete account
              </button>
            </AlertDialogTrigger>
            <AlertDialogContent>
              <AlertDialogHeader>
                <AlertDialogTitle>Are you absolutely sure?</AlertDialogTitle>
                <AlertDialogDescription>
                  This action cannot be undone. This will permanently delete
                  your account and remove your data from our servers.
                </AlertDialogDescription>
              </AlertDialogHeader>
              <AlertDialogFooter>
                <AlertDialogCancel>Cancel</AlertDialogCancel>
                <AlertDialogAction
                  onClick={() => {
                    deleteAccount().then((error) => {
                      if (error === null) {
                        window.location.href = "/";
                      } else {
                        toast({
                          title: "Failed to delete account",
                          description: error,
                        });
                      }
                    });
                  }}
                >
                  Continue
                </AlertDialogAction>
              </AlertDialogFooter>
            </AlertDialogContent>
          </AlertDialog>

          <span className="text-zinc-400 text-sm text-justify">
            Click the button to delete your account. This action is irreversible
            and will delete all your data. If you would like to export your data
            first, please{" "}
            <a
              href="mailto:account-support@02c09f8b.net"
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

        <button
          onClick={() => {
            setIsOpeningPortal(true);

            getCustomerPortalUrl().then((url) => {
              if (url) {
                window.open(url, "_blank");
              }

              setIsOpeningPortal(false);
            });
          }}
          disabled={isOpeningPortal}
          className="py-2 bg-green-700 rounded-lg hover:bg-green-600 transition-all duration-200 flex items-center justify-center"
        >
          {isOpeningPortal && <Loader2 className="w-4 h-4 mr-2 animate-spin" />}
          Manage billing
        </button>

        <span className="text-zinc-400 text-sm text-justify">
          Billing information is handled and secured by Stripe. Click the button
          to go to the Stripe Customer Portal where you can manage your billing
          information.
        </span>
      </div>
    </section>
  );
}
