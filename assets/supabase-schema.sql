create table if not exists public.qr_links (
  id uuid primary key default gen_random_uuid(),
  company_name text not null check (char_length(company_name) between 1 and 100),
  slug text not null unique check (slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$'),
  destination_url text not null check (
    char_length(destination_url) <= 2048
    and destination_url ~* '^https?://'
  ),
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.qr_links enable row level security;

drop policy if exists "Authenticated users manage QR links" on public.qr_links;
create policy "Authenticated users manage QR links"
  on public.qr_links
  for all
  to authenticated
  using (auth.uid() is not null)
  with check (auth.uid() is not null);

revoke all on table public.qr_links from anon, public;
grant select, insert, update, delete on table public.qr_links to authenticated;

create or replace function public.resolve_qr_destination(requested_slug text)
returns text
language sql
stable
security definer
set search_path = ''
as $function$
  select qr.destination_url
  from public.qr_links as qr
  where qr.slug = requested_slug
    and qr.is_active
  limit 1;
$function$;

revoke all on function public.resolve_qr_destination(text) from public;
grant execute on function public.resolve_qr_destination(text) to anon, authenticated;
