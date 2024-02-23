import { get } from "../fetch";

export class QueryError extends Error {
  constructor(
    message: string,
    public status: number,
    public error: string
  ) {
    super(message);
  }
}

export function makeQuery(key: string[], url: string) {
  return {
    queryKey: key,
    queryFn: async () => {
      const res = await get(url);

      if (res.result === "success") {
        return res.data;
      } else {
        throw new QueryError(
          `Backend fetch failed: status=${res.status}, error=${res.error}`,
          res.status,
          res.error
        );
      }
    },
  };
}
