import { Tag, tagsQuery } from "@/lib/query/tags";
import { useQuery } from "@tanstack/react-query";

import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { useNavigate } from "@tanstack/react-router";
import { seoPath } from "@/lib/seo-path";

export default function TagsDropdown() {
  const navigate = useNavigate();

  const { data, isLoading } = useQuery(tagsQuery);
  const tags = data as Tag[] | undefined;

  return (
    <DropdownMenu>
      <DropdownMenuTrigger asChild>
        <button className="cursor-pointer text-zinc-100 hover:text-cyan-500 transition-all duration-150 border-b-2 border-transparent hover:border-cyan-500 hover:-translate-y-0.5">
          Browse Tags
        </button>
      </DropdownMenuTrigger>
      <DropdownMenuContent>
        {!isLoading &&
          tags &&
          tags.map((tag) => (
            <DropdownMenuItem
              className="group cursor-pointer"
              key={tag.id}
              onClick={() => {
                navigate({
                  to: "/tag/$path",
                  params: { path: seoPath(tag.id, tag.name) },
                });
              }}
            >
              <span className="text-zinc-100 group-hover:text-cyan-500 transition-all duration-100">
                {tag.name}
              </span>
            </DropdownMenuItem>
          ))}
      </DropdownMenuContent>
    </DropdownMenu>
  );
}
