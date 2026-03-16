'use client'

import { useState, useEffect } from 'react'
import { useRouter, useParams } from 'next/navigation'
import { Stars } from '@/components/Stars'
import { ThemeToggle } from '@/components/ThemeToggle'
import { supabase } from '@/lib/supabase'
import type { Letter, User } from '@/types'

export default function LetterViewPage() {
  const router = useRouter()
  const params = useParams()
  const letterId = params.id as string

  const [letter, setLetter] = useState<Letter | null>(null)
  const [sender, setSender] = useState<User | null>(null)
  const [senderAvatar, setSenderAvatar] = useState('✦')
  const [stamp, setStamp] = useState<string>('')
  const [loading, setLoading] = useState(true)

  useEffect(() => { loadLetter() }, [letterId])

  async function loadLetter() {
    const { data: { user: authUser } } = await supabase.auth.getUser()
    if (!authUser) { router.push('/login'); return }

    const { data: letterData } = await supabase
      .from('letters')
      .select('*')
      .eq('id', letterId)
      .single()

    if (!letterData) {
      router.push('/dashboard')
      return
    }

    setLetter(letterData)

    // mark as read if delivered
    if (letterData.status === 'DELIVERED' && letterData.recipient_id === authUser.id) {
      await supabase.from('letters').update({ status: 'READ', read_at: new Date().toISOString() }).eq('id', letterId)
      // award XP to recipient
      const { data: recipient } = await supabase.from('users').select('xp').eq('id', authUser.id).single()
      if (recipient) {
        await supabase.from('users').update({ xp: recipient.xp + 15 }).eq('id', authUser.id)
      }
    }

    // load sender
    if (letterData.sender_id) {
      const { data: senderData } = await supabase.from('users').select('*').eq('id', letterData.sender_id).single()
      if (senderData) {
        setSender(senderData)
        if (senderData.avatar_id) {
          const { data: av } = await supabase.from('avatars').select('emoji').eq('id', senderData.avatar_id).single()
          if (av) setSenderAvatar(av.emoji)
        }
      }
    }

    // load stamp
    if (letterData.stamp_id) {
      const { data: stampData } = await supabase.from('stamps').select('emoji').eq('id', letterData.stamp_id).single()
      if (stampData) setStamp(stampData.emoji)
    }

    setLoading(false)
  }

  if (loading || !letter) {
    return (
      <>
        <Stars />
        <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '100vh', color: 'var(--tx3)', fontSize: 14 }}>
          opening letter...
        </div>
      </>
    )
  }

  const route = `${sender?.country || '?'} → ?`

  return (
    <>
      <Stars />
      <nav className="topnav">
        <span className="nav-brand">forget-me-not<span>_ letters that last</span></span>
        <div className="nav-right">
          <a href="/dashboard" className="nav-link">inbox</a>
          <ThemeToggle />
        </div>
      </nav>

      <div style={{ maxWidth: 640, margin: '0 auto', padding: '80px 24px 60px', position: 'relative', zIndex: 1 }}>
        <a href="/dashboard" style={{ fontSize: 12, color: 'var(--tx3)', marginBottom: 24, display: 'block' }}>&larr; back to inbox</a>

        <div className="card" style={{ borderTop: '3px solid var(--pink)', padding: 28 }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 20 }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
              <div className="avatar" style={{ width: 44, height: 44, fontSize: 20 }}>{senderAvatar}</div>
              <div>
                <div style={{ fontSize: 14, color: 'var(--lilac)', fontWeight: 700 }}>@{sender?.display_name || 'unknown'}</div>
                <div style={{ fontSize: 12, color: 'var(--tx4)' }}>{sender?.country || ''}</div>
              </div>
            </div>
            <div style={{ textAlign: 'right' }}>
              {stamp && <div style={{ fontSize: 22 }}>{stamp}</div>}
              <div style={{ fontSize: 11, color: 'var(--tx4)' }}>
                {letter.read_at ? new Date(letter.read_at).toLocaleDateString() : letter.sent_at ? new Date(letter.sent_at).toLocaleDateString() : ''}
              </div>
            </div>
          </div>

          <div style={{
            fontSize: 14, color: 'var(--tx2)', lineHeight: 2,
            whiteSpace: 'pre-line', marginBottom: 24,
          }}>
            {letter.content}
          </div>

          {letter.song_url && (
            <div className="card" style={{ display: 'flex', alignItems: 'center', gap: 12, marginBottom: 0 }}>
              <div className="music-wave"><span /><span /><span /><span /><span /></div>
              <div>
                <div style={{ fontSize: 13, color: 'var(--txt)' }}>{letter.song_url}</div>
              </div>
            </div>
          )}
        </div>

        <div style={{ display: 'flex', gap: 12, marginTop: 20 }}>
          <a href={`/compose?to=${letter.sender_id}`} className="btn" style={{ flex: 1, textAlign: 'center' }}>write back</a>
          <button className="btn-ghost">save</button>
        </div>

        <div style={{ fontSize: 11, color: 'var(--tx4)', textAlign: 'center', marginTop: 16 }}>
          {route} · {letter.distance_km ? `${Math.round(letter.distance_km).toLocaleString()} km` : ''}
        </div>
      </div>
    </>
  )
}
