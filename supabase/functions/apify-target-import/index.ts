import { createClient } from "https://esm.sh/@supabase/supabase-js@2.43.4";

type JsonMap = Record<string, unknown>;

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: corsHeaders });
  if (req.method !== "POST") return json({ error: "Use POST" }, 405);

  const apifyToken = Deno.env.get("APIFY_API_TOKEN");
  const supabaseUrl = Deno.env.get("SUPABASE_URL");
  const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
  if (!apifyToken) return json({ error: "Missing APIFY_API_TOKEN Supabase secret" }, 500);
  if (!supabaseUrl || !serviceRoleKey) return json({ error: "Missing Supabase service environment" }, 500);

  const body = await safeJson(req);
  const retailerCode = String(body.retailerCode ?? "target").toLowerCase();
  const storeId = String(body.storeId ?? "target");
  const zipCode = String(body.zipCode ?? "01880");
  const marketAreaId = String(body.marketAreaId ?? "wakefield-01880");
  const actorId = String(body.actorId ?? Deno.env.get("APIFY_TARGET_ACTOR_ID") ?? "makework36~target-scraper");
  const maxItems = numberFrom(body.maxItems, 50);
  const actorInput = buildActorInput(body, zipCode, maxItems);

  const supabase = createClient(supabaseUrl, serviceRoleKey, { auth: { persistSession: false } });
  const run = await insertRun(supabase, { retailerCode, storeId, marketAreaId, zipCode, actorId, input: actorInput });

  try {
    const items = await runApifyActor(actorId, actorInput, apifyToken, maxItems);
    let importedCount = 0;
    let skippedCount = 0;

    for (const item of items) {
      const normalized = normalizeItem(item, retailerCode);
      if (!normalized.name || normalized.price === null) {
        skippedCount += 1;
        await recordItem(supabase, run.id, retailerCode, storeId, item, normalized, false);
        continue;
      }

      const productId = normalized.productId;
      const categoryId = categoryFor(normalized.category, normalized.name);
      const packageInfo = normalized.packageInfo || normalized.unitLabel || "1 item";
      const now = new Date().toISOString();

      const { error: productError } = await supabase.from("products").upsert({
        id: productId,
        name: normalized.name,
        brand: normalized.brand || "Target",
        category_id: categoryId,
        package_info: packageInfo,
        image_emoji: emojiFor(categoryId),
        healthy_score: 0,
        description: `Imported from ${retailerCode} via Apify.`,
        tags: [retailerCode, "apify", categoryId],
        searchable_keywords: keywords(normalized.name, normalized.brand, normalized.category),
        active: true,
        source_status: "apify_import",
        source_url: normalized.sourceUrl,
        image_url: normalized.imageUrl,
        image_source_url: normalized.imageUrl,
        last_verified_at: now,
        updated_at: now,
      }, { onConflict: "id" });
      if (productError) throw productError;

      await supabase.from("product_prices").delete().eq("product_id", productId).eq("store_id", storeId).eq("source", "apify");

      const unitPrice = normalized.unitPrice ?? normalized.price;
      const pricePayload = {
        product_id: productId,
        store_id: storeId,
        price: normalized.price,
        unit_price: unitPrice,
        unit_label: normalized.unitLabel || "item",
        availability: normalized.availability,
        discount_label: normalized.discountLabel,
        membership_price: null,
        source: "apify",
        source_url: normalized.sourceUrl,
        market_area_id: marketAreaId,
        price_type: normalized.discountLabel ? "sale" : "regular",
        observed_at: now,
        last_updated: now,
        confidence_score: 0.85,
        external_product_id: normalized.externalProductId,
        external_storefront: retailerCode,
      };
      const { error: priceError } = await supabase.from("product_prices").insert(pricePayload);
      if (priceError) throw priceError;

      await supabase.from("price_history").insert({
        product_id: productId,
        store_id: storeId,
        market_area_id: marketAreaId,
        price: normalized.price,
        unit_price: unitPrice,
        unit_label: normalized.unitLabel || "item",
        availability: normalized.availability,
        discount_label: normalized.discountLabel,
        membership_price: null,
        price_type: normalized.discountLabel ? "sale" : "regular",
        source: "apify",
        source_url: normalized.sourceUrl,
        observed_at: now,
      });

      await recordItem(supabase, run.id, retailerCode, storeId, item, normalized, true, productId);
      importedCount += 1;
    }

    await supabase.from("apify_import_runs").update({ status: "completed", dataset_item_count: items.length, imported_count: importedCount, skipped_count: skippedCount, finished_at: new Date().toISOString() }).eq("id", run.id);
    await supabase.from("stores").update({ last_price_check_at: new Date().toISOString(), updated_at: new Date().toISOString() }).eq("id", storeId);
    return json({ runId: run.id, actorId, retailerCode, storeId, zipCode, received: items.length, imported: importedCount, skipped: skippedCount });
  } catch (error) {
    const message = error instanceof Error ? error.message : String(error);
    await supabase.from("apify_import_runs").update({ status: "failed", error_message: message, finished_at: new Date().toISOString() }).eq("id", run.id);
    return json({ error: message, runId: run.id, actorId }, 500);
  }
});

