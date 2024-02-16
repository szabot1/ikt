import { Badge } from "@/components/ui/badge";
import ErrorPage from "@/error-page";
import { User as UserInfo, userInfoQuery } from "@/lib/query/auth";
import { cn } from "@/lib/style";
import { expToProgress, exptoLevel } from "@/lib/xp";
import { useQuery } from "@tanstack/react-query";
import { FileRoute, redirect } from "@tanstack/react-router";
import md5 from "md5";
import { Helmet } from "react-helmet-async";

export const Route = new FileRoute("/profile").createRoute({
  component: Profile,
  errorComponent: ErrorPage,
  beforeLoad: async ({ context: { auth } }) => {
    if (!auth.isAuthenticated) {
      throw redirect({
        to: "/auth/signin",
        search: {
          redirect: "/profile",
        },
      });
    }
  },
});

const roleStyles: Record<string, [string, string]> = {
  support: ["Support", "!bg-blue-500 !text-blue-100"],
  admin: ["Admin", "!bg-red-500 !text-red-100"],
};

function Profile() {
  const { data, isLoading } = useQuery(userInfoQuery());
  const userInfo = data as UserInfo;

  if (isLoading || !data) {
    return null;
  }

  const level = exptoLevel(userInfo.experience.experience);
  const progress = expToProgress(userInfo.experience.experience);
  const normalizedProgress = Math.max(0.001, Math.min(99.999, progress * 100));

  const roleStyle = roleStyles[userInfo.role];

  return (
    <section className="grow flex flex-col lg:flex-row gap-4 lg:gap-12 items-center justify-center">
      <Helmet prioritizeSeoTags>
        <title>Profile</title>
      </Helmet>

      <div className="px-6 py-3 border-2 border-zinc-700 rounded-lg w-10/12 md:w-6/12 lg:w-3/12 flex items-center flex-col gap-4">
        <div className="flex justify-center">
          <div
            className="relative p-2 rounded-full"
            style={{
              background: `radial-gradient(closest-side, white 79%, transparent 80% 100%), conic-gradient(var(--green-500) ${normalizedProgress}%, var(--zinc-700) 0)`,
            }}
          >
            <span className="pointer-events-none absolute bg-green-600 rounded-md text-md py-0.5 px-1 left-1/2 -translate-x-1/2 top-full -translate-y-5">
              Lvl {level}
            </span>

            <img
              src={`https://secure.gravatar.com/avatar/${md5(userInfo.email)}?size=1024`}
              className="w-24 h-24 rounded-full z-50"
            />
          </div>
        </div>

        <div className="flex flex-row items-center justify-center gap-2">
          <h1 className="font-semibold text-2xl">{userInfo.username}</h1>

          {roleStyle && (
            <Badge className={cn("mt-1", roleStyle[1])}>{roleStyle[0]}</Badge>
          )}
        </div>

        <div className="grid grid-rows-3 grid-cols-2 gap-2">
          <SocialLink
            baseUrl="https://discord.com"
            iconFile="discord"
            value={userInfo.social.discord}
          />
          <SocialLink
            baseUrl="https://steamcommunity.com"
            iconFile="steam"
            value={userInfo.social.steam}
          />
          <SocialLink
            baseUrl="https://ubisoft.com"
            iconFile="ubisoft"
            value={userInfo.social.ubisoft}
          />
          <SocialLink
            baseUrl="https://epicgames.com"
            iconFile="epic"
            value={userInfo.social.epic}
          />
          <SocialLink
            baseUrl="https://origin.com"
            iconFile="origin"
            value={userInfo.social.origin}
          />
          <SocialLink
            baseUrl="https://battle.net"
            iconFile="battlenet"
            value={userInfo.social.battlenet}
          />
        </div>
      </div>
    </section>
  );
}

const SocialLink = ({
  baseUrl,
  iconFile,
  value,
}: {
  baseUrl: string;
  iconFile: string;
  value: string | null;
}) => {
  return (
    <div
      className="flex flex-row items-center justify-center gap-2 cursor-pointer"
      onClick={() => {
        if (!value) return;

        window.open(value, "_blank");
      }}
    >
      <img
        src={`/assets/social-icons/${iconFile}.svg`}
        className="w-6 h-6 invert"
      />

      {value?.replace(`${baseUrl}/`, "") || "No account"}
    </div>
  );
};
