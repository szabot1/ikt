import { useNavigate } from "@tanstack/react-router";

export default function SearchForm() {
  const navigate = useNavigate();

  const handleSubmit = (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();

    const formData = new FormData(e.currentTarget);
    const search = formData.get("search") as string;

    navigate({
      to: "/search",
      search: {
        q: search,
      },
    });
  };

  return (
    <div className="w-full h-full">
      <form onSubmit={handleSubmit}>
        <input
          type="text"
          name="search"
          placeholder="Search for a game..."
          className="w-full h-16 rounded-xl bg-transparent border-2 border-zinc-700 focus:border-cyan-700 px-6 py-4 ring-0 focus:ring-0 outline-none focus:outline-none transition-all duration-100"
        />
      </form>
    </div>
  );
}