async function safeJson(req: Request): Promise<JsonMap> { try { return await req.json(); } catch (_) { return {}; } }

function buildActorInput(body: JsonMap, zipCode: string, maxItems: number): JsonMap {
  if (isRecord(body.actorInput)) return body.actorInput;
  const searchTerms = Array.isArray(body.searchTerms) && body.searchTerms.length > 0 ? body.searchTerms : ["milk", "eggs", "bread", "cheese", "chicken", "bananas", "cereal", "yogurt"];
  return { zipCode, postalCode: zipCode, location: zipCode, maxItems, maxResults: maxItems, searchTerms, queries: searchTerms, category: "grocery" };
}

async function insertRun(supabase: ReturnType<typeof createClient>, data: { retailerCode: string; storeId: string; marketAreaId: string; zipCode: string; actorId: string; input: JsonMap }) {
  const { data: run, error } = await supabase.from("apify_import_runs").insert({ retailer_code: data.retailerCode, store_id: data.storeId, market_area_id: data.marketAreaId, zip_code: data.zipCode, actor_id: data.actorId, input: data.input, status: "started" }).select("id").single();
  if (error) throw error;
  return run as { id: string };
}

async function runApifyActor(actorId: string, input: JsonMap, token: string, maxItems: number): Promise<JsonMap[]> {
  const params = new URLSearchParams({ timeout: "180", memory: "1024", clean: "true", format: "json", limit: String(maxItems) });
  const response = await fetch(`https://api.apify.com/v2/acts/${actorId}/run-sync-get-dataset-items?${params}`, { method: "POST", headers: { Authorization: `Bearer ${token}`, "Content-Type": "application/json" }, body: JSON.stringify(input) });
  const text = await response.text();
  if (!response.ok) throw new Error(`Apify actor failed (${response.status}): ${text.slice(0, 500)}`);
  const parsed = JSON.parse(text || "[]");
  return Array.isArray(parsed) ? parsed.filter(isRecord) : [];
}

async function recordItem(supabase: ReturnType<typeof createClient>, runId: string, retailerCode: string, storeId: string, rawItem: JsonMap, normalizedItem: NormalizedItem, imported: boolean, productId?: string) {
  await supabase.from("apify_import_items").insert({ run_id: runId, retailer_code: retailerCode, store_id: storeId, external_product_id: normalizedItem.externalProductId, product_id: productId, source_url: normalizedItem.sourceUrl, raw_item: rawItem, normalized_item: normalizedItem, imported });
}

type NormalizedItem = { productId: string; externalProductId: string; name: string; brand: string; category: string; packageInfo: string; imageUrl: string | null; sourceUrl: string | null; price: number | null; unitPrice: number | null; unitLabel: string; availability: boolean; discountLabel: string | null; };

function normalizeItem(item: JsonMap, retailerCode: string): NormalizedItem {
  const externalProductId = stringValue(item, ["tcin", "sku", "productId", "product_id", "id", "asin", "upc"]) || hash(JSON.stringify(item));
  const name = stringValue(item, ["title", "name", "productName", "product_name", "description"]) || "";
  const brand = stringValue(item, ["brand", "brandName", "manufacturer"]) || "Target";
  const category = stringValue(item, ["category", "categoryName", "department", "aisle"]) || breadcrumbs(item);
  const packageInfo = stringValue(item, ["size", "packageSize", "package_info", "weight", "netWeight", "unit"]) || "1 item";
  const imageUrl = stringValue(item, ["image", "imageUrl", "image_url", "primaryImage", "thumbnail", "mainImage"]) || firstImage(item);
  const sourceUrl = stringValue(item, ["url", "productUrl", "product_url", "canonicalUrl", "sourceUrl"]);
  const price = numberValue(item, ["price", "currentPrice", "salePrice", "offerPrice", "price.value", "price.current", "current_retail"]);
  const unitPrice = numberValue(item, ["unitPrice", "unit_price", "pricePerUnit", "price_per_unit"]);
  const unitLabel = stringValue(item, ["unitLabel", "unit_label", "priceUnit", "unitOfMeasure"]) || "item";
  const availabilityText = stringValue(item, ["availability", "stockStatus", "fulfillment", "inventoryStatus"]);
  const availability = typeof item.available === "boolean" ? item.available : !/out of stock|unavailable/i.test(availabilityText || "");
  const discountLabel = stringValue(item, ["discount", "discountLabel", "promotion", "deal", "offer"]);
  return { productId: `${retailerCode}-${slug(externalProductId || name)}`, externalProductId, name, brand, category, packageInfo, imageUrl, sourceUrl: sourceUrl || (name ? `https://www.target.com/s?searchTerm=${encodeURIComponent(name)}` : null), price, unitPrice, unitLabel, availability, discountLabel };
}

