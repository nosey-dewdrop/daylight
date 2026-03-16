import { Stars } from '@/components/Stars'
import { ThemeToggle } from '@/components/ThemeToggle'

const ARTICLES = [
  { slug: 'orpheus-eurydice', category: 'mythology', title: 'Orpheus & Eurydice', desc: 'the original love letter — a song so beautiful it opened the gates of the underworld. what does it mean to love someone so much you\'d walk into death?', icon: '🏛', author: 'damla' },
  { slug: 'kafka-milena', category: 'literary love', title: 'Kafka\'s Letters to Milena', desc: 'franz kafka wrote hundreds of letters to milena jesenská. they met twice. but in those letters, he was more honest than most people are in a lifetime.', icon: '📜', author: 'damla' },
  { slug: 'heathcliff-catherine', category: 'historical letters', title: 'Heathcliff & Catherine', desc: '"whatever our souls are made of, his and mine are the same." brontë wrote a love that destroyed everything it touched — and we still can\'t look away.', icon: '🌪', author: 'damla' },
  { slug: 'letter-of-the-week', category: 'featured', title: 'Letter of the Week', desc: 'every week, we feature one anonymous letter from the forget-me-not community. this week: a letter from tokyo to istanbul about the silence between two people.', icon: '✦', author: 'sora' },
]

export default function BlogPage() {
  return (
    <>
      <Stars />
      <nav className="topnav">
        <span className="nav-brand">forget-me-not<span>_ letters that last</span></span>
        <div className="nav-search"><input placeholder="search..." /></div>
        <div className="nav-right">
          {['inbox', 'explore', 'bottle', 'memory', 'blog', 'profile'].map((item) => (
            <a key={item} href={item === 'inbox' ? '/dashboard' : `/${item}`} className={`nav-link ${item === 'blog' ? 'active' : ''}`}>{item}</a>
          ))}
          <ThemeToggle />
        </div>
      </nav>

      <div style={{ maxWidth: 640, margin: '0 auto', padding: '80px 24px 60px', position: 'relative', zIndex: 1 }}>
        <h2 style={{ fontSize: 22, fontWeight: 700, color: 'var(--lilac)', marginBottom: 4 }}>
          the forget-me-not blog<span className="cursor"></span>
        </h2>
        <p className="prompt" style={{ fontSize: 13, marginBottom: 32 }}>love stories that never grow old.</p>

        {ARTICLES.map((a, i) => (
          <div key={i}>
            <a href={`/blog/${a.slug}`} style={{ textDecoration: 'none', display: 'block', padding: '24px 0' }}>
              <div style={{ fontSize: 10, color: 'var(--gold)', textTransform: 'uppercase', letterSpacing: '0.1em', marginBottom: 8 }}>{a.category}</div>
              <div style={{ display: 'flex', gap: 16, alignItems: 'flex-start' }}>
                <span style={{ fontSize: 28, flexShrink: 0 }}>{a.icon}</span>
                <div>
                  <h3 style={{ fontSize: 18, fontWeight: 700, color: 'var(--lilac)', marginBottom: 6 }}>{a.title}</h3>
                  <p style={{ fontSize: 13, color: 'var(--tx2)', lineHeight: 1.8 }}>{a.desc}</p>
                  <div style={{ fontSize: 11, color: 'var(--tx4)', marginTop: 8 }}>published by @{a.author}</div>
                  <span style={{ fontSize: 12, color: 'var(--lilac)', marginTop: 6, display: 'inline-block' }}>read story &rarr;</span>
                </div>
              </div>
            </a>
            {i < ARTICLES.length - 1 && <hr className="divider" />}
          </div>
        ))}
      </div>
    </>
  )
}
