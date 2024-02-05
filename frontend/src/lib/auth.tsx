import React, { useContext } from "react";
import { createContext, useState } from "react";

export type AuthState = {
  accessToken: string | null;
  refreshToken: string | null;
  isAuthenticated: boolean;
};

const AuthContext = createContext<AuthState | null>(null);

export function AuthProvider({ children }: { children: React.ReactNode }) {
  return (
    <AuthContext.Provider
      value={{
        get ["accessToken"]() {
          return load("accessToken");
        },

        get ["refreshToken"]() {
          return load("refreshToken");
        },

        get ["isAuthenticated"]() {
          return !!load("accessToken");
        },
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
  persist("refreshToken", refreshToken);
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
