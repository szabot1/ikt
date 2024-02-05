import {
  FieldValues,
  Path,
  UseFormClearErrors,
  UseFormSetError,
} from "react-hook-form";
import { post } from "../fetch";

export type ErrorMap = {
  [key: string]: string[];
};

export type Register = {
  email: string;
  username: string;
  password: string;
};

export type RegisterResult = {
  success: boolean;
  errors: ErrorMap;
};

export async function register(register: Register): Promise<RegisterResult> {
  const res = await post(
    `${import.meta.env.VITE_BACKEND_PROD_URL}/api/auth/register`,
    register
  );

  if (res.result === "success") {
    return { success: true, errors: {} };
  } else if (res.jsonError) {
    return { success: false, errors: (res.error as any).errors };
  } else {
    return {
      success: false,
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
  | { success: false; errors: ErrorMap };

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
    return { success: false, errors: (res.error as any).errors };
  } else {
    return {
      success: false,
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
