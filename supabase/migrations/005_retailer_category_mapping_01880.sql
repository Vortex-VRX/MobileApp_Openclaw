-- Food category map for BJ's, Market Basket, and Costco in the 01880 launch market.

insert into public.categories (id, title, icon, item_count, sort_order, active, source_retailers, food_only) values
  ('produce', 'Produce', '🥦', 0, 10, true, array['bjs', 'market_basket', 'costco'], true),
  ('meat', 'Meat', '🥩', 0, 20, true, array['bjs', 'market_basket', 'costco'], true),
  ('seafood', 'Seafood', '🦐', 0, 30, true, array['bjs', 'market_basket'], true),
  ('dairy-frozen', 'Dairy & Frozen Foods', '🥛', 0, 40, true, array['market_basket'], true),
  ('dairy', 'Dairy', '🧀', 0, 45, true, array['bjs'], true),
  ('frozen-foods', 'Frozen Foods', '🧊', 0, 50, true, array['bjs'], true),
  ('bakery', 'Bakery', '🍞', 0, 60, true, array['bjs', 'market_basket', 'costco'], true),
  ('deli', 'Deli', '🥪', 0, 70, true, array['bjs', 'market_basket', 'costco'], true),
  ('prepared-foods', 'Prepared Foods', '🍽️', 0, 80, true, array['bjs', 'market_basket'], true),
  ('pantry', 'Pantry', '🥫', 0, 90, true, array['bjs', 'market_basket'], true),
  ('beverages', 'Beverages', '🥤', 0, 100, true, array['bjs'], true),
  ('snacks', 'Snacks', '🍿', 0, 110, true, array['bjs'], true),
  ('breakfast', 'Breakfast', '🥣', 0, 120, true, array['bjs'], true),
  ('baking-ingredients', 'Baking Ingredients', '🧁', 0, 130, true, array['bjs'], true),
  ('candy', 'Candy', '🍬', 0, 140, true, array['bjs'], true),
  ('protein-nutrition', 'Protein & Nutrition', '💪', 0, 150, true, array['bjs'], true),
  ('cheese', 'Cheese', '🧀', 0, 160, true, array['market_basket'], true),
  ('sushi', 'Sushi', '🍣', 0, 170, true, array['market_basket'], true)
on conflict (id) do update set title = excluded.title, icon = excluded.icon, item_count = excluded.item_count, sort_order = excluded.sort_order, active = excluded.active, source_retailers = excluded.source_retailers, food_only = excluded.food_only;

insert into public.retailer_sources (id, retailer_code, retailer_name, market_area_id, source_url, source_type, data_access_status, notes, active) values
  ('bjs-grocery-public', 'bjs', 'BJ''s Wholesale Club', 'wakefield-01880', 'https://www.bjs.com/category/grocery', 'public_catalog_page', 'needs_location_review', 'Public grocery catalog exposes categories and visible product cards, but prices may vary by club, login, membership, pickup, and delivery.', true),
  ('market-basket-departments', 'market_basket', 'Market Basket', 'wakefield-01880', 'https://www.shopmarketbasket.com/departments', 'public_department_page', 'limited_public_prices', 'Public site provides food departments and weekly flyer, not a full live item-price catalog.', true),
  ('costco-warehouse-danvers', 'costco', 'Costco Wholesale', 'wakefield-01880', 'https://www.costco.com/warehouse-locations/danvers-ma-301.html', 'public_warehouse_page', 'limited_public_prices', 'Warehouse page confirms departments, but item prices often depend on membership, warehouse, delivery, and availability.', true)
on conflict (id) do update set retailer_code = excluded.retailer_code, retailer_name = excluded.retailer_name, market_area_id = excluded.market_area_id, source_url = excluded.source_url, source_type = excluded.source_type, data_access_status = excluded.data_access_status, notes = excluded.notes, active = excluded.active;

insert into public.retailer_category_map (retailer_code, category_id, retailer_category_name, source_url, active) values
  ('bjs', 'bakery', 'Bakery', 'https://www.bjs.com/category/grocery', true),
  ('bjs', 'dairy', 'Dairy', 'https://www.bjs.com/category/grocery', true),
  ('bjs', 'beverages', 'Beverages', 'https://www.bjs.com/category/grocery', true),
  ('bjs', 'frozen-foods', 'Frozen Foods', 'https://www.bjs.com/category/grocery', true),
  ('bjs', 'meat', 'Meat', 'https://www.bjs.com/category/grocery', true),
  ('bjs', 'produce', 'Produce', 'https://www.bjs.com/category/grocery', true),
  ('bjs', 'deli', 'Deli', 'https://www.bjs.com/category/grocery', true),
  ('bjs', 'prepared-foods', 'Prepared Foods', 'https://www.bjs.com/category/grocery', true),
  ('bjs', 'seafood', 'Seafood', 'https://www.bjs.com/category/grocery', true),
  ('bjs', 'pantry', 'Pantry', 'https://www.bjs.com/category/grocery', true),
  ('bjs', 'snacks', 'Snacks', 'https://www.bjs.com/category/grocery', true),
  ('bjs', 'baking-ingredients', 'Baking Ingredients', 'https://www.bjs.com/category/grocery', true),
  ('bjs', 'breakfast', 'Breakfast', 'https://www.bjs.com/category/grocery', true),
  ('bjs', 'protein-nutrition', 'Protein & Nutrition', 'https://www.bjs.com/category/grocery', true),
  ('market_basket', 'bakery', 'Bakery', 'https://www.shopmarketbasket.com/departments', true),
  ('market_basket', 'dairy-frozen', 'Dairy & Frozen Foods', 'https://www.shopmarketbasket.com/departments', true),
  ('market_basket', 'deli', 'Delicatessen', 'https://www.shopmarketbasket.com/departments', true),
  ('market_basket', 'pantry', 'Grocery', 'https://www.shopmarketbasket.com/departments', true),
  ('market_basket', 'prepared-foods', 'Market''s Kitchen', 'https://www.shopmarketbasket.com/departments', true),
  ('market_basket', 'meat', 'Meat', 'https://www.shopmarketbasket.com/departments', true),
  ('market_basket', 'produce', 'Produce', 'https://www.shopmarketbasket.com/departments', true),
  ('market_basket', 'seafood', 'Seafood', 'https://www.shopmarketbasket.com/departments', true),
  ('market_basket', 'sushi', 'Sushi', 'https://www.shopmarketbasket.com/departments', true),
  ('market_basket', 'cheese', 'Cheese Shop', 'https://www.shopmarketbasket.com/departments', true),
  ('costco', 'bakery', 'Bakery', 'https://www.costco.com/warehouse-locations/danvers-ma-301.html', true),
  ('costco', 'deli', 'Fresh Deli', 'https://www.costco.com/warehouse-locations/danvers-ma-301.html', true),
  ('costco', 'meat', 'Fresh Meat', 'https://www.costco.com/warehouse-locations/danvers-ma-301.html', true),
  ('costco', 'produce', 'Fresh Produce', 'https://www.costco.com/warehouse-locations/danvers-ma-301.html', true)
on conflict (retailer_code, category_id, retailer_category_name) do update set source_url = excluded.source_url, active = excluded.active;
