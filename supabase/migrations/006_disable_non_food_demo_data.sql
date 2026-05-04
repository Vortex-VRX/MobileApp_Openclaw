-- Keep the launch catalog focused on food only.

update public.categories
set active = false, food_only = false
where id in ('household');

update public.products
set active = false, source_status = 'retired_non_food'
where category_id in ('household') or id in ('paper-towels');
