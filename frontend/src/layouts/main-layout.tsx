import MainNavigation from "@/components/layout/navigation";
import { Outlet } from "react-router-dom";

export default function MainLayout() {
  return (
    <main className="flex flex-col gap-16 w-full h-full">
      <MainNavigation />
      <Outlet />
    </main>
  );
}