function stringValue(item: JsonMap, keys: string[]): string | null { for (const key of keys) { const value = valueAt(item, key); if (typeof value === "string" && value.trim()) return value.trim(); if (typeof value === "number") return String(value); } return null; }
function numberValue(item: JsonMap, keys: string[]): number | null { for (const key of keys) { const value = valueAt(item, key); if (typeof value === "number" && Number.isFinite(value)) return value; if (typeof value === "string") { const parsed = Number(value.replace(/[^0-9.]/g, "")); if (Number.isFinite(parsed) && parsed > 0) return parsed; } if (isRecord(value)) { const nested = numberValue(value, ["value", "amount", "current", "price"]); if (nested !== null) return nested; } } return null; }
function valueAt(item: JsonMap, path: string): unknown { return path.split(".").reduce<unknown>((current, part) => isRecord(current) ? current[part] : undefined, item); }
function firstImage(item: JsonMap): string | null { const images = item.images; if (Array.isArray(images)) { const first = images[0]; if (typeof first === "string") return first; if (isRecord(first)) return stringValue(first, ["url", "imageUrl", "src"]); } return null; }
function breadcrumbs(item: JsonMap): string { const value = item.breadcrumbs ?? item.breadcrumb; if (Array.isArray(value)) return value.map((entry) => isRecord(entry) ? String(entry.name ?? entry.title ?? "") : String(entry)).filter(Boolean).join(" > "); return typeof value === "string" ? value : "Pantry"; }
function categoryFor(category: string, name: string): string { const text = `${category} ${name}`.toLowerCase(); if (/produce|fruit|vegetable|banana|apple|salad/.test(text)) return "produce"; if (/meat|chicken|beef|pork|turkey/.test(text)) return "meat"; if (/seafood|fish|shrimp|salmon/.test(text)) return "seafood"; if (/milk|dairy|cheese|yogurt|egg/.test(text)) return "dairy"; if (/frozen|ice cream/.test(text)) return "frozen-foods"; if (/bread|bakery|bagel|muffin/.test(text)) return "bakery"; if (/deli|sandwich/.test(text)) return "deli"; if (/drink|beverage|water|juice|soda|coffee/.test(text)) return "beverages"; if (/snack|chip|popcorn|cracker/.test(text)) return "snacks"; if (/cereal|breakfast|oatmeal/.test(text)) return "breakfast"; if (/baking|flour|sugar/.test(text)) return "baking-ingredients"; if (/candy|chocolate/.test(text)) return "candy"; return "pantry"; }
function emojiFor(categoryId: string): string { const map: Record<string, string> = { produce: "🥦", meat: "🥩", seafood: "🦐", dairy: "🧀", "frozen-foods": "🧊", bakery: "🍞", deli: "🥪", beverages: "🥤", snacks: "🍿", breakfast: "🥣", "baking-ingredients": "🧁", candy: "🍬", pantry: "🥫" }; return map[categoryId] ?? "🥫"; }
function keywords(...values: Array<string | null | undefined>): string[] { return [...new Set(values.flatMap((value) => (value ?? "").toLowerCase().split(/[^a-z0-9]+/)).filter((value) => value.length > 1))]; }
function slug(value: string): string { return value.toLowerCase().replace(/[^a-z0-9]+/g, "-").replace(/^-+|-+$/g, "").slice(0, 80) || hash(value); }
function hash(value: string): string { let h = 0; for (let i = 0; i < value.length; i += 1) h = Math.imul(31, h) + value.charCodeAt(i) | 0; return Math.abs(h).toString(36); }
function numberFrom(value: unknown, fallback: number): number { const parsed = typeof value === "number" ? value : Number(value); return Number.isFinite(parsed) && parsed > 0 ? Math.min(parsed, 250) : fallback; }
function isRecord(value: unknown): value is JsonMap { return typeof value === "object" && value !== null && !Array.isArray(value); }
function json(data: unknown, status = 200): Response { return new Response(JSON.stringify(data), { status, headers: { ...corsHeaders, "Content-Type": "application/json" } }); }
