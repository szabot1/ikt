import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { useNavigate } from "@tanstack/react-router";

export default function TagsDropdown() {
  const navigate = useNavigate();

  return (
    <DropdownMenu>
      <DropdownMenuTrigger asChild>
        <p className="cursor-pointer text-zinc-100 hover:text-green-500 transition-all duration-100">
          Profile
        </p>
      </DropdownMenuTrigger>
      <DropdownMenuContent>
        <DropdownMenuItem
          className="group cursor-pointer"
          onClick={() => {
            navigate({
              to: "/profile",
            });
          }}
        >
          <span className="text-zinc-100 group-hover:text-green-500 transition-all duration-100">
            Profile
          </span>
        </DropdownMenuItem>
        <DropdownMenuItem
          className="group cursor-pointer"
          onClick={() => {
            navigate({
              to: "/settings",
            });
          }}
        >
          <span className="text-zinc-100 group-hover:text-green-500 transition-all duration-100">
            Settings
          </span>
        </DropdownMenuItem>
      </DropdownMenuContent>
    </DropdownMenu>
  );
}
