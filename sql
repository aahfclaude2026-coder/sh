-- جدول الروابط
create table if not exists public.shares (
  id uuid primary key default gen_random_uuid(),
  files jsonb not null,
  created_at timestamptz default now()
);

alter table public.shares enable row level security;

create policy "allow insert shares" on public.shares
  for insert to anon, authenticated with check (true);

create policy "allow read shares" on public.shares
  for select to anon, authenticated using (true);

-- مساحة التخزين (Bucket) عامة
insert into storage.buckets (id, name, public)
values ('certificates', 'certificates', true)
on conflict (id) do update set public = true;

create policy "allow upload certificates" on storage.objects
  for insert to anon, authenticated
  with check (bucket_id = 'certificates');

create policy "public read certificates" on storage.objects
  for select to public using (bucket_id = 'certificates');
