import React, { useContext, useEffect } from "react";
import { createContext, useState } from "react";

export type AuthState = {
  accessToken: string | null;
  refreshToken: string | null;
  isAuthenticated: boolean;
};

const AuthContext = createContext<AuthState | null>(null);

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [accessToken, setAccessToken] = useState(load("accessToken"));
  const [refreshToken, setRefreshToken] = useState(load("refreshToken"));

  useEffect(() => {
    const onStorage = (e: StorageEvent) => {
      if (e.key === "accessToken") {
        setAccessToken(e.newValue);
      } else if (e.key === "refreshToken") {
        setRefreshToken(e.newValue);
      }
    };

    window.addEventListener("storage", onStorage);
    return () => window.removeEventListener("storage", onStorage);
  }, []);

  return (
    <AuthContext.Provider
      value={{
        accessToken,
        refreshToken,
        isAuthenticated: !!accessToken,
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

export function setSession(accessToken: string, refreshToken: string) {
  persist("accessToken", accessToken);
  dispatch("accessToken", accessToken);

  persist("refreshToken", refreshToken);
  dispatch("refreshToken", refreshToken);
}

export function clearSession() {
  persist("accessToken", null);
  dispatch("accessToken", null);

  persist("refreshToken", null);
  dispatch("refreshToken", null);
}

function dispatch(key: string, value: string | null) {
  if (typeof window !== "undefined") {
    let event = new StorageEvent("storage");
    Object.defineProperty(event, "key", { value: key });
    Object.defineProperty(event, "newValue", { value: value });
    window.dispatchEvent(event);
  }
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
