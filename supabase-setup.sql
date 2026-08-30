-- Ya corrido en tu proyecto. El speech compartido reutiliza practice_history
-- (filas id = speech-shared-speech3 / speech-shared-speech4, type = speech_shared).
-- No hace falta una tabla nueva.

create table if not exists public.practice_history (
  id text primary key,
  at timestamptz not null default now(),
  student text not null,
  level text,
  type text not null,
  label text,
  detail text default '',
  score text default '',
  pct int,
  answers jsonb default '[]'::jsonb
);

create index if not exists practice_history_at_idx on public.practice_history (at desc);
create index if not exists practice_history_student_idx on public.practice_history (student);

alter table public.practice_history enable row level security;

drop policy if exists "public read practice_history" on public.practice_history;
drop policy if exists "public insert practice_history" on public.practice_history;
drop policy if exists "public update practice_history" on public.practice_history;
drop policy if exists "public delete practice_history" on public.practice_history;

create policy "public read practice_history"
  on public.practice_history for select using (true);
create policy "public insert practice_history"
  on public.practice_history for insert with check (true);
create policy "public update practice_history"
  on public.practice_history for update using (true);
create policy "public delete practice_history"
  on public.practice_history for delete using (true);

do $$
begin
  alter publication supabase_realtime add table public.practice_history;
exception
  when duplicate_object then null;
end $$;
