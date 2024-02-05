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
        <p className="cursor-pointer text-zinc-100 hover:text-green-500 transition-all duration-100">
          Browse Tags
        </p>
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
              <span className="text-zinc-100 group-hover:text-green-500 transition-all duration-100">
                {tag.name}
              </span>
            </DropdownMenuItem>
          ))}
      </DropdownMenuContent>
    </DropdownMenu>
  );
}
