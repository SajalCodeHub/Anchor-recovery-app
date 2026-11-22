import { createClient } from '@supabase/supabase-js'

// The anon/publishable key is safe in the browser ONLY because RLS protects the data.
export const supabase = createClient(
  import.meta.env.VITE_SUPABASE_URL,
  import.meta.env.VITE_SUPABASE_ANON_KEY
)
