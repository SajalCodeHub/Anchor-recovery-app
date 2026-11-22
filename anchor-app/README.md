# Anchor app (Role 1: Login, Signup, Profile)

1. `npm install`
2. Copy `.env.example` to `.env` and fill in the two values from the Supabase dashboard (Connect button).
3. `npm run dev` and open the printed localhost URL.

Supabase setup:
- Authentication > URL Configuration: add `http://localhost:5173` as a Redirect URL (needed for password reset links).
- Authentication > Sign In / Providers > Email: "Confirm email" is on by default. Leave it on for the demo, or turn it off while developing.
