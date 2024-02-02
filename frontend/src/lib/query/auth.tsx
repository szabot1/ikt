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
    return { success: false, errors: (res as any).errors };
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

export type LoginResult = {
  success: boolean;
  errors: ErrorMap;
};

export async function login(login: Login): Promise<LoginResult> {
  const res = await post(
    `${import.meta.env.VITE_BACKEND_PROD_URL}/api/auth/login`,
    login
  );

  if (res.result === "success") {
    return { success: true, errors: {} };
  } else if (res.jsonError) {
    return { success: false, errors: (res as any).errors };
  } else {
    return {
      success: false,
      errors: { general: ["An unknown error occurred"] },
    };
  }
}
