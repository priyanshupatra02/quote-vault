-- Create a public bucket named 'avatars'
insert into storage.buckets (id, name, public) 
values ('avatars', 'avatars', true);

-- Policy to allow public viewing of avatars
create policy "Avatar Public View"
  on storage.objects for select
  using ( bucket_id = 'avatars' );

-- Policy to allow anyone to upload (for setup script and user uploads)
-- In production, you might restrict this to authenticated users
create policy "Avatar Upload"
  on storage.objects for insert
  with check ( bucket_id = 'avatars' );

-- Policy to allow users to update their own files (if needed)
create policy "Avatar Update"
  on storage.objects for update
  using ( bucket_id = 'avatars' );
