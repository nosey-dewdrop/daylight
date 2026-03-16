'use client'

export const dynamic = 'force-dynamic'

import { useState, useEffect } from 'react'
import { useRouter } from 'next/navigation'
import { Stars } from '@/components/Stars'
import { ThemeToggle } from '@/components/ThemeToggle'
import { PixelAvatar } from '@/components/PixelAvatar'
import { supabase } from '@/lib/supabase'
import { getLevelInfo } from '@/lib/utils'
import type { User } from '@/types'

export default function ProfilePage() {
  const router = useRouter()
  const [user, setUser] = useState<User | null>(null)
  const [avatar, setAvatar] = useState('🦢')
  const [interests, setInterests] = useState<string[]>([])
  const [stamps, setStamps] = useState<{ emoji: string; name: string }[]>([])
  const [allStamps, setAllStamps] = useState<{ emoji: string; name: string; earned: boolean }[]>([])
  const [sentCount, setSentCount] = useState(0)
  const [receivedCount, setReceivedCount] = useState(0)
  const [streaks, setStreaks] = useState<{ name: string; country: string; count: number }[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => { loadProfile() }, [])

  async function loadProfile() {
    const { data: { user: authUser } } = await supabase.auth.getUser()
    if (!authUser) { router.push('/login'); return }

    const { data: profile } = await supabase.from('users').select('*').eq('id', authUser.id).single()
    if (!profile) { router.push('/onboarding'); return }
    setUser(profile)

    // avatar
    if (profile.avatar_id) {
      const { data: av } = await supabase.from('avatars').select('emoji').eq('id', profile.avatar_id).single()
      if (av) setAvatar(av.emoji)
    }

    // interests
    const { data: ui } = await supabase
      .from('user_interests')
      .select('interests(name)')
      .eq('user_id', authUser.id)
    if (ui) setInterests(ui.map((x: any) => x.interests?.name).filter(Boolean))

    // stamps (earned)
    const { data: userStamps } = await supabase
      .from('user_stamps')
      .select('stamps(emoji, name)')
      .eq('user_id', authUser.id)
    const earned = userStamps?.map((x: any) => x.stamps).filter(Boolean) || []
    setStamps(earned)

    // all stamps for collection view
    const { data: allS } = await supabase.from('stamps').select('emoji, name')
    if (allS) {
      const earnedNames = new Set(earned.map((s: any) => s.name))
      setAllStamps(allS.map(s => ({ ...s, earned: earnedNames.has(s.name) })))
    }

    // letter counts
    const { count: sent } = await supabase.from('letters').select('*', { count: 'exact', head: true }).eq('sender_id', authUser.id).eq('is_memory_box', false)
    const { count: received } = await supabase.from('letters').select('*', { count: 'exact', head: true }).eq('recipient_id', authUser.id)
    setSentCount(sent || 0)
    setReceivedCount(received || 0)

    // streaks
    const { data: streakData } = await supabase
      .from('streaks')
      .select('*, user_b:users!streaks_user_b_id_fkey(display_name, country)')
      .eq('user_a_id', authUser.id)
      .order('count', { ascending: false })
      .limit(5)

    if (streakData) {
      setStreaks(streakData.map((s: any) => ({
        name: s.user_b?.display_name || 'unknown',
        country: s.user_b?.country || '',
        count: s.count,
      })))
    }

    setLoading(false)
  }

  async function handleLogout() {
    await supabase.auth.signOut()
    router.push('/')
  }

  if (loading || !user) {
    return (
      <>
        <Stars />
        <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '100vh', color: 'var(--tx3)', fontSize: 14 }}>
          loading profile...
        </div>
      </>
    )
  }

  const levelInfo = getLevelInfo(user.xp)
  const nextLevelName = levelInfo.level < 10 ? getLevelInfo(levelInfo.xpNext).name : 'max'

  return (
    <>
      <Stars />
      <nav className="topnav">
        <span className="nav-brand">forget-me-not<span>_ letters that last</span></span>
        <div className="nav-search"><input placeholder="search..." /></div>
        <div className="nav-right">
          {['inbox', 'explore', 'bottle', 'memory', 'blog', 'profile'].map((item) => (
            <a key={item} href={item === 'inbox' ? '/dashboard' : `/${item}`} className={`nav-link ${item === 'profile' ? 'active' : ''}`}>{item}</a>
          ))}
          <ThemeToggle />
        </div>
      </nav>

      <div style={{ maxWidth: 640, margin: '0 auto', padding: '80px 24px 60px', position: 'relative', zIndex: 1 }}>
        <div style={{ display: 'flex', gap: 20, alignItems: 'center', marginBottom: 20 }}>
          <PixelAvatar seed={user.display_name || 'user'} size={72} />
          <div>
            <h2 style={{ fontSize: 22, fontWeight: 700, color: 'var(--lilac)' }}>@{user.display_name}<span className="cursor"></span></h2>
            <div style={{ fontSize: 12, color: 'var(--tx4)' }}>
              {user.country}{user.mbti ? ` · ${user.mbti}` : ''}{user.zodiac ? ` · ${user.zodiac}` : ''}
            </div>
          </div>
        </div>

        {user.bio && <p style={{ fontSize: 14, color: 'var(--tx2)', lineHeight: 1.8, marginBottom: 16 }}>{user.bio}</p>}

        {user.current_book && (
          <div style={{ fontSize: 13, color: 'var(--tx3)', marginBottom: 6 }}>
            <span style={{ color: 'var(--lilac)' }}>reading:</span> {user.current_book}
          </div>
        )}
        {user.last_song && (
          <div style={{ fontSize: 13, color: 'var(--tx3)', marginBottom: 6 }}>
            <span style={{ color: 'var(--pink)' }}>listening:</span> {user.last_song}
          </div>
        )}
        {user.life_motto && (
          <div style={{ fontSize: 13, color: 'var(--tx3)', marginBottom: 20 }}>
            <span style={{ color: 'var(--gold)' }}>motto:</span> {user.life_motto}
          </div>
        )}

        {interests.length > 0 && (
          <div style={{ display: 'flex', gap: 6, flexWrap: 'wrap', marginBottom: 28 }}>
            {interests.map(i => <span key={i} className="tag">{i}</span>)}
          </div>
        )}

        <hr className="divider" />

        <div className="form-label">letter stats</div>
        <div style={{ display: 'flex', gap: 32, marginBottom: 28 }}>
          <div>
            <div style={{ fontSize: 11, color: 'var(--tx4)', textTransform: 'uppercase', letterSpacing: '0.08em', marginBottom: 4 }}>sent</div>
            <div style={{ fontSize: 16, color: 'var(--txt)', fontWeight: 700 }}>{sentCount}</div>
          </div>
          <div>
            <div style={{ fontSize: 11, color: 'var(--tx4)', textTransform: 'uppercase', letterSpacing: '0.08em', marginBottom: 4 }}>received</div>
            <div style={{ fontSize: 16, color: 'var(--txt)', fontWeight: 700 }}>{receivedCount}</div>
          </div>
          <div>
            <div style={{ fontSize: 11, color: 'var(--tx4)', textTransform: 'uppercase', letterSpacing: '0.08em', marginBottom: 4 }}>total</div>
            <div style={{ fontSize: 16, color: 'var(--txt)', fontWeight: 700 }}>{sentCount + receivedCount}</div>
          </div>
        </div>

        <hr className="divider" />

        <div className="form-label">level & xp</div>
        <div style={{ fontSize: 14, color: 'var(--lilac)', marginBottom: 8 }}>
          {levelInfo.name} — level {levelInfo.level}
        </div>
        <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 12, color: 'var(--tx3)', marginBottom: 6 }}>
          <span>{levelInfo.xp} / {levelInfo.xpNext} xp</span>
          <span>next: {nextLevelName}</span>
        </div>
        <div className="xp-bar" style={{ marginBottom: 28 }}>
          <div className="xp-fill" style={{ width: `${(levelInfo.xp / levelInfo.xpNext) * 100}%` }} />
        </div>

        <hr className="divider" />

        <div className="form-label">stamp collection</div>
        <div style={{ display: 'flex', gap: 10, flexWrap: 'wrap', marginBottom: 28 }}>
          {allStamps.map(s => (
            <div key={s.name} className="avatar" style={{ width: 48, height: 48, fontSize: 22, opacity: s.earned ? 1 : 0.3 }} title={s.name}>
              {s.emoji}
            </div>
          ))}
        </div>

        {streaks.length > 0 && (
          <>
            <hr className="divider" />
            <div className="form-label">pen pal streaks</div>
            {streaks.map(p => (
              <div key={p.name} className="sb-item" style={{ marginBottom: 4 }}>
                <PixelAvatar seed={p.name} size={36} />
                <div style={{ flex: 1 }}>
                  <div style={{ fontSize: 13, color: 'var(--txt)' }}>@{p.name}</div>
                  <div style={{ fontSize: 11, color: 'var(--tx4)' }}>{p.country}</div>
                </div>
                <span style={{ fontSize: 13, color: 'var(--gold)' }}>{p.count}d</span>
              </div>
            ))}
          </>
        )}

        <hr className="divider" />
        <button className="btn-ghost" onClick={handleLogout} style={{ color: 'var(--pink)', marginTop: 8 }}>sign out</button>
      </div>
    </>
  )
}
