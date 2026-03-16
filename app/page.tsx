'use client'

import { useState, useEffect } from 'react'
import { Stars } from '@/components/Stars'
import { ThemeToggle } from '@/components/ThemeToggle'
import { supabase } from '@/lib/supabase'

export default function Home() {
  const [stats, setStats] = useState({ members: 0, sent: 0, received: 0 })

  useEffect(() => {
    async function loadStats() {
      const { count: members } = await supabase
        .from('users')
        .select('*', { count: 'exact', head: true })
        .eq('onboarding_complete', true)
      const { count: sent } = await supabase
        .from('letters')
        .select('*', { count: 'exact', head: true })
        .eq('is_memory_box', false)
      setStats({
        members: members || 0,
        sent: sent || 0,
        received: sent || 0,
      })
    }
    loadStats()
  }, [])

  return (
    <>
      <Stars />
      <div style={{ position: 'fixed', top: 16, right: 16, zIndex: 10, display: 'flex', alignItems: 'center', gap: 16 }}>
        <span style={{ fontSize: 11, color: 'var(--tx4)', letterSpacing: '0.05em' }}>
          {stats.members} members · {stats.sent} letters
        </span>
        <ThemeToggle />
      </div>
      <section className="hero">
        <h1 className="hero-title ar ar1">forget-me-not<span className="cursor"></span></h1>
        <p className="hero-sub ar ar2">letters that last.</p>
        <p className="hero-desc ar ar3">
          write a letter. watch it travel across the world.<br />
          wait. real connection takes time.
        </p>

        <div className="ar ar4" style={{ display: 'flex', gap: 16, marginBottom: 48 }}>
          <a href="/register" className="btn">start writing</a>
          <a href="/login" className="btn-ghost">sign in</a>
        </div>

        <div className="ar ar5" style={{ display: 'flex', gap: 64, justifyContent: 'center' }}>
          <div style={{ textAlign: 'center', maxWidth: 160 }}>
            <div style={{ fontSize: 20, color: 'var(--lilac)', marginBottom: 8 }}>∞</div>
            <div className="prompt" style={{ fontSize: 12 }}>distance-based delivery</div>
          </div>
          <div style={{ textAlign: 'center', maxWidth: 160 }}>
            <div style={{ fontSize: 20, color: 'var(--pink)', marginBottom: 8 }}>~</div>
            <div className="prompt" style={{ fontSize: 12 }}>bottle mail to strangers</div>
          </div>
          <div style={{ textAlign: 'center', maxWidth: 160 }}>
            <div style={{ fontSize: 20, color: 'var(--gold)', marginBottom: 8 }}>□</div>
            <div className="prompt" style={{ fontSize: 12 }}>letters never meant to send</div>
          </div>
        </div>

        <p className="ar ar5" style={{ marginTop: 64, fontSize: 12, color: 'var(--tx4)' }}>
          for the dreamers, the overthinkers, the ones who still<br />
          believe slow things are the most beautiful things.
        </p>
      </section>
    </>
  )
}
