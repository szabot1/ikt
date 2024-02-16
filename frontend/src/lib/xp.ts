export const CONSTANT = 0.1959;

export function exptoLevel(experience: number) {
  return Math.max(1, Math.floor(CONSTANT * Math.sqrt(experience)));
}

export function levelToRange(level: number) {
  const min = Math.floor(Math.pow(level / CONSTANT, 2));
  return [
    level == 1 ? 0 : min + 1,
    Math.floor(Math.pow((level + 1) / CONSTANT, 2)),
  ];
}

export function expToProgress(experience: number) {
  const level = exptoLevel(experience);
  const range = levelToRange(level);

  const progress = (experience - range[0]) / (range[1] - range[0]);
  return progress === 1 ? progress - 0.0001 : progress; // 100% progress should not be 100% width
}
