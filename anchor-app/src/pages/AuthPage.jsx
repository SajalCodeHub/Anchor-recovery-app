import { useState } from 'react'
import { supabase } from '../supabaseClient'

export function AnchorMark({ size = 28 }) {
  return (
    <svg viewBox="0 0 24 24" width={size} height={size} fill="none" stroke="currentColor"
         strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
      <circle cx="12" cy="5" r="2.2" />
      <path d="M12 7.2V21M8 11h8M4 14c0 4 3.5 7 8 7s8-3 8-7" />
    </svg>
  )
}

function Shell({ title, children }) {
  return (
    <main className="split">
      <aside className="panel">
        <div className="brand"><AnchorMark /> <span>Anchor</span></div>
        <h1>Your recovery stays yours.</h1>
        <p>Free, with no paywall. Your check-ins and journal are private to you, and the database itself enforces that.</p>
        <p>In the community feed you appear only under a random name, never your email.</p>
      </aside>
      <section className="formwrap">
        <h2>{title}</h2>
        {children}
      </section>
    </main>
  )
}

export default function AuthPage() {
  const [mode, setMode] = useState('login') // login | signup | reset
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [confirm, setConfirm] = useState('')
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState('')
  const [notice, setNotice] = useState('')

  const switchMode = (m) => { setMode(m); setError(''); setNotice('') }

  async function submit(e) {
    e.preventDefault()
    setError(''); setNotice('')
    if (mode !== 'reset' && password.length < 8) return setError('Use a password of at least 8 characters.')
    if (mode === 'signup' && password !== confirm) return setError('The two passwords do not match.')
    setBusy(true)
    try {
      if (mode === 'login') {
        const { error } = await supabase.auth.signInWithPassword({ email, password })
        if (error) throw error
      } else if (mode === 'signup') {
        const { data, error } = await supabase.auth.signUp({ email, password })
        if (error) throw error
        if (!data.session) setNotice('Account created. Check your email to confirm it, then log in.')
      } else {
        const { error } = await supabase.auth.resetPasswordForEmail(email, { redirectTo: window.location.origin })
        if (error) throw error
        setNotice('If that email has an account, a reset link is on its way.')
      }
    } catch (err) {
      setError(err.message || 'Something went wrong. Try again.')
    } finally {
      setBusy(false)
    }
  }

  const titles = { login: 'Log in', signup: 'Create your account', reset: 'Reset your password' }
  const cta = { login: 'Log in', signup: 'Create account', reset: 'Send reset link' }

  return (
    <Shell title={titles[mode]}>
      <form onSubmit={submit} noValidate>
        <label>Email
          <input type="email" value={email} onChange={(e) => setEmail(e.target.value)} autoComplete="email" required />
        </label>
        {mode !== 'reset' && (
          <label>Password
            <input type="password" value={password} onChange={(e) => setPassword(e.target.value)}
                   autoComplete={mode === 'login' ? 'current-password' : 'new-password'} required />
          </label>
        )}
        {mode === 'signup' && (
          <label>Confirm password
            <input type="password" value={confirm} onChange={(e) => setConfirm(e.target.value)} autoComplete="new-password" required />
          </label>
        )}
        {error && <p className="msg error" role="alert">{error}</p>}
        {notice && <p className="msg ok" role="status">{notice}</p>}
        <button className="primary" disabled={busy}>{busy ? 'Working…' : cta[mode]}</button>
      </form>
      <div className="links">
        {mode !== 'login' && <button className="link" onClick={() => switchMode('login')}>Back to log in</button>}
        {mode === 'login' && <button className="link" onClick={() => switchMode('signup')}>Create an account</button>}
        {mode === 'login' && <button className="link" onClick={() => switchMode('reset')}>Forgot password?</button>}
      </div>
    </Shell>
  )
}

// Shown after the user clicks the reset link in their email.
export function SetNewPassword({ onDone }) {
  const [password, setPassword] = useState('')
  const [error, setError] = useState('')
  const [busy, setBusy] = useState(false)

  async function submit(e) {
    e.preventDefault()
    if (password.length < 8) return setError('Use a password of at least 8 characters.')
    setBusy(true)
    const { error } = await supabase.auth.updateUser({ password })
    setBusy(false)
    if (error) return setError(error.message)
    onDone()
  }

  return (
    <Shell title="Choose a new password">
      <form onSubmit={submit} noValidate>
        <label>New password
          <input type="password" value={password} onChange={(e) => setPassword(e.target.value)} autoComplete="new-password" required />
        </label>
        {error && <p className="msg error" role="alert">{error}</p>}
        <button className="primary" disabled={busy}>{busy ? 'Saving…' : 'Save password'}</button>
      </form>
    </Shell>
  )
}
