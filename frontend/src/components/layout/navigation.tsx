export default function MainNavigation() {
  return (
    <nav className="w-full h-16 flex flex-row justify-between place-items-center border-b-2 border-gray-700 px-4 py-2">
      <div>
        <h1 className="font-semibold">Game Key Store</h1>
      </div>

      <div className="flex flex-row gap-4 place-items-center justify-center">
        <a className="cursor-pointer text-gray-100 hover:text-blue-400 transition-all duration-100">
          Sign In
        </a>
        <a className="cursor-pointer text-gray-100 hover:text-blue-400 transition-all duration-100">
          Register
        </a>
      </div>
    </nav>
  );
}
