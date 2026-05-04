-- Allows catalog imports to attach real product photos.

alter table public.products add column if not exists image_url text;
alter table public.products add column if not exists image_source_url text;

create index if not exists products_image_url_idx on public.products(image_url) where image_url is not null;
