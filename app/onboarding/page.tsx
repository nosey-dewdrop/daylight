'use client'

export const dynamic = 'force-dynamic'

import { useState } from 'react'
import { useRouter } from 'next/navigation'
import { Stars } from '@/components/Stars'
import { ThemeToggle } from '@/components/ThemeToggle'
import { supabase } from '@/lib/supabase'
import { COUNTRY_COORDS } from '@/lib/countries'

const AVATARS_LIST = ['🦢', '🌙', '✦', '🐚', '🦋', '🌿', '☁', '🪻', '🔮', '🕊']
const MBTI = ['INTJ','INTP','ENTJ','ENTP','INFJ','INFP','ENFJ','ENFP','ISTJ','ISFJ','ESTJ','ESFJ','ISTP','ISFP','ESTP','ESFP']
const INTERESTS_LIST = ['philosophy','literature','music','astronomy','psychology','slow living','art','cinema','poetry','mythology','technology','history','writing','photography','languages','cooking']
const COUNTRIES = ['argentina','australia','austria','belgium','brazil','canada','chile','china','colombia','czech republic','denmark','egypt','finland','france','germany','greece','hungary','iceland','india','indonesia','ireland','israel','italy','japan','kenya','korea','mexico','morocco','netherlands','new zealand','nigeria','norway','pakistan','peru','philippines','poland','portugal','romania','russia','saudi arabia','singapore','south africa','spain','sweden','switzerland','thailand','turkey','ukraine','united kingdom','united states','vietnam']
const LANGUAGES = ['english','spanish','french','german','italian','portuguese','turkish','japanese','korean','chinese','arabic','hindi','russian','dutch','swedish','norwegian','danish','finnish','polish','greek','czech','romanian','hungarian','indonesian','thai','vietnamese']
const ZODIACS = ['aries','taurus','gemini','cancer','leo','virgo','libra','scorpio','sagittarius','capricorn','aquarius','pisces']

