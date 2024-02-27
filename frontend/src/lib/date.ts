export function localDate(date: string) {
  if (!date.endsWith("Z")) {
    date += "Z";
  }

  return new Date(date).toLocaleString();
}
