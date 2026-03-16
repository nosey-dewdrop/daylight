'use client'

export const dynamic = 'force-dynamic'

import { useState, useEffect } from 'react'
import { useRouter } from 'next/navigation'
import { Stars } from '@/components/Stars'
import { ThemeToggle } from '@/components/ThemeToggle'
import { supabase } from '@/lib/supabase'
import { formatDate } from '@/lib/utils'
import type { Letter } from '@/types'

export default function MemoryPage() {
  const router = useRouter()
  const [filter, setFilter] = useState('all')
  const [memories, setMemories] = useState<Letter[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => { loadMemories() }, [])

  async function loadMemories() {
    const { data: { user: authUser } } = await supabase.auth.getUser()
    if (!authUser) { router.push('/login'); return }

    const { data } = await supabase
      .from('letters')
      .select('*')
      .eq('sender_id', authUser.id)
      .eq('is_memory_box', true)
      .order('sent_at', { ascending: false })

    if (data) setMemories(data)
    setLoading(false)
  }

  async function unsealAndSend(letter: Letter) {
    // convert to a real letter - redirect to compose with content
    router.push(`/compose?memory=${letter.id}`)
  }

  const filtered = memories.filter(m => {
    if (filter === 'all') return true
    if (filter === 'to myself') return !m.memory_box_recipient || m.memory_box_recipient.toLowerCase().includes('self') || m.memory_box_recipient.toLowerCase().includes('me')
    if (filter === 'unsent') return !m.time_capsule_date
    if (filter === 'time capsules') return !!m.time_capsule_date
    return true
  })

  const FILTERS = ['all', 'to myself', 'unsent', 'time capsules']

  if (loading) {
    return (
      <>
        <Stars />
        <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '100vh', color: 'var(--tx3)', fontSize: 14 }}>
          opening memory box...
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
            <a key={item} href={item === 'inbox' ? '/dashboard' : `/${item}`} className={`nav-link ${item === 'memory' ? 'active' : ''}`}>{item}</a>
          ))}
          <ThemeToggle />
        </div>
      </nav>

      <div style={{ maxWidth: 640, margin: '0 auto', padding: '80px 24px 60px', position: 'relative', zIndex: 1 }}>
        <h2 style={{ fontSize: 22, fontWeight: 700, color: 'var(--lilac)', marginBottom: 4 }}>
          memory box<span className="cursor"></span>
        </h2>
        <p className="prompt" style={{ fontSize: 13, marginBottom: 24 }}>letters written, never meaning to send.</p>

        <div style={{ display: 'flex', gap: 6, flexWrap: 'wrap', marginBottom: 24 }}>
          {FILTERS.map(f => (
            <button key={f} className="tag" onClick={() => setFilter(f)}
              style={{ cursor: 'pointer', borderColor: filter === f ? 'var(--lilac)' : undefined, color: filter === f ? 'var(--lilac)' : undefined }}>
              {f}
            </button>
          ))}
        </div>

        <a href="/compose" className="btn" style={{ marginBottom: 32, display: 'inline-block' }}>write to memory box</a>

        {filtered.length === 0 && (
          <div style={{ textAlign: 'center', padding: '40px 0', color: 'var(--tx4)', fontSize: 13 }}>
            no memories yet — write a letter to yourself or someone you can&apos;t send it to.
          </div>
        )}

        {filtered.map(m => {
          const isLocked = m.time_capsule_date && new Date(m.time_capsule_date) > new Date()

          return (
            <div key={m.id} className="letter-card">
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 8 }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                  <span style={{ fontSize: 22 }}>✦</span>
                  <div>
                    <div style={{ fontSize: 11, color: 'var(--tx4)', textTransform: 'uppercase', letterSpacing: '0.08em' }}>to:</div>
                    <div style={{ fontSize: 14, color: 'var(--txt)' }}>{m.memory_box_recipient || 'myself'}</div>
                  </div>
                </div>
                <span style={{ fontSize: 11, color: 'var(--tx4)' }}>{m.sent_at ? formatDate(m.sent_at) : ''}</span>
              </div>
              <p style={{ fontSize: 13, color: 'var(--tx2)', lineHeight: 1.7, marginBottom: 10 }}>
                {m.content.substring(0, 200)}{m.content.length > 200 ? '...' : ''}
              </p>
              {isLocked && (
                <span style={{ fontSize: 11, color: 'var(--gold)' }}>
                  opens {formatDate(m.time_capsule_date!)}
                </span>
              )}
              {!isLocked && (
                <button className="btn btn-sm" style={{ marginTop: 10 }} onClick={() => unsealAndSend(m)}>
                  unseal & send
                </button>
              )}
            </div>
          )
        })}
      </div>
    </>
  )
}
