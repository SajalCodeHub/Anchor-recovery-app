import { useEffect, useState } from 'react'
import { supabase } from './supabaseClient'
import AuthPage, { SetNewPassword } from './pages/AuthPage.jsx'
import ProfilePage from './pages/ProfilePage.jsx'

export default function App() {
  const [session, setSession] = useState(null)
  const [ready, setReady] = useState(false)
  const [recovering, setRecovering] = useState(false)

  useEffect(() => {
    supabase.auth.getSession().then(({ data }) => {
      setSession(data.session)
      setReady(true)
    })
    const { data } = supabase.auth.onAuthStateChange((event, s) => {
      setSession(s)
      if (event === 'PASSWORD_RECOVERY') setRecovering(true)
    })
    return () => data.subscription.unsubscribe()
  }, [])

  if (!ready) return <p className="loading">Loading…</p>
  if (recovering) return <SetNewPassword onDone={() => setRecovering(false)} />
  if (!session) return <AuthPage />
  return <ProfilePage session={session} />
}
