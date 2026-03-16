'use client'

export const dynamic = 'force-dynamic'

import { useState, useEffect } from 'react'
import { useRouter } from 'next/navigation'
import { Stars } from '@/components/Stars'
import { ThemeToggle } from '@/components/ThemeToggle'
import { supabase } from '@/lib/supabase'
import { getLevelInfo, timeLeft, journeyProgress } from '@/lib/utils'
import type { User, Letter } from '@/types'

type LetterWithSender = Letter & { sender: Pick<User, 'display_name' | 'avatar_id' | 'country'> | null }
type LetterWithRecipient = Letter & { recipient: Pick<User, 'display_name' | 'avatar_id' | 'country'> | null }

const statusMap = {
  IN_TRANSIT: { label: 'in transit', cls: 'status-transit' },
  DELIVERED: { label: 'delivered', cls: 'status-delivered' },
  READ: { label: 'read', cls: 'status-read' },
  DRAFT: { label: 'draft', cls: 'status-transit' },
  EXPIRED: { label: 'expired', cls: 'status-read' },
  MEMORY_BOX: { label: 'memory', cls: 'status-read' },
}

export default function DashboardPage() {
  const router = useRouter()
  const [tab, setTab] = useState<'inbox' | 'sent' | 'archive'>('inbox')
  const [user, setUser] = useState<User | null>(null)
  const [avatar, setAvatar] = useState<string>('🦢')
  const [interests, setInterests] = useState<string[]>([])
  const [inboxLetters, setInboxLetters] = useState<LetterWithSender[]>([])
  const [sentLetters, setSentLetters] = useState<LetterWithRecipient[]>([])
  const [siteStats, setSiteStats] = useState({ members: 0, totalLetters: 0 })
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    loadData()
  }, [])

  async function loadData() {
    const { data: { user: authUser } } = await supabase.auth.getUser()
    if (!authUser) { router.push('/login'); return }

    // fetch user profile
    const { data: profile } = await supabase
      .from('users')
      .select('*')
      .eq('id', authUser.id)
      .single()

    if (!profile) { router.push('/onboarding'); return }
    if (!profile.onboarding_complete) { router.push('/onboarding'); return }

    setUser(profile)

    // fetch avatar emoji
    if (profile.avatar_id) {
      const { data: av } = await supabase.from('avatars').select('emoji').eq('id', profile.avatar_id).single()
      if (av) setAvatar(av.emoji)
    }

    // fetch interests
    const { data: userInterests } = await supabase
      .from('user_interests')
      .select('interest_id, interests(name)')
      .eq('user_id', authUser.id)

    if (userInterests) {
      setInterests(userInterests.map((ui: any) => ui.interests?.name).filter(Boolean))
    }

    // fetch inbox letters (received)
    const { data: inbox } = await supabase
      .from('letters')
      .select('*, sender:users!letters_sender_id_fkey(display_name, avatar_id, country)')
      .eq('recipient_id', authUser.id)
      .eq('is_memory_box', false)
      .in('status', ['IN_TRANSIT', 'DELIVERED', 'READ'])
      .order('sent_at', { ascending: false })

    if (inbox) {
      // update IN_TRANSIT letters that have arrived
      for (const letter of inbox) {
        if (letter.status === 'IN_TRANSIT' && letter.delivers_at && new Date(letter.delivers_at) <= new Date()) {
          await supabase.from('letters').update({ status: 'DELIVERED' }).eq('id', letter.id)
          letter.status = 'DELIVERED'
        }
      }
      // fetch sender avatars
      for (const letter of inbox) {
        if (letter.sender?.avatar_id) {
          const { data: av } = await supabase.from('avatars').select('emoji').eq('id', letter.sender.avatar_id).single()
          if (av) (letter as any).senderAvatar = av.emoji
        }
      }
      setInboxLetters(inbox)
    }

    // fetch sent letters
    const { data: sent } = await supabase
      .from('letters')
      .select('*, recipient:users!letters_recipient_id_fkey(display_name, avatar_id, country)')
      .eq('sender_id', authUser.id)
      .eq('is_memory_box', false)
      .order('sent_at', { ascending: false })

    if (sent) {
      for (const letter of sent) {
        if (letter.recipient?.avatar_id) {
          const { data: av } = await supabase.from('avatars').select('emoji').eq('id', letter.recipient.avatar_id).single()
          if (av) (letter as any).recipientAvatar = av.emoji
        }
      }
      setSentLetters(sent)
    }

    // site stats
    const { count: memberCount } = await supabase
      .from('users')
      .select('*', { count: 'exact', head: true })
      .eq('onboarding_complete', true)
    const { count: letterCount } = await supabase
      .from('letters')
      .select('*', { count: 'exact', head: true })
      .eq('is_memory_box', false)
    setSiteStats({ members: memberCount || 0, totalLetters: letterCount || 0 })

    setLoading(false)
  }

  if (loading || !user) {
    return (
      <>
        <Stars />
        <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '100vh', color: 'var(--tx3)', fontSize: 14 }}>
          loading your letters...
        </div>
      </>
    )
  }

  const levelInfo = getLevelInfo(user.xp)

  const letters = tab === 'inbox' ? inboxLetters : tab === 'sent' ? sentLetters : []

  return (
    <>
      <Stars />
      <nav className="topnav">
        <span className="nav-brand">forget-me-not<span>_ letters that last</span></span>
        <div className="nav-search"><input placeholder="search..." /></div>
        <div className="nav-right">
          {['inbox', 'explore', 'bottle', 'memory', 'blog', 'profile'].map((item, i) => (
            <a key={item} href={item === 'inbox' ? '/dashboard' : `/${item}`} className={`nav-link ${i === 0 ? 'active' : ''}`}>{item}</a>
          ))}
          <ThemeToggle />
        </div>
      </nav>

      <div className="layout">
        <aside className="sidebar">
          <div style={{ display: 'flex', gap: 12, alignItems: 'center', marginBottom: 16 }}>
            <div className="avatar">{avatar}</div>
            <div>
              <div style={{ fontSize: 13, fontWeight: 700, color: 'var(--txt)' }}>@{user.display_name}</div>
              <div style={{ fontSize: 10, color: 'var(--tx4)' }}>{user.country}</div>
            </div>
          </div>

          {user.bio && <p style={{ fontSize: 11, color: 'var(--tx3)', marginBottom: 12, lineHeight: 1.6 }}>{user.bio}</p>}

          {interests.length > 0 && (
            <div style={{ display: 'flex', gap: 4, flexWrap: 'wrap', marginBottom: 16 }}>
              {interests.map(i => <span key={i} className="tag">{i}</span>)}
            </div>
          )}

          <hr className="divider" />

          <div style={{ marginBottom: 16 }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 10, color: 'var(--tx3)', marginBottom: 4 }}>
              <span>lvl {levelInfo.level} — {levelInfo.name}</span>
              <span>{levelInfo.xp}/{levelInfo.xpNext} xp</span>
            </div>
            <div className="xp-bar"><div className="xp-fill" style={{ width: `${(levelInfo.xp / levelInfo.xpNext) * 100}%` }} /></div>
          </div>

          {user.last_song && (
            <div className="card" style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
              <div className="music-wave"><span /><span /><span /><span /><span /></div>
              <div>
                <div style={{ fontSize: 11, color: 'var(--txt)' }}>{user.last_song}</div>
              </div>
            </div>
          )}

          <hr className="divider" />

          {user.current_book && (
            <div style={{ marginBottom: 12 }}>
              <div style={{ fontSize: 9, color: 'var(--tx4)', textTransform: 'uppercase', letterSpacing: '0.08em', marginBottom: 2 }}>reading</div>
              <div style={{ fontSize: 11, color: 'var(--tx3)' }}>{user.current_book}</div>
            </div>
          )}
          {user.life_motto && (
            <div style={{ marginBottom: 16 }}>
              <div style={{ fontSize: 9, color: 'var(--tx4)', textTransform: 'uppercase', letterSpacing: '0.08em', marginBottom: 2 }}>motto</div>
              <div style={{ fontSize: 11, color: 'var(--tx3)' }}>{user.life_motto}</div>
            </div>
          )}

          <hr className="divider" />
          <div className="sb-title">community</div>
          <div style={{ display: 'flex', gap: 20, marginBottom: 8 }}>
            <div>
              <div style={{ fontSize: 14, fontWeight: 700, color: 'var(--lilac)' }}>{siteStats.members}</div>
              <div style={{ fontSize: 9, color: 'var(--tx4)', textTransform: 'uppercase', letterSpacing: '0.08em' }}>members</div>
            </div>
            <div>
              <div style={{ fontSize: 14, fontWeight: 700, color: 'var(--gold)' }}>{siteStats.totalLetters}</div>
              <div style={{ fontSize: 9, color: 'var(--tx4)', textTransform: 'uppercase', letterSpacing: '0.08em' }}>letters</div>
            </div>
          </div>
        </aside>

        <div className="ev-main">
          <h2 style={{ fontSize: 18, fontWeight: 700, color: 'var(--lilac)', marginBottom: 2 }}>
            your letters<span className="cursor"></span>
          </h2>
          <p className="prompt" style={{ fontSize: 11, marginBottom: 20 }}>patience is the point.</p>

          <div style={{ display: 'flex', gap: 4, marginBottom: 20, borderBottom: '1px solid var(--brd)' }}>
            {(['inbox', 'sent', 'archive'] as const).map(t => (
              <button key={t} onClick={() => setTab(t)} className="nav-link" style={{
                borderBottom: tab === t ? '2px solid var(--lilac)' : '2px solid transparent',
                borderRadius: 0, color: tab === t ? 'var(--lilac)' : undefined,
              }}>
                {t}
              </button>
            ))}
          </div>

          {letters.length === 0 && (
            <div style={{ textAlign: 'center', padding: '40px 0', color: 'var(--tx4)', fontSize: 13 }}>
              {tab === 'inbox' ? 'no letters yet — explore and start writing!' : 'no sent letters yet.'}
            </div>
          )}

          {tab === 'inbox' && inboxLetters.map(letter => {
            const st = statusMap[letter.status] || statusMap.DELIVERED
            const senderName = letter.sender?.display_name || 'unknown'
            const senderAv = (letter as any).senderAvatar || '✦'
            const progress = letter.sent_at && letter.delivers_at ? journeyProgress(letter.sent_at, letter.delivers_at) : 100
            const time = letter.delivers_at && letter.status === 'IN_TRANSIT' ? timeLeft(letter.delivers_at) : letter.sent_at ? new Date(letter.sent_at).toLocaleDateString() : ''
            const route = `${letter.sender?.country || '?'} → ${user.country || '?'}`

            return (
              <a key={letter.id} href={`/letter/${letter.id}`} style={{ textDecoration: 'none' }}>
                <div className="letter-card">
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 8 }}>
                    <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                      <div className="avatar" style={{ width: 24, height: 24, fontSize: 12 }}>{senderAv}</div>
                      <span style={{ fontSize: 12, color: 'var(--lilac)' }}>@{senderName}</span>
                      <span className={`letter-status ${st.cls}`}>{st.label}</span>
                    </div>
                    <span style={{ fontSize: 10, color: 'var(--tx4)' }}>{time}</span>
                  </div>

                  <p style={{ fontSize: 12, color: 'var(--tx2)', lineHeight: 1.6, marginBottom: 6, overflow: 'hidden', display: '-webkit-box', WebkitLineClamp: 2, WebkitBoxOrient: 'vertical' }}>
                    {letter.content.substring(0, 150)}...
                  </p>

                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', fontSize: 10, color: 'var(--tx4)' }}>
                    <span>{route}</span>
                    {letter.distance_km && <span>{Math.round(letter.distance_km).toLocaleString()} km</span>}
                  </div>

                  {letter.status === 'IN_TRANSIT' && (
                    <div className="journey">
                      <div className="journey-fill" style={{ width: `${progress}%` }}>
                        <span className="journey-dot" />
                      </div>
                    </div>
                  )}
                </div>
              </a>
            )
          })}

          {tab === 'sent' && sentLetters.map(letter => {
            const st = statusMap[letter.status] || statusMap.IN_TRANSIT
            const recipientName = letter.recipient?.display_name || 'unknown'
            const recipientAv = (letter as any).recipientAvatar || '✦'
            const time = letter.delivers_at && letter.status === 'IN_TRANSIT' ? timeLeft(letter.delivers_at) : letter.sent_at ? new Date(letter.sent_at).toLocaleDateString() : ''

            return (
              <div key={letter.id} className="letter-card">
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 8 }}>
                  <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                    <div className="avatar" style={{ width: 24, height: 24, fontSize: 12 }}>{recipientAv}</div>
                    <span style={{ fontSize: 12, color: 'var(--lilac)' }}>to @{recipientName}</span>
                    <span className={`letter-status ${st.cls}`}>{st.label}</span>
                  </div>
                  <span style={{ fontSize: 10, color: 'var(--tx4)' }}>{time}</span>
                </div>
                <p style={{ fontSize: 12, color: 'var(--tx2)', lineHeight: 1.6, overflow: 'hidden', display: '-webkit-box', WebkitLineClamp: 2, WebkitBoxOrient: 'vertical' }}>
                  {letter.content.substring(0, 150)}...
                </p>
              </div>
            )
          })}

          <div style={{ textAlign: 'center', marginTop: 24 }}>
            <a href="/compose" className="btn">compose a letter</a>
          </div>
        </div>
      </div>
    </>
  )
}
