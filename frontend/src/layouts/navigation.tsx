import { Link } from "@tanstack/react-router";

export default function MainNavigation() {
  return (
    <nav className="w-full h-16 flex flex-row justify-between place-items-center border-b-2 border-gray-700 px-4 py-2">
      <div>
        <Link to="/" className="font-semibold">
          Game Key Store
        </Link>
      </div>

      <div className="flex flex-row gap-4 place-items-center justify-center">
        <Link
          to="/auth/signin"
          className="cursor-pointer text-gray-100 hover:text-green-500 transition-all duration-100"
        >
          Sign In
        </Link>
        <Link
          to="/auth/register"
          className="cursor-pointer text-gray-100 hover:text-green-500 transition-all duration-100"
        >
          Register
        </Link>
      </div>
    </nav>
  );
}
