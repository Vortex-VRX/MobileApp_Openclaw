insert into stores (id, name, type, distance_miles, has_pickup, has_delivery, membership_required, color_hex, active, retailer_code, market_area_id, source_url, address_line_1, city, state, zip_code, updated_at)
values ('walmart', 'Walmart', 'Discount Supercenter', 2.4, true, true, false, '0xFF0071CE', true, 'walmart', 'wakefield-01880', 'https://www.walmart.com/cp/food/976759', '780 Lynnway', 'Lynn', 'MA', '01905', now())
on conflict (id) do update set
  name = excluded.name,
  type = excluded.type,
  distance_miles = excluded.distance_miles,
  has_pickup = excluded.has_pickup,
  has_delivery = excluded.has_delivery,
  membership_required = excluded.membership_required,
  color_hex = excluded.color_hex,
  active = true,
  retailer_code = excluded.retailer_code,
  market_area_id = excluded.market_area_id,
  source_url = excluded.source_url,
  updated_at = now();

insert into retailer_sources (id, retailer_code, retailer_name, market_area_id, source_url, source_type, data_access_status, notes, active, updated_at)
values ('walmart-apify-wakefield-01880', 'walmart', 'Walmart', 'wakefield-01880', 'https://apify.com/epctex/walmart-scraper', 'apify', 'testing', 'Apify actor epctex/walmart-scraper. Test imports use zip 01880 and small maxItems until source quality is confirmed.', true, now())
on conflict (id) do update set
  retailer_code = excluded.retailer_code,
  retailer_name = excluded.retailer_name,
  market_area_id = excluded.market_area_id,
  source_url = excluded.source_url,
  source_type = excluded.source_type,
  data_access_status = excluded.data_access_status,
  notes = excluded.notes,
  active = true,
  updated_at = now();
