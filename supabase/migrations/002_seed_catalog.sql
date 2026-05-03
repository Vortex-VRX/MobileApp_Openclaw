-- Starter catalog data for MobileApp_Codex.

insert into public.stores (id, name, type, distance_miles, has_pickup, has_delivery, membership_required, color_hex, active) values
  ('walmart', 'Walmart', 'Discount Supercenter', 2.4, true, true, false, '#0071CE', true),
  ('market-basket', 'Market Basket', 'Local Grocery', 1.8, false, false, false, '#16833C', true),
  ('bjs', 'BJ''s Wholesale', 'Wholesale Club', 5.3, true, true, true, '#B71C1C', true),
  ('target', 'Target', 'General Retail', 3.1, true, true, false, '#CC0000', true)
on conflict (id) do update set
  name = excluded.name,
  type = excluded.type,
  distance_miles = excluded.distance_miles,
  has_pickup = excluded.has_pickup,
  has_delivery = excluded.has_delivery,
  membership_required = excluded.membership_required,
  color_hex = excluded.color_hex,
  active = excluded.active;

insert into public.categories (id, title, icon, item_count, sort_order, active) values
  ('produce', 'Fruits & Vegetables', '🥦', 24, 1, true),
  ('meat', 'Meat & Poultry', '🍗', 18, 2, true),
  ('dairy', 'Dairy Products', '🥛', 16, 3, true),
  ('snacks', 'Snacks & Beverages', '🥤', 31, 4, true),
  ('household', 'Household Items', '🧻', 12, 5, true)
on conflict (id) do update set
  title = excluded.title,
  icon = excluded.icon,
  item_count = excluded.item_count,
  sort_order = excluded.sort_order,
  active = excluded.active;

insert into public.products (id, name, brand, category_id, package_info, image_emoji, healthy_score, description, tags, searchable_keywords, active) values
  ('milk', 'Whole Milk', 'Great Value / Store Brand', 'dairy', '1 gallon', '🥛', 74, 'A staple dairy item with strong weekly price variation across stores and club membership offers.', array['Breakfast', 'Protein', 'Family staple'], array['milk', 'whole', 'dairy', 'gallon', 'breakfast'], true),
  ('banana', 'Bananas', 'Fresh Produce', 'produce', 'per lb', '🍌', 96, 'One of the clearest produce price leaders, ideal for low-cost nutrition and unit-price comparison.', array['Fresh', 'High fiber', 'Budget pick'], array['banana', 'bananas', 'fruit', 'produce', 'fiber'], true),
  ('eggs', 'Large Eggs', 'Grade A', 'dairy', '12 count', '🥚', 88, 'A high-frequency cart item that benefits from price alerts because weekly changes are common.', array['Protein', 'Breakfast', 'Price alert'], array['eggs', 'egg', 'large', 'protein', 'breakfast', 'dozen'], true),
  ('chicken', 'Chicken Breast', 'Fresh Pack', 'meat', 'boneless, per lb', '🍗', 91, 'Useful for comparing family packs, wholesale pricing, and membership savings.', array['Lean protein', 'Meal prep', 'Bulk savings'], array['chicken', 'breast', 'meat', 'poultry', 'protein'], true),
  ('cereal', 'Honey Oat Cereal', 'Family Pantry', 'snacks', '18 oz', '🥣', 62, 'Good example of where unit price can matter more than sticker price because pack sizes vary.', array['Breakfast', 'Deals', 'Multi-buy'], array['cereal', 'honey', 'oat', 'breakfast', 'snack'], true),
  ('paper-towels', 'Paper Towels', 'Ultra Clean', 'household', '6 rolls', '🧻', 0, 'Household essentials often reward bulk purchase comparisons and club membership pricing.', array['Household', 'Bulk', 'Stock-up item'], array['paper', 'towels', 'paper towels', 'household', 'clean'], true)
on conflict (id) do update set
  name = excluded.name,
  brand = excluded.brand,
  category_id = excluded.category_id,
  package_info = excluded.package_info,
  image_emoji = excluded.image_emoji,
  healthy_score = excluded.healthy_score,
  description = excluded.description,
  tags = excluded.tags,
  searchable_keywords = excluded.searchable_keywords,
  active = excluded.active;

insert into public.product_prices (product_id, store_id, price, unit_price, unit_label, availability, discount_label, membership_price, source) values
  ('milk', 'walmart', 3.48, 0.92, 'qt', true, null, null, 'manual'),
  ('milk', 'market-basket', 3.29, 0.82, 'qt', true, 'Weekly deal', null, 'manual'),
  ('milk', 'bjs', 3.89, 0.97, 'qt', true, null, 3.49, 'manual'),
  ('milk', 'target', 3.69, 0.92, 'qt', true, null, null, 'manual'),
  ('banana', 'walmart', 0.58, 0.58, 'lb', true, null, null, 'manual'),
  ('banana', 'market-basket', 0.49, 0.49, 'lb', true, null, null, 'manual'),
  ('banana', 'bjs', 0.63, 0.63, 'lb', false, null, null, 'manual'),
  ('banana', 'target', 0.59, 0.59, 'lb', true, null, null, 'manual'),
  ('eggs', 'walmart', 4.12, 0.34, 'egg', true, null, null, 'manual'),
  ('eggs', 'market-basket', 3.79, 0.32, 'egg', true, null, null, 'manual'),
  ('eggs', 'bjs', 6.99, 0.29, 'egg', true, null, 6.49, 'manual'),
  ('eggs', 'target', 4.39, 0.37, 'egg', true, null, null, 'manual'),
  ('chicken', 'walmart', 3.67, 3.67, 'lb', true, null, null, 'manual'),
  ('chicken', 'market-basket', 3.49, 3.49, 'lb', true, 'Family pack', null, 'manual'),
  ('chicken', 'bjs', 3.19, 3.19, 'lb', true, null, 2.99, 'manual'),
  ('chicken', 'target', 4.29, 4.29, 'lb', true, null, null, 'manual'),
  ('cereal', 'walmart', 3.98, 0.22, 'oz', true, null, null, 'manual'),
  ('cereal', 'market-basket', 4.29, 0.24, 'oz', true, null, null, 'manual'),
  ('cereal', 'bjs', 7.99, 0.18, 'oz', true, null, 7.49, 'manual'),
  ('cereal', 'target', 4.49, 0.25, 'oz', true, 'Buy 2 save 10%', null, 'manual'),
  ('paper-towels', 'walmart', 8.97, 1.49, 'roll', true, null, null, 'manual'),
  ('paper-towels', 'market-basket', 9.29, 1.55, 'roll', false, null, null, 'manual'),
  ('paper-towels', 'bjs', 15.99, 1.14, 'roll', true, null, 14.99, 'manual'),
  ('paper-towels', 'target', 10.49, 1.75, 'roll', true, null, null, 'manual')
on conflict (product_id, store_id) do update set
  price = excluded.price,
  unit_price = excluded.unit_price,
  unit_label = excluded.unit_label,
  availability = excluded.availability,
  discount_label = excluded.discount_label,
  membership_price = excluded.membership_price,
  source = excluded.source,
  last_updated = now();
