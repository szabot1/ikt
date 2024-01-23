export default function Search() {
  return (
    <div className="w-full h-full">
      <input
        type="text"
        placeholder="Search for a game..."
        className="w-full h-16 rounded-xl bg-transparent border-2 border-gray-700 focus:border-green-700 px-6 py-4 ring-0 focus:ring-0 outline-none focus:outline-none transition-all duration-100"
      />
    </div>
  );
}
