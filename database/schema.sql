-- OH B2B multi-service foundation (Supabase PostgreSQL)
create extension if not exists pgcrypto;
create type public.partner_role as enum ('super_admin','master_agent','agent','sub_agent','provider','finance');
create type public.case_status as enum ('new','review','processing','completed','cancelled');
create table public.organizations (id uuid primary key default gen_random_uuid(), name text not null, country text, created_at timestamptz not null default now());
create table public.profiles (id uuid primary key references auth.users(id) on delete cascade, organization_id uuid references public.organizations(id), display_name text not null default '', role public.partner_role not null default 'agent', approved boolean not null default false, created_at timestamptz not null default now());
create table public.services (id uuid primary key default gen_random_uuid(), title text not null, division text not null, active boolean not null default false);
create table public.cases (id uuid primary key default gen_random_uuid(), organization_id uuid not null references public.organizations(id), owner_id uuid not null references public.profiles(id), service_id uuid references public.services(id), reference_code text not null unique, client_label text not null, status public.case_status not null default 'new', created_at timestamptz not null default now());
create table public.commissions (id uuid primary key default gen_random_uuid(), case_id uuid not null references public.cases(id), organization_id uuid not null references public.organizations(id), amount numeric(12,2) not null check(amount>=0), currency text not null default 'MYR', status text not null default 'pending' check(status in ('pending','approved','paid')), created_at timestamptz not null default now());
create table public.audit_log (id bigint generated always as identity primary key, actor_id uuid references public.profiles(id), action text not null, target_table text not null, target_id uuid, created_at timestamptz not null default now());
create index on public.cases(organization_id);create index on public.commissions(organization_id);
create function public.my_org() returns uuid language sql stable security definer set search_path=public as $$ select organization_id from public.profiles where id=auth.uid() and approved=true $$;
create function public.is_admin() returns boolean language sql stable security definer set search_path=public as $$ select exists(select 1 from public.profiles where id=auth.uid() and approved=true and role='super_admin') $$;
alter table public.organizations enable row level security;
alter table public.profiles enable row level security;
alter table public.services enable row level security;
alter table public.cases enable row level security;
alter table public.commissions enable row level security;
alter table public.audit_log enable row level security;
create policy "read own organization" on public.organizations for select to authenticated using (id=public.my_org() or public.is_admin());
create policy "read own profile" on public.profiles for select to authenticated using (id=auth.uid() or (approved=true and organization_id=public.my_org()) or public.is_admin());
create policy "read active services" on public.services for select to authenticated using (active or public.is_admin());
create policy "read own cases" on public.cases for select to authenticated using (organization_id=public.my_org() or public.is_admin());
create policy "create own cases" on public.cases for insert to authenticated with check (organization_id=public.my_org() and owner_id=auth.uid());
create policy "update own cases" on public.cases for update to authenticated using (organization_id=public.my_org() or public.is_admin()) with check (organization_id=public.my_org() or public.is_admin());
create policy "read own commissions" on public.commissions for select to authenticated using (organization_id=public.my_org() or public.is_admin());
create policy "admin audit read" on public.audit_log for select to authenticated using (public.is_admin());
-- IMPORTANT: Admin approvals, role changes, commission payouts and audit inserts must be performed via trusted server-side operations.
-- Never expose a service-role key in browser code. No self-approval policy is granted.
