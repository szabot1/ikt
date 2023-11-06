import { Link } from "react-router-dom";
import { useLoaderData } from "react-router-dom";

type Product = {
  id: string;
  title: string;
  description: string;
};

export default function Productpage() {
  const data = useLoaderData() as Product;

  return (
    <>
      <Link to="/">Back</Link>
      <div>{data.title}</div>
    </>
  );
}

export const loader = async ({ params }: { params: any }) => {
  const res = await fetch(`https://dummyjson.com/product/${params.id}`);
  return await res.json();
};
