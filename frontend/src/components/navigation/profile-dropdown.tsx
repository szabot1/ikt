import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { type User as UserInfo, logout, userInfoQuery } from "@/lib/query/auth";
import { type Seller, sellerMeQuery } from "@/lib/query/seller";
import { useQuery } from "@tanstack/react-query";
import { useNavigate, useRouterState } from "@tanstack/react-router";
import md5 from "md5";

export default function ProfileDropdown() {
  const path = useRouterState().location.pathname;
  const navigate = useNavigate();

  const { data, isLoading } = useQuery(userInfoQuery());
  const userInfo = data as UserInfo;

  const { data: sellerData, isLoading: sellerIsLoading } =
    useQuery(sellerMeQuery());
  const sellerInfo = sellerData as Seller;

  if (isLoading || sellerIsLoading) {
    return null;
  }

  return (
    <DropdownMenu>
      <DropdownMenuTrigger asChild>
        <div className="cursor-pointer text-zinc-100 hover:text-green-500 transition-all duration-100 flex flex-row gap-2 justify-center items-center">
          <p>{userInfo.username}</p>
          <img
            src={`https://secure.gravatar.com/avatar/${md5(userInfo.email)}`}
            alt="avatar"
            className="w-8 h-8 rounded-full"
          />
        </div>
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

        {sellerInfo && (
          <DropdownMenuItem
            className="group cursor-pointer"
            onClick={() => {
              navigate({
                to: "/seller",
              });
            }}
          >
            <span className="text-green-500 group-hover:text-green-400 transition-all duration-100">
              Seller Dashboard
            </span>
          </DropdownMenuItem>
        )}

        {!path.startsWith("/admin") && userInfo.role === "admin" && (
          <>
            <DropdownMenuSeparator />

            <DropdownMenuItem
              className="group cursor-pointer"
              onClick={() => {
                navigate({
                  to: "/admin",
                });
              }}
            >
              <span className="text-blue-500 group-hover:text-blue-400 transition-all duration-100">
                Admin
              </span>
            </DropdownMenuItem>

            <DropdownMenuSeparator />
          </>
        )}

        <DropdownMenuItem
          className="group cursor-pointer"
          onClick={() => {
            logout();
          }}
        >
          <span className="text-red-500 group-hover:text-red-400 transition-all duration-100">
            Sign out
          </span>
        </DropdownMenuItem>
      </DropdownMenuContent>
    </DropdownMenu>
  );
}
