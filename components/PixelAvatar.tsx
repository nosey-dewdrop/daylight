'use client'

// deterministic pixel art avatar from a seed string
const PALETTES = [
  ['#B8A4D6', '#D4A0B9', '#9882BA'],  // lilac
  ['#D4B896', '#D4A0B9', '#B8A4D6'],  // warm
  ['#9882BA', '#7B68A0', '#B8A4D6'],  // deep
  ['#D4A0B9', '#B8A4D6', '#D4B896'],  // pink
  ['#7B68A0', '#D4B896', '#9882BA'],  // earth
]

function hash(str: string): number {
  let h = 0
  for (let i = 0; i < str.length; i++) {
    h = ((h << 5) - h + str.charCodeAt(i)) | 0
  }
  return Math.abs(h)
}

export function PixelAvatar({ seed, size = 40 }: { seed: string; size?: number }) {
  const h = hash(seed)
  const palette = PALETTES[h % PALETTES.length]
  const grid = 5
  const px = size / grid

  // generate symmetric 5x5 grid (mirror left half to right)
  const cells: { x: number; y: number; color: string }[] = []

  for (let y = 0; y < grid; y++) {
    for (let x = 0; x < Math.ceil(grid / 2); x++) {
      const idx = y * 3 + x
      const bit = (h >> (idx % 30)) & 1
      if (bit || (x === 1 && y > 0 && y < 4)) {
        const color = palette[(h >> (idx + 3)) % palette.length]
        cells.push({ x, y, color })
        // mirror
        if (x !== Math.floor(grid / 2)) {
          cells.push({ x: grid - 1 - x, y, color })
        }
      }
    }
  }

  return (
    <svg
      width={size}
      height={size}
      viewBox={`0 0 ${size} ${size}`}
      style={{ borderRadius: 6, flexShrink: 0, border: '1px solid var(--brd)', background: 'var(--bg2)' }}
    >
      {cells.map((c, i) => (
        <rect key={i} x={c.x * px} y={c.y * px} width={px} height={px} fill={c.color} />
      ))}
    </svg>
  )
}
