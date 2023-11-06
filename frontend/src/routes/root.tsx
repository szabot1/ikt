import { Link } from "react-router-dom";

export default function RootPage() {
  return (
    <div className="flex flex-col">
      <Link to="/products">Products</Link>
      <Link to="/products/1">Product 1</Link>

      <p>{import.meta.env.VITE_FRONTEND_PROD_URL}</p>
      <p>{import.meta.env.VITE_BACKEND_PROD_URL}</p>
    </div>
  );
}
