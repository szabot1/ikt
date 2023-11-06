import { Link } from "react-router-dom";
import { useLoaderData } from "react-router-dom";

type Product = {
  id: string;
  title: string;
  description: string;
};

type ProductData = {
  products: Product[];
};

export default function ProductsPage() {
  const data = useLoaderData() as ProductData;

  return (
    <>
      <Link to="/">Back</Link>
      <ul>
        {data.products.map((item) => (
          <li key={item.id}>{item.title}</li>
        ))}
      </ul>
    </>
  );
}

export const loader = async () => {
  const res = await fetch(`https://dummyjson.com/products`);
  return await res.json();
};
