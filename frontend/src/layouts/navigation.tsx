import ProfileDropdown from "@/components/navigation/profile-dropdown";
import TagsDropdown from "@/components/navigation/tags-dropdown";
import { useAuth } from "@/lib/auth";
import { Link, useNavigate } from "@tanstack/react-router";

export default function MainNavigation() {
  const auth = useAuth();

  return (
    <nav className="w-full h-16 flex flex-row justify-between place-items-center border-b-2 border-zinc-700 px-4 py-2">
      <div className="flex flex-row gap-6 place-items-center justify-center">
        <Link to="/" className="font-semibold text-lg">
          <img
            src="/assets/logo-48.webp"
            alt="Game Key Store"
            className="h-12 w-12"
          />
        </Link>

        <div className="hidden lg:flex flex-row gap-4 place-items-center justify-start">
          <Link
            to="/search"
            search={{ q: "" }}
            className="cursor-pointer text-zinc-100 hover:text-cyan-500 transition-all duration-150 border-b-2 border-transparent hover:border-cyan-500 hover:-translate-y-0.5"
          >
            Search Games
          </Link>

          <TagsDropdown />
        </div>
      </div>

      <div className="flex flex-row gap-4 place-items-center justify-center">
        {auth.isAuthenticated ? (
          <ProfileDropdown />
        ) : (
          <>
            <Link
              to="/auth/signin"
              className="cursor-pointer text-zinc-100 hover:text-cyan-500 transition-all duration-150 border-b-2 border-transparent hover:border-cyan-500 hover:-translate-y-0.5"
            >
              Sign In
            </Link>

            <Link
              to="/auth/register"
              className="cursor-pointer text-zinc-100 hover:text-cyan-500 transition-all duration-150 border-b-2 border-transparent hover:border-cyan-500 hover:-translate-y-0.5"
            >
              Register
            </Link>
          </>
        )}
      </div>
    </nav>
  );
}
