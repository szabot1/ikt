export function seoPathKey(path: string): string {
  return path.split("-")[0];
}

export function seoPath(key: string, fancyName: string): string {
  return `${key}-${fancyName.toLowerCase().replace(/ /g, "-")}`;
}
