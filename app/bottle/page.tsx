'use client'

export const dynamic = 'force-dynamic'

import { useState, useEffect } from 'react'
import { useRouter } from 'next/navigation'
import { Stars } from '@/components/Stars'
import { ThemeToggle } from '@/components/ThemeToggle'
import { supabase } from '@/lib/supabase'
import { formatDate, timeLeft } from '@/lib/utils'
import type { Letter } from '@/types'

export default function BottlePage() {
  const router = useRouter()
  const [sentBottles, setSentBottles] = useState<Letter[]>([])
  const [foundBottles, setFoundBottles] = useState<(Letter & { senderName?: string })[]>([])
  const [loading, setLoading] = useState(true)
  const [finding, setFinding] = useState(false)
  const [currentUserId, setCurrentUserId] = useState('')

  useEffect(() => { loadBottles() }, [])

  async function loadBottles() {
    const { data: { user: authUser } } = await supabase.auth.getUser()
    if (!authUser) { router.push('/login'); return }
    setCurrentUserId(authUser.id)

    // bottles I sent
    const { data: sent } = await supabase
      .from('letters')
      .select('*')
      .eq('sender_id', authUser.id)
      .eq('is_bottle', true)
      .order('sent_at', { ascending: false })

    if (sent) setSentBottles(sent)

    // bottles I received
    const { data: received } = await supabase
      .from('letters')
      .select('*, sender:users!letters_sender_id_fkey(display_name)')
      .eq('recipient_id', authUser.id)
      .eq('is_bottle', true)
      .order('sent_at', { ascending: false })

    if (received) {
      setFoundBottles(received.map((b: any) => ({
        ...b,
        senderName: b.sender?.display_name || 'a stranger',
      })))
    }

    setLoading(false)
  }

  async function findBottle() {
    setFinding(true)
    // check for unread bottle letters
    const { data } = await supabase
      .from('letters')
      .select('*, sender:users!letters_sender_id_fkey(display_name)')
      .eq('recipient_id', currentUserId)
      .eq('is_bottle', true)
      .eq('status', 'DELIVERED')
      .limit(1)

    if (data && data.length > 0) {
      // mark as read
      await supabase.from('letters').update({ status: 'READ', read_at: new Date().toISOString() }).eq('id', data[0].id)
      router.push(`/letter/${data[0].id}`)
    } else {
      alert('no bottles in the ocean right now — check back later.')
    }
    setFinding(false)
  }

  if (loading) {
    return (
      <>
        <Stars />
        <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '100vh', color: 'var(--tx3)', fontSize: 14 }}>
          searching the ocean...
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
            <a key={item} href={item === 'inbox' ? '/dashboard' : `/${item}`} className={`nav-link ${item === 'bottle' ? 'active' : ''}`}>{item}</a>
          ))}
          <ThemeToggle />
        </div>
      </nav>

      <div style={{ maxWidth: 640, margin: '0 auto', padding: '80px 24px 60px', position: 'relative', zIndex: 1 }}>
        <div style={{ textAlign: 'center', marginBottom: 40 }}>
          <div style={{ fontSize: 48, marginBottom: 12 }}>🐚</div>
          <h2 style={{ fontSize: 22, fontWeight: 700, color: 'var(--lilac)', marginBottom: 4 }}>
            bottle mail<span className="cursor"></span>
          </h2>
          <p className="prompt" style={{ fontSize: 13 }}>throw a letter into the ocean. someone, somewhere, will find it.</p>
        </div>

        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 16, marginBottom: 40 }}>
          <a href="/compose?bottle=true" className="card" style={{ textAlign: 'center', textDecoration: 'none', padding: 28 }}>
            <div style={{ fontSize: 28, marginBottom: 8 }}>✉</div>
            <div style={{ fontSize: 14, fontWeight: 700, color: 'var(--lilac)', marginBottom: 4 }}>throw a bottle</div>
            <div style={{ fontSize: 12, color: 'var(--tx3)' }}>write a letter to a stranger</div>
          </a>
          <button className="card" onClick={findBottle} disabled={finding} style={{ textAlign: 'center', cursor: 'pointer', padding: 28 }}>
            <div style={{ fontSize: 28, marginBottom: 8 }}>🌊</div>
            <div style={{ fontSize: 14, fontWeight: 700, color: 'var(--lilac)', marginBottom: 4 }}>
              {finding ? 'searching...' : 'find a bottle'}
            </div>
            <div style={{ fontSize: 12, color: 'var(--tx3)' }}>discover a letter from the ocean</div>
          </button>
        </div>

        {sentBottles.length > 0 && (
          <>
            <div className="form-label" style={{ marginBottom: 16 }}>your bottles</div>
            {sentBottles.map(b => {
              const isDelivered = b.status === 'DELIVERED' || b.status === 'READ'
              return (
                <div key={b.id} className="letter-card">
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 8 }}>
                    <span className={`letter-status ${isDelivered ? 'status-delivered' : 'status-transit'}`}>
                      {isDelivered ? '✦ found' : '🕊 traveling'}
                    </span>
                    <span style={{ fontSize: 11, color: 'var(--tx4)' }}>{b.sent_at ? formatDate(b.sent_at) : ''}</span>
                  </div>
                  <p style={{ fontSize: 13, color: 'var(--tx2)', lineHeight: 1.7, marginBottom: 6 }}>
                    {b.content.substring(0, 120)}...
                  </p>
                  {b.status === 'IN_TRANSIT' && b.delivers_at && (
                    <div style={{ fontSize: 11, color: 'var(--tx4)' }}>{timeLeft(b.delivers_at)}</div>
                  )}
                </div>
              )
            })}
          </>
        )}

        {foundBottles.length > 0 && (
          <>
            <div className="form-label" style={{ marginBottom: 16, marginTop: 24 }}>found bottles</div>
            {foundBottles.map(b => (
              <a key={b.id} href={`/letter/${b.id}`} style={{ textDecoration: 'none' }}>
                <div className="letter-card">
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 8 }}>
                    <span className="letter-status status-delivered">🐚 from {b.senderName}</span>
                    <span style={{ fontSize: 11, color: 'var(--tx4)' }}>{b.sent_at ? formatDate(b.sent_at) : ''}</span>
                  </div>
                  <p style={{ fontSize: 13, color: 'var(--tx2)', lineHeight: 1.7 }}>
                    {b.content.substring(0, 120)}...
                  </p>
                </div>
              </a>
            ))}
          </>
        )}

        {sentBottles.length === 0 && foundBottles.length === 0 && (
          <div style={{ textAlign: 'center', padding: '20px 0', color: 'var(--tx4)', fontSize: 13 }}>
            no bottles yet — throw one into the ocean or wait for one to find you.
          </div>
        )}
      </div>
    </>
  )
}
