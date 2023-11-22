import { Link } from "react-router-dom";
import { useLoaderData } from "react-router-dom";

type Tag = {
  id: string;
  name: string;
  createdAt: string;
};

export default function TestPage() {
  const data = useLoaderData() as Tag[];

  return (
    <>
      <Link to="/">Back</Link>
      <ul>
        {data.map((item) => (
          <li key={item.id}>
            {item.name} - Created at: {item.createdAt}
          </li>
        ))}
      </ul>
    </>
  );
}

export const loader = async () => {
  const res = await fetch(`${import.meta.env.VITE_BACKEND_PROD_URL}/api/tags`);
  return await res.json();
};
