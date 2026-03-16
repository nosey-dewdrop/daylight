export function Stars() {
  const stars = Array.from({ length: 40 }, (_, i) => ({
    x: (i * 37 + 13) % 100,
    y: (i * 53 + 7) % 100,
    dur: `${3 + (i % 5)}s`,
    delay: `${(i % 7) * 0.7}s`,
    bright: String(0.2 + (i % 5) * 0.1),
  }))
  return (
    <div className="stars">
      {stars.map((s, i) => (
        <div key={i} className="star" style={{
          left: `${s.x}%`, top: `${s.y}%`,
          '--dur': s.dur, '--delay': s.delay, '--bright': s.bright,
        } as React.CSSProperties} />
      ))}
    </div>
  )
}
