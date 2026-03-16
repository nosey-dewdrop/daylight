export const LEVELS = [
  { level: 1, name: 'seedling', xp: 0 },
  { level: 2, name: 'sprout', xp: 100 },
  { level: 3, name: 'bloom', xp: 300 },
  { level: 4, name: 'stargazer', xp: 600 },
  { level: 5, name: 'constellation', xp: 1000 },
  { level: 6, name: 'aurora', xp: 1500 },
  { level: 7, name: 'nebula', xp: 2500 },
  { level: 8, name: 'eclipse', xp: 4000 },
  { level: 9, name: 'supernova', xp: 6000 },
  { level: 10, name: 'cosmos', xp: 10000 },
]

export function getLevelInfo(xp: number) {
  let current = LEVELS[0]
  let next = LEVELS[1]
  for (let i = LEVELS.length - 1; i >= 0; i--) {
    if (xp >= LEVELS[i].xp) {
      current = LEVELS[i]
      next = LEVELS[i + 1] || LEVELS[i]
      break
    }
  }
  return { level: current.level, name: current.name, xp, xpNext: next.xp }
}

export function haversineDistance(lat1: number, lon1: number, lat2: number, lon2: number): number {
  const R = 6371
  const dLat = (lat2 - lat1) * Math.PI / 180
  const dLon = (lon2 - lon1) * Math.PI / 180
  const a = Math.sin(dLat / 2) ** 2 +
    Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) *
    Math.sin(dLon / 2) ** 2
  return R * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
}

export function deliveryHours(distanceKm: number): number {
  return Math.max(0.5, distanceKm / 100)
}

export function timeLeft(deliversAt: string): string {
  const diff = new Date(deliversAt).getTime() - Date.now()
  if (diff <= 0) return 'arrived'
  const hours = diff / (1000 * 60 * 60)
  if (hours < 1) return `${Math.round(hours * 60)}m left`
  if (hours < 24) return `${Math.round(hours)}h left`
  const days = hours / 24
  if (days < 2) return '~1 day left'
  return `~${Math.round(days)} days left`
}

export function journeyProgress(sentAt: string, deliversAt: string): number {
  const start = new Date(sentAt).getTime()
  const end = new Date(deliversAt).getTime()
  const now = Date.now()
  if (now >= end) return 100
  if (now <= start) return 0
  return Math.round(((now - start) / (end - start)) * 100)
}

export function formatDate(date: string): string {
  return new Date(date).toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' })
}