export default function OnboardingPage() {
  const router = useRouter()
  const [step, setStep] = useState(1)
  const [avatar, setAvatar] = useState('🦢')
  const [country, setCountry] = useState('')
  const [languages, setLanguages] = useState<string[]>([])
  const [age, setAge] = useState('')
  const [zodiac, setZodiac] = useState('')
  const [bio, setBio] = useState('')
  const [mbti, setMbti] = useState('')
  const [interests, setInterests] = useState<string[]>([])
  const [reading, setReading] = useState('')
  const [lastSong, setLastSong] = useState('')
  const [motto, setMotto] = useState('')
  const [error, setError] = useState('')
  const [saving, setSaving] = useState(false)

  function toggleInterest(i: string) {
    setInterests(prev => prev.includes(i) ? prev.filter(x => x !== i) : [...prev, i])
  }

  function toggleLanguage(l: string) {
    setLanguages(prev => prev.includes(l) ? prev.filter(x => x !== l) : [...prev, l])
  }

  async function finish() {
    setError('')
    setSaving(true)

    const { data: { user }, error: userError } = await supabase.auth.getUser()
    if (userError || !user) {
      setError('could not get user — please sign in again.')
      setSaving(false)
      return
    }

    // find avatar id from avatars table
    const { data: avatarRow } = await supabase
      .from('avatars')
      .select('id')
      .eq('emoji', avatar)
      .single()

    const coords = COUNTRY_COORDS[country] || null

    // save user profile
    const { error: profileError } = await supabase.from('users').upsert({
      id: user.id,
      display_name: user.user_metadata?.full_name || user.email?.split('@')[0] || 'anon',
      avatar_id: avatarRow?.id || 1,
      country,
      languages,
      age: age ? parseInt(age) : null,
      zodiac: zodiac || null,
      bio: bio || null,
      mbti: mbti || null,
      current_book: reading || null,
      last_song: lastSong || null,
      life_motto: motto || null,
      latitude: coords?.lat || null,
      longitude: coords?.lng || null,
      onboarding_complete: true,
    })

    if (profileError) {
      setError(profileError.message)
      setSaving(false)
      return
    }

    // save interests to user_interests junction table
    if (interests.length > 0) {
      const { data: interestRows } = await supabase
        .from('interests')
        .select('id, name')
        .in('name', interests)

      if (interestRows && interestRows.length > 0) {
        const rows = interestRows.map(i => ({ user_id: user.id, interest_id: i.id }))
        await supabase.from('user_interests').upsert(rows)
      }
    }

    // give default stamps
    const { data: defaultStamps } = await supabase
      .from('stamps')
      .select('id')
      .eq('xp_required', 0)
      .eq('is_premium', false)

    if (defaultStamps && defaultStamps.length > 0) {
      const stampRows = defaultStamps.map(s => ({ user_id: user.id, stamp_id: s.id }))
      await supabase.from('user_stamps').upsert(stampRows)
    }

    setSaving(false)
    router.push('/dashboard')
  }

  return (
    <>
      <Stars />
      <div style={{ position: 'fixed', top: 16, right: 16, zIndex: 10 }}><ThemeToggle /></div>
      <div style={{ maxWidth: 480, margin: '0 auto', padding: '8vh 24px', position: 'relative', zIndex: 1 }}>
        {/* progress */}
        <div style={{ display: 'flex', gap: 6, justifyContent: 'center', marginBottom: 32 }}>
          {[1,2,3,4,5].map(s => (
            <div key={s} style={{
              width: 8, height: 8, borderRadius: '50%',
              background: s <= step ? 'var(--lilac)' : 'var(--brd)',
              transition: 'background 0.3s',
            }} />
          ))}
        </div>

        {/* step 1: avatar */}
        {step === 1 && (
          <div className="ar ar1">
            <h2 style={{ fontSize: 20, fontWeight: 700, color: 'var(--lilac)', marginBottom: 4 }}>choose your avatar</h2>
            <p className="prompt" style={{ fontSize: 13, marginBottom: 24 }}>no real photos — mystery is part of the magic.</p>
            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(5, 1fr)', gap: 12, marginBottom: 28 }}>
              {AVATARS_LIST.map(a => (
                <button key={a} className="avatar" onClick={() => setAvatar(a)}
                  style={{
                    width: 56, height: 56, fontSize: 24, cursor: 'pointer', margin: '0 auto',
                    borderColor: avatar === a ? 'var(--lilac)' : 'var(--brd)',
                    background: avatar === a ? 'var(--acf)' : 'var(--bg2)',
                  }}>
                  {a}
                </button>
              ))}
            </div>
            <button className="btn btn-full" onClick={() => setStep(2)}>next &rarr;</button>
          </div>
        )}

        {/* step 2: about */}
        {step === 2 && (
          <div className="ar ar1">
            <h2 style={{ fontSize: 20, fontWeight: 700, color: 'var(--lilac)', marginBottom: 4 }}>a little about you</h2>
            <p className="prompt" style={{ fontSize: 13, marginBottom: 24 }}>leave breadcrumbs of your soul.</p>
            <div style={{ marginBottom: 14 }}>
              <div className="form-label">country</div>
              <select className="ev-input" value={country} onChange={e => setCountry(e.target.value)} style={{ cursor: 'pointer' }}>
                <option value="">select your country</option>
                {COUNTRIES.map(c => <option key={c} value={c}>{c}</option>)}
              </select>
            </div>
            <div style={{ marginBottom: 14 }}>
              <div className="form-label">languages (pick all you speak)</div>
              <div style={{ display: 'flex', gap: 6, flexWrap: 'wrap' }}>
                {LANGUAGES.map(l => (
                  <button key={l} className="tag" onClick={() => toggleLanguage(l)}
                    style={{
                      cursor: 'pointer',
                      borderColor: languages.includes(l) ? 'var(--lilac)' : undefined,
                      color: languages.includes(l) ? 'var(--lilac)' : undefined,
                      background: languages.includes(l) ? 'var(--acf)' : undefined,
                    }}>
                    {l}
                  </button>
                ))}
              </div>
            </div>
            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12, marginBottom: 14 }}>
              <div>
                <div className="form-label">age</div>
                <input className="ev-input" type="number" value={age} onChange={e => setAge(e.target.value)} placeholder="23" min="13" max="99" />
              </div>
              <div>
                <div className="form-label">zodiac</div>
                <select className="ev-input" value={zodiac} onChange={e => setZodiac(e.target.value)} style={{ cursor: 'pointer' }}>
                  <option value="">select</option>
                  {ZODIACS.map(z => <option key={z} value={z}>{z}</option>)}
                </select>
              </div>
            </div>
            <div style={{ marginBottom: 24 }}>
              <div className="form-label">bio</div>
              <textarea className="ev-input" value={bio} onChange={e => setBio(e.target.value)} placeholder="tell us about yourself..." rows={3} style={{ resize: 'vertical' }} />
              <div style={{ fontSize: 11, color: 'var(--tx4)', marginTop: 4, textAlign: 'right' }}>{bio.length}/300</div>
            </div>
            <button className="btn btn-full" onClick={() => setStep(3)}>next &rarr;</button>
          </div>
        )}

        {/* step 3: mbti */}
        {step === 3 && (
          <div className="ar ar1">
            <h2 style={{ fontSize: 20, fontWeight: 700, color: 'var(--lilac)', marginBottom: 4 }}>what&apos;s your type?</h2>
            <p className="prompt" style={{ fontSize: 13, marginBottom: 24 }}>optional — but people love knowing this.</p>
            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 8, marginBottom: 28 }}>
              {MBTI.map(m => (
                <button key={m} className="tag" onClick={() => setMbti(m)}
                  style={{
                    cursor: 'pointer', textAlign: 'center', padding: '8px 4px',
                    borderColor: mbti === m ? 'var(--lilac)' : undefined,
                    color: mbti === m ? 'var(--lilac)' : undefined,
                    background: mbti === m ? 'var(--acf)' : undefined,
                  }}>
                  {m}
                </button>
              ))}
            </div>
            <div style={{ display: 'flex', gap: 12 }}>
              <button className="btn btn-full" onClick={() => setStep(4)}>next &rarr;</button>
              <button className="btn-ghost" onClick={() => setStep(4)}>skip</button>
            </div>
          </div>
        )}

        {/* step 4: interests */}
        {step === 4 && (
          <div className="ar ar1">
            <h2 style={{ fontSize: 20, fontWeight: 700, color: 'var(--lilac)', marginBottom: 4 }}>what draws you in?</h2>
            <p className="prompt" style={{ fontSize: 13, marginBottom: 24 }}>pick at least 3 — we&apos;ll help you find kindred spirits.</p>
            <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap', marginBottom: 28 }}>
              {INTERESTS_LIST.map(i => (
                <button key={i} className="tag" onClick={() => toggleInterest(i)}
                  style={{
                    cursor: 'pointer',
                    borderColor: interests.includes(i) ? 'var(--lilac)' : undefined,
                    color: interests.includes(i) ? 'var(--lilac)' : undefined,
                    background: interests.includes(i) ? 'var(--acf)' : undefined,
                  }}>
                  {i}
                </button>
              ))}
            </div>
            <button className="btn btn-full" onClick={() => setStep(5)} disabled={interests.length < 3}
              style={{ opacity: interests.length < 3 ? 0.5 : 1 }}>
              next &rarr;
            </button>
          </div>
        )}

        {/* step 5: soul crumbs */}
        {step === 5 && (
          <div className="ar ar1">
            <h2 style={{ fontSize: 20, fontWeight: 700, color: 'var(--lilac)', marginBottom: 4 }}>the tiny windows</h2>
            <p className="prompt" style={{ fontSize: 13, marginBottom: 24 }}>these aren&apos;t data points — they&apos;re pieces of your world.</p>
            <div style={{ marginBottom: 14 }}>
              <div className="form-label">currently reading</div>
              <input className="ev-input" value={reading} onChange={e => setReading(e.target.value)} placeholder="the book on your nightstand..." />
            </div>
            <div style={{ marginBottom: 14 }}>
              <div className="form-label">last song you listened to</div>
              <input className="ev-input" value={lastSong} onChange={e => setLastSong(e.target.value)} placeholder="the one still echoing..." />
            </div>
            <div style={{ marginBottom: 28 }}>
              <div className="form-label">life motto</div>
              <input className="ev-input" value={motto} onChange={e => setMotto(e.target.value)} placeholder="the words you live by..." />
            </div>
            {error && (
              <p className="ar" style={{ color: 'var(--pink)', fontSize: 12, marginBottom: 14 }}>
                {'> '}{error}
              </p>
            )}
            <button className="btn btn-full" onClick={finish} disabled={saving}>
              {saving ? 'saving...' : 'enter forget-me-not'}
            </button>
          </div>
        )}
      </div>
    </>
  )
}
