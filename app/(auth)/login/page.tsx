'use client'

export const dynamic = 'force-dynamic'

import { useState } from 'react'
import { useRouter } from 'next/navigation'
import { Stars } from '@/components/Stars'
import { ThemeToggle } from '@/components/ThemeToggle'
import { supabase } from '@/lib/supabase'

export default function LoginPage() {
  const router = useRouter()
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)

  async function handleLogin() {
    setError('')
    if (!email.trim() || !password.trim()) { setError('fill in all fields'); return }
    setLoading(true)
    const { error: authError } = await supabase.auth.signInWithPassword({ email, password })
    setLoading(false)
    if (authError) { setError(authError.message); return }
    router.push('/dashboard')
  }


  return (
    <>
      <Stars />
      <div style={{ position: 'fixed', top: 16, right: 16, zIndex: 10 }}><ThemeToggle /></div>
      <div style={{ maxWidth: 380, margin: '0 auto', padding: '16vh 24px', position: 'relative', zIndex: 1 }}>
        <h2 className="ar ar1" style={{ fontSize: '1.6rem', fontWeight: 700, color: 'var(--lilac)', marginBottom: 4 }}>
          welcome back<span className="cursor"></span>
        </h2>
        <p className="prompt ar ar2" style={{ fontSize: 12, marginBottom: 28 }}>your letters have been waiting.</p>

        <div className="ar ar3" style={{ marginBottom: 14 }}>
          <div className="form-label">email</div>
          <input className="ev-input" type="email" value={email} onChange={e => setEmail(e.target.value)} placeholder="you@world.com" />
        </div>
        <div className="ar ar3" style={{ marginBottom: 20 }}>
          <div className="form-label">password</div>
          <input className="ev-input" type="password" value={password} onChange={e => setPassword(e.target.value)} placeholder="••••••" />
        </div>

        {error && (
          <p className="ar" style={{ color: 'var(--pink)', fontSize: 12, marginBottom: 14 }}>
            {'> '}{error}
          </p>
        )}

        <button className="btn btn-full ar ar4" onClick={handleLogin} disabled={loading}>
          {loading ? 'signing in...' : 'sign in'}
        </button>

        <p style={{ textAlign: 'center', marginTop: 20, fontSize: 11, color: 'var(--tx4)' }}>
          no account? <a href="/register">create one</a>
        </p>
      </div>
    </>
  )
}
