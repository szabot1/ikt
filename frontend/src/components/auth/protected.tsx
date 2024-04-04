import {
  type User as UserInfo,
  userInfoQuery,
  UserRole,
} from "@/lib/query/auth";
import { useQuery } from "@tanstack/react-query";
import { useNavigate } from "@tanstack/react-router";
import { Loader } from "lucide-react";

export function SupportRoute({ children }: { children: React.ReactNode }) {
  return (
    <ProtectedRoute allowedRoles={["support", "admin"]}>
      {children}
    </ProtectedRoute>
  );
}

export function AdminRoute({ children }: { children: React.ReactNode }) {
  return <ProtectedRoute allowedRoles={["admin"]}>{children}</ProtectedRoute>;
}

export default function ProtectedRoute({
  children,
  allowedRoles,
}: {
  children: React.ReactNode;
  allowedRoles: UserRole[];
}) {
  const navigate = useNavigate();

  const { data, isLoading } = useQuery(userInfoQuery());
  const userInfo = data as UserInfo;

  if (isLoading || !data) {
    return (
      <div className="flex items-center justify-center w-full h-full grow">
        <Loader className="h-4 w-4 animate-spin" />
      </div>
    );
  }

  if (!allowedRoles.includes(userInfo.role)) {
    navigate({
      to: "/",
    });
    return null;
  }

  return <>{children}</>;
}
