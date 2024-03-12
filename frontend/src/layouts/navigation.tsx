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
          Game Key Store
        </Link>

        <div className="hidden lg:flex flex-row gap-4 place-items-center justify-start">
          <Link
            to="/search"
            search={{ q: "" }}
            className="cursor-pointer text-zinc-100 hover:text-green-500 transition-all duration-100"
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
              className="cursor-pointer text-zinc-100 hover:text-green-500 transition-all duration-100"
            >
              Sign In
            </Link>

            <Link
              to="/auth/register"
              className="cursor-pointer text-zinc-100 hover:text-green-500 transition-all duration-100"
            >
              Register
            </Link>
          </>
        )}
      </div>
    </nav>
  );
}
