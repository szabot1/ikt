import { setSession } from "./auth";
import { Refresh, refresh } from "./query/auth";

export type FetchResponse<T> =
  | { result: "success"; data: T }
  | { result: "error"; status: number; jsonError: true; error: any }
  | { result: "error"; status: number; jsonError: false; error: any };

export async function get<T>(url: string): Promise<FetchResponse<T>> {
  return method(url, "GET");
}

export async function post<T>(
  url: string,
  body?: any
): Promise<FetchResponse<T>> {
  return method(url, "POST", body);
}

export async function put<T>(
  url: string,
  body?: any
): Promise<FetchResponse<T>> {
  return method(url, "PUT", body);
}

export async function del<T>(url: string): Promise<FetchResponse<T>> {
  return method(url, "DELETE");
}

export async function method<T>(
  url: string,
  method: string,
  body?: any
): Promise<FetchResponse<T>> {
  return fetch(url, {
    method,
    ...(body && { body: JSON.stringify(body) }),
  });
}

export async function fetch<T>(
  url: string,
  options: any = {}
): Promise<FetchResponse<T>> {
  const accessToken =
    typeof window !== "undefined" && window.localStorage.getItem("accessToken");

  const refreshToken =
    typeof window !== "undefined" &&
    window.localStorage.getItem("refreshToken");

  const headers = {
    "Content-Type": "application/json",
    ...(accessToken && { Authorization: `Bearer ${accessToken}` }),
  };

  try {
    const response = await window.fetch(url, { ...options, headers });

    if (response.ok) {
      const data = await response.json();
      return { result: "success", data };
    } else if (response.status === 401 && accessToken && refreshToken) {
      const response = await refresh({
        refreshToken,
      } as Refresh);

      if (response.success) {
        setSession(response.accessToken, refreshToken);
        return fetch(url, options);
      }
    }

    const error = await response.json();

    return {
      result: "error",
      status: response.status,
      jsonError: true,
      error,
    };
  } catch (error) {
    return {
      result: "error",
      status: 500,
      jsonError: false,
      error: error,
    };
  }
}
