# OH B2B — Global Partner Hub

## Current state
- `index.html`: responsive marketing landing page
- `dashboard.html`: interactive **demo** dashboard (in-memory sample data; no authentication or persistence)
- `database/schema.sql`: initial PostgreSQL/Supabase schema with organization-based row-level security

## Production setup
1. Create a Supabase project owned by Overseas Highway.
2. Review and apply `database/schema.sql` in the SQL editor.
3. Configure authentication and email verification; disable unrestricted account approvals.
4. Create the first admin via a **trusted server-side process** after verifying identity. Never promote an account from browser JavaScript.
5. Build a server-side API for agent approval, role changes, provider onboarding, financial approvals, payouts, and audit logging.
6. Connect the frontend using only the public Supabase URL and publishable/anon key; **never commit service-role keys or secrets**.
7. Configure approved origins, rate limits, monitoring, backups, privacy and data-retention rules before processing real client information.

## GitHub Pages
Pages can host the public site and static demo, but it cannot run a secure backend by itself. Do not enter real customer information into the prototype.
