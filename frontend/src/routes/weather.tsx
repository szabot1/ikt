import { Link } from "react-router-dom";
import { useLoaderData } from "react-router-dom";

type Forecast = {
  date: string;
  temperatureC: number;
  temperatureF: number;
  summary: string;
};

export default function ProductsPage() {
  const data = useLoaderData() as Forecast[];

  return (
    <>
      <Link to="/">Back</Link>
      <ul>
        {data.map((item) => (
          <li key={item.date}>
            {item.date} - {item.summary} ({item.temperatureC} C,{" "}
            {item.temperatureF} F)
          </li>
        ))}
      </ul>
    </>
  );
}

export const loader = async () => {
  const res = await fetch(
    `${import.meta.env.VITE_BACKEND_PROD_URL}/WeatherForecast`
  );
  return await res.json();
};
