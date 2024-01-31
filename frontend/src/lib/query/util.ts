import { get } from "../fetch";

export function makeQuery(key: string[], url: string) {
  return {
    queryKey: key,
    queryFn: async () => {
      const res = await get(url);

      if (res.result === "success") {
        return res.data;
      } else {
        throw new Error(
          `Backend fetch failed: status=${res.status}, error=${res.error}`
        );
      }
    },
  };
}
