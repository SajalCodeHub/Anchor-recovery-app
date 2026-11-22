import { useEffect, useState } from 'react'
import { supabase } from '../supabaseClient'
import { AnchorMark } from './AuthPage.jsx'

const HANDLE_RE = /^[A-Za-z0-9_]{3,24}$/
const zones = typeof Intl.supportedValuesOf === 'function' ? Intl.supportedValuesOf('timeZone') : ['UTC']

export default function ProfilePage({ session }) {
  const user = session.user
  const [profile, setProfile] = useState(null)
  const [pseudo, setPseudo] = useState(null)
  const [handle, setHandle] = useState('')
  const [timezone, setTimezone] = useState('UTC')
  const [newPassword, setNewPassword] = useState('')
  const [msg, setMsg] = useState({ type: '', text: '' })
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    // RLS guarantees these queries can only ever return this user's own rows.
    Promise.all([
      supabase.from('profiles').select('*').maybeSingle(),
      supabase.from('pseudonyms').select('*').maybeSingle(),
    ]).then(([p, n]) => {
      if (p.error || n.error) setMsg({ type: 'error', text: 'Could not load your profile. Refresh and try again.' })
      setProfile(p.data); setPseudo(n.data)
      setTimezone(p.data?.timezone || 'UTC'); setHandle(n.data?.handle || '')
      setLoading(false)
    })
  }, [])

  async function saveProfile(e) {
    e.preventDefault()
    setMsg({ type: '', text: '' })
    if (!HANDLE_RE.test(handle)) return setMsg({ type: 'error', text: 'Public name: 3 to 24 letters, numbers, or underscores.' })

    const { data: p, error: pe } = await supabase.from('profiles')
      .update({ timezone, onboarding_complete: true }).eq('id', user.id).select()
    if (pe || !p?.length) return setMsg({ type: 'error', text: 'Could not save your settings.' })

    if (handle !== pseudo.handle) {
      const { data: n, error: ne } = await supabase.from('pseudonyms')
        .update({ handle }).eq('user_id', user.id).select()
      if (ne?.code === '23505') return setMsg({ type: 'error', text: 'That public name is taken. Try another.' })
      if (ne || !n?.length) return setMsg({ type: 'error', text: 'Could not save your public name.' })
      setPseudo(n[0])
    }
    setProfile(p[0])
    setMsg({ type: 'ok', text: 'Changes saved.' })
  }

  async function changePassword(e) {
    e.preventDefault()
    setMsg({ type: '', text: '' })
    if (newPassword.length < 8) return setMsg({ type: 'error', text: 'Use a password of at least 8 characters.' })
    const { error } = await supabase.auth.updateUser({ password: newPassword })
    if (error) return setMsg({ type: 'error', text: error.message })
    setNewPassword('')
    setMsg({ type: 'ok', text: 'Password updated.' })
  }

  return (
    <main className="profile">
      <header>
        <div className="brand"><AnchorMark /> <span>Anchor</span></div>
        <button className="link" onClick={() => supabase.auth.signOut()}>Log out</button>
      </header>

      <h1>Your profile</h1>
      {loading ? <p>Loading…</p> : (
        <>
          <form onSubmit={saveProfile}>
            <label>Email
              <input value={user.email} disabled />
              <small>Only you can see this. It is never shown in the community feed.</small>
            </label>
            <label>Public name
              <input value={handle} onChange={(e) => setHandle(e.target.value)} maxLength={24} />
              <small>This is the only name others see in the community feed.</small>
            </label>
            <label>Time zone
              <select value={timezone} onChange={(e) => setTimezone(e.target.value)}>
                {!zones.includes(timezone) && <option>{timezone}</option>}
                {zones.map((z) => <option key={z}>{z}</option>)}
              </select>
              <small>Used so your daily check-in resets at your midnight.</small>
            </label>
            <button className="primary">Save changes</button>
          </form>

          <h2>Change password</h2>
          <form onSubmit={changePassword}>
            <label>New password
              <input type="password" value={newPassword} onChange={(e) => setNewPassword(e.target.value)} autoComplete="new-password" />
            </label>
            <button className="primary">Update password</button>
          </form>
        </>
      )}
      {msg.text && <p className={`msg ${msg.type}`} role={msg.type === 'error' ? 'alert' : 'status'}>{msg.text}</p>}
    </main>
  )
}
