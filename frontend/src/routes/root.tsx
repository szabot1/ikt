import React from "react";
import { Link } from "react-router-dom";

export default function RootPage() {
  return (
    <div className="flex flex-col">
      <Link to="/products">Products</Link>
      <Link to="/products/1">Product 1</Link>
    </div>
  );
}
