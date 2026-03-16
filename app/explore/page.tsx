'use client'

export const dynamic = 'force-dynamic'

import { useState, useEffect } from 'react'
import { useRouter } from 'next/navigation'
import { Stars } from '@/components/Stars'
import { ThemeToggle } from '@/components/ThemeToggle'
import { supabase } from '@/lib/supabase'
import type { User } from '@/types'

type ExploreUser = User & { userInterests: string[]; avatarEmoji: string }

export default function ExplorePage() {
  const router = useRouter()
  const [filter, setFilter] = useState('all')
  const [lang, setLang] = useState('all')
  const [people, setPeople] = useState<ExploreUser[]>([])
  const [allInterests, setAllInterests] = useState<string[]>([])
  const [loading, setLoading] = useState(true)
  const [currentUserId, setCurrentUserId] = useState<string>('')

  useEffect(() => { loadExplore() }, [])

  async function loadExplore() {
    const { data: { user: authUser } } = await supabase.auth.getUser()
    if (!authUser) { router.push('/login'); return }
    setCurrentUserId(authUser.id)

    // fetch all users except current
    const { data: users } = await supabase
      .from('users')
      .select('*')
      .neq('id', authUser.id)
      .eq('onboarding_complete', true)
      .order('last_active_at', { ascending: false })
      .limit(50)

    if (!users) { setLoading(false); return }

    // fetch interests for all users
    const userIds = users.map(u => u.id)
    const { data: allUi } = await supabase
      .from('user_interests')
      .select('user_id, interests(name)')
      .in('user_id', userIds)

    // fetch avatars
    const avatarIds = [...new Set(users.map(u => u.avatar_id).filter(Boolean))]
    const { data: avatars } = await supabase.from('avatars').select('id, emoji').in('id', avatarIds)
    const avatarMap: Record<number, string> = {}
    avatars?.forEach(a => { avatarMap[a.id] = a.emoji })

    // build interest map
    const interestMap: Record<string, string[]> = {}
    allUi?.forEach((ui: any) => {
      if (!interestMap[ui.user_id]) interestMap[ui.user_id] = []
      if (ui.interests?.name) interestMap[ui.user_id].push(ui.interests.name)
    })

    // collect all unique interests for filters
    const uniqueInterests = new Set<string>()
    Object.values(interestMap).forEach(arr => arr.forEach(i => uniqueInterests.add(i)))
    setAllInterests(['all', ...Array.from(uniqueInterests)])

    const enriched: ExploreUser[] = users.map(u => ({
      ...u,
      userInterests: interestMap[u.id] || [],
      avatarEmoji: avatarMap[u.avatar_id || 0] || '✦',
    }))

    setPeople(enriched)
    setLoading(false)
  }

  const filtered = people.filter(p => {
    if (filter !== 'all' && !p.userInterests.includes(filter)) return false
    if (lang !== 'all' && !p.languages?.includes(lang)) return false
    return true
  })

  // collect unique languages for filter
  const allLanguages = ['all', ...new Set(people.flatMap(p => p.languages || []))]

  if (loading) {
    return (
      <>
        <Stars />
        <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '100vh', color: 'var(--tx3)', fontSize: 14 }}>
          finding kindred spirits...
        </div>
      </>
    )
  }

  return (
    <>
      <Stars />
      <nav className="topnav">
        <span className="nav-brand">forget-me-not<span>_ letters that last</span></span>
        <div className="nav-search"><input placeholder="search..." /></div>
        <div className="nav-right">
          {['inbox', 'explore', 'bottle', 'memory', 'blog', 'profile'].map((item) => (
            <a key={item} href={item === 'inbox' ? '/dashboard' : `/${item}`} className={`nav-link ${item === 'explore' ? 'active' : ''}`}>{item}</a>
          ))}
          <ThemeToggle />
        </div>
      </nav>

      <div style={{ maxWidth: 800, margin: '0 auto', padding: '80px 24px 60px', position: 'relative', zIndex: 1 }}>
        <h2 style={{ fontSize: 22, fontWeight: 700, color: 'var(--lilac)', marginBottom: 4 }}>
          explore<span className="cursor"></span>
        </h2>
        <p className="prompt" style={{ fontSize: 13, marginBottom: 24 }}>find kindred spirits across the world.</p>

        <div style={{ display: 'flex', gap: 6, flexWrap: 'wrap', marginBottom: 12 }}>
          {allLanguages.slice(0, 10).map(l => (
            <button key={l} className="tag" onClick={() => setLang(l)}
              style={{ cursor: 'pointer', borderColor: lang === l ? 'var(--lilac)' : undefined, color: lang === l ? 'var(--lilac)' : undefined }}>
              {l}
            </button>
          ))}
        </div>
        <div style={{ display: 'flex', gap: 6, flexWrap: 'wrap', marginBottom: 32 }}>
          {allInterests.slice(0, 12).map(f => (
            <button key={f} className="tag" onClick={() => setFilter(f)}
              style={{ cursor: 'pointer', borderColor: filter === f ? 'var(--lilac)' : undefined, color: filter === f ? 'var(--lilac)' : undefined }}>
              {f}
            </button>
          ))}
        </div>

        {filtered.length === 0 && (
          <div style={{ textAlign: 'center', padding: '40px 0', color: 'var(--tx4)', fontSize: 13 }}>
            no one found with these filters — try different ones.
          </div>
        )}

        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(320px, 1fr))', gap: 16 }}>
          {filtered.map(p => (
            <div key={p.id} className="card" style={{ cursor: 'pointer' }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: 12, marginBottom: 12 }}>
                <div className="avatar" style={{ width: 44, height: 44, fontSize: 20 }}>{p.avatarEmoji}</div>
                <div>
                  <div style={{ fontSize: 14, color: 'var(--lilac)', fontWeight: 700 }}>@{p.display_name}</div>
                  <div style={{ fontSize: 12, color: 'var(--tx4)' }}>{p.country}</div>
                </div>
              </div>
              {p.bio && <p style={{ fontSize: 13, color: 'var(--tx2)', lineHeight: 1.7, marginBottom: 12 }}>{p.bio}</p>}
              <div style={{ display: 'flex', gap: 6, flexWrap: 'wrap', marginBottom: 8 }}>
                {p.userInterests.map(i => <span key={i} className="tag">{i}</span>)}
              </div>
              <div style={{ fontSize: 11, color: 'var(--tx4)' }}>
                {p.mbti && `${p.mbti} · `}{p.zodiac || ''}
              </div>
              <a href={`/compose?to=${p.id}`} className="btn btn-sm" style={{ marginTop: 12 }}>write a letter</a>
            </div>
          ))}
        </div>
      </div>
    </>
  )
}
