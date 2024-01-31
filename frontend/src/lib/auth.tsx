import React, { useContext } from "react";
import { createContext, useState } from "react";

export type AuthState = {
  isAuthenticated: boolean;

  setAccessToken: (accessToken: string | null) => void;
  accessToken: string | null;

  setRefreshToken: (refreshToken: string | null) => void;
  refreshToken: string | null;
};

const AuthContext = createContext<AuthState | null>(null);

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [accessToken, setAccessToken] = useState<string | null>(
    load("accessToken")
  );
  const [refreshToken, setRefreshToken] = useState<string | null>(
    load("refreshToken")
  );

  const isAuthenticated = !!accessToken;

  return (
    <AuthContext.Provider
      value={{
        isAuthenticated,
        setAccessToken: wrapSetter("accessToken", setAccessToken),
        accessToken,
        setRefreshToken: wrapSetter("refreshToken", setRefreshToken),
        refreshToken,
      }}
    >
      {children}
    </AuthContext.Provider>
  );
}

export function useOptionalAuth() {
  return useContext(AuthContext);
}

export function useAuth() {
  const auth = useOptionalAuth();

  if (!auth) {
    throw new Error("useAuth must be used within AuthProvider");
  }

  return auth;
}

function wrapSetter(key: string, setter: (value: string | null) => void) {
  return (value: string | null) => {
    persist(key, value);
    setter(value);
  };
}

function persist(key: string, value: string | null) {
  if (typeof window === "undefined") {
    return;
  }

  if (value === null) {
    window.localStorage.removeItem(key);
  } else {
    window.localStorage.setItem(key, value);
  }
}

function load(key: string): string | null {
  if (typeof window === "undefined") {
    return null;
  }

  return window.localStorage.getItem(key);
}
