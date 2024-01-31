import { get } from "../fetch";

export interface Tag {
  id: string;
  name: string;
  createdAt: string;
}

export const tagsQuery = {
  queryKey: ["tags"],
  queryFn: async () => {
    const url = `${import.meta.env.VITE_BACKEND_PROD_URL}/api/tags`;
    const res = await get(url);

    if (res.result === "success") {
      return res.data as Tag[];
    } else {
      throw new Error(
        `Backend fetch failed: status=${res.status}, error=${res.error}`
      );
    }
  },
};
