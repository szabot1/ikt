import ProfileDropdown from "@/components/navigation/profile-dropdown";
import { Link, useNavigate } from "@tanstack/react-router";

export default function AdminNavigation() {
  const navigate = useNavigate();

  return (
    <nav className="w-full h-16 flex flex-row justify-between place-items-center border-b-2 border-zinc-700 px-4 py-2">
      <div className="flex flex-row gap-6 place-items-center justify-center">
        <Link to="/" className="font-semibold text-lg">
          Game Key Store
        </Link>

        <div className="hidden lg:flex flex-row gap-4 place-items-center justify-start">
          <Link
            to="/admin"
            className="cursor-pointer text-zinc-100 hover:text-green-500 transition-all duration-100"
          >
            Statistics
          </Link>

          <Link
            to="/admin/users"
            className="cursor-pointer text-zinc-100 hover:text-green-500 transition-all duration-100"
          >
            Users
          </Link>

          <Link
            to="/admin/tags"
            className="cursor-pointer text-zinc-100 hover:text-green-500 transition-all duration-100"
          >
            Tags
          </Link>

          <Link
            to="/admin/games"
            className="cursor-pointer text-zinc-100 hover:text-green-500 transition-all duration-100"
          >
            Games
          </Link>
        </div>
      </div>

      <div className="flex flex-row gap-4 place-items-center justify-center">
        <ProfileDropdown />
      </div>
    </nav>
  );
}
