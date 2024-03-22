import {
  FieldValues,
  Path,
  UseFormClearErrors,
  UseFormSetError,
} from "react-hook-form";
import { post } from "../fetch";
import { makeQuery } from "./util";
import { clearSession } from "../auth";

export async function logout() {
  await post(`${import.meta.env.VITE_BACKEND_PROD_URL}/api/auth/logout`, {
    accessToken: localStorage.getItem("accessToken"),
    refreshToken: localStorage.getItem("refreshToken"),
  });

  clearSession();
}

export type UserRole = "user" | "support" | "admin";

export type User = {
  id: string;
  email: string;
  username: string;
  role: UserRole;
  experience: UserExperience;
  social: UserSocial;
};

export type UserExperience = {
  userId: string;
  experience: number;
};

export type UserSocial = {
  userId: string;
  discord: string | null;
  steam: string | null;
  ubisoft: string | null;
  epic: string | null;
  origin: string | null;
  battleNet: string | null;
  createdAt: string;
  updatedAt: string;
};

export function userInfoQuery() {
  return makeQuery(
    ["userInfo"],
    `${import.meta.env.VITE_BACKEND_PROD_URL}/api/auth/user-info`
  );
}

export type SocialLinks = {
  discord: string;
  steam: string;
  ubisoft: string;
  epic: string;
  origin: string;
  battleNet: string;
};

export async function setSocialLinks(
  links: SocialLinks
): Promise<string | null> {
  const response = await post(
    `${import.meta.env.VITE_BACKEND_PROD_URL}/api/auth/set-social-links`,
    links
  );

  if (response.result === "success") {
    return null;
  }

  return response.error?.message || "An error occurred";
}

export type ErrorMap = {
  [key: string]: string[];
};

export type Register = {
  email: string;
  emailCode: string;
  username: string;
  password: string;
};

export type RegisterResult = {
  success: boolean;
  emailCodeRequired: boolean;
  statusCode: number;
  errors: ErrorMap;
};

export async function register(register: Register): Promise<RegisterResult> {
  const res = await post(
    `${import.meta.env.VITE_BACKEND_PROD_URL}/api/auth/register`,
    register
  );

  if (res.result === "success") {
    return {
      success: true,
      emailCodeRequired: false,
      statusCode: 200,
      errors: {},
    };
  } else if (res.jsonError) {
    return {
      success: false,
      emailCodeRequired: res.status === 418,
      statusCode: res.status,
      errors: (res.error as any).errors,
    };
  } else {
    return {
      success: false,
      emailCodeRequired: res.status === 418,
      statusCode: res.status,
      errors: { general: ["An unknown error occurred"] },
    };
  }
}

export type Login = {
  email: string;
  password: string;
};

export type LoginResult =
  | { success: true; accessToken: string; refreshToken: string }
  | { success: false; statusCode: number; errors: ErrorMap };

export async function login(login: Login): Promise<LoginResult> {
  const res = await post(
    `${import.meta.env.VITE_BACKEND_PROD_URL}/api/auth/login`,
    login
  );

  if (res.result === "success") {
    return {
      success: true,
      accessToken: (res.data as any).accessToken,
      refreshToken: (res.data as any).refreshToken,
    };
  } else if (res.jsonError) {
    return {
      success: false,
      statusCode: res.status,
      errors: (res.error as any).errors,
    };
  } else {
    return {
      success: false,
      statusCode: res.status,
      errors: { general: ["An unknown error occurred"] },
    };
  }
}

export type Refresh = {
  refreshToken: string;
};

export type RefreshResult =
  | { success: true; accessToken: string }
  | { success: false; errors: ErrorMap };

export async function refresh(refresh: Refresh): Promise<RefreshResult> {
  const res = await post(
    `${import.meta.env.VITE_BACKEND_PROD_URL}/api/auth/refresh`,
    refresh
  );

  if (res.result === "success") {
    return { success: true, accessToken: (res.data as any).accessToken };
  } else if (res.jsonError) {
    return { success: false, errors: (res.error as any).errors };
  } else {
    return {
      success: false,
      errors: { general: ["An unknown error occurred"] },
    };
  }
}

export function setFormError<T extends FieldValues>(
  setError: UseFormSetError<T>,
  clearErrors: UseFormClearErrors<T>,
  name: Path<T>,
  errors: string[] | undefined
) {
  if (!errors || errors.length === 0) {
    clearErrors(name);
    return;
  }

  setError(name, { message: errors[0] });
}
