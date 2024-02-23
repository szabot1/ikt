import {
  type User as UserInfo,
  userInfoQuery,
  UserRole,
} from "@/lib/query/auth";
import { useQuery } from "@tanstack/react-query";
import { useNavigate } from "@tanstack/react-router";

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
    return null;
  }

  if (!allowedRoles.includes(userInfo.role)) {
    navigate({
      to: "/",
    });
    return null;
  }

  return <>{children}</>;
}
