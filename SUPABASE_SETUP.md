# OH B2B Supabase integration

Project URL: https://wftsumtkcauqsgoqymfc.supabase.co

## Current status
The repository contains an authentication UI (`auth.html`) wired to the supplied Supabase project URL. **It is not connected until a publishable key is configured, the SQL schema is applied, and Auth settings are reviewed.** The existing `dashboard.html` is a standalone demo, not a protected production dashboard.

## Setup checklist
1. In Supabase Dashboard → SQL Editor, review and run `database/schema.sql`.
2. In Supabase Dashboard → Project Settings → API Keys, copy the **publishable key** (`sb_publishable_...`) or legacy **anon** key. These are public client keys, but must still be used with correctly configured RLS.
3. Paste the key in `supabase-config.js` under `supabasePublishableKey`. **Never paste a secret or service_role key.**
4. Under Authentication → URL Configuration, add the actual hosted site origin and exact redirect URLs, e.g. `https://overseashighway.github.io/b2b-/auth.html`. Do not assume GitHub Pages is enabled.
5. Configure email verification and suitable anti-abuse protections. New registrations must remain unapproved until verified by an authorized administrator.
6. Add a trusted server-side approval flow and profile creation trigger/API. The supplied schema intentionally does not grant browser clients permission to create approved profiles or change roles.
7. Build an authenticated application backend and replace the public demo dashboard. The demo must never store real customer information.

## Security
Do not use GitHub Pages alone as a backend. Do not commit secrets. Use organization-scoped RLS, audited privileged actions and production review before launch.
