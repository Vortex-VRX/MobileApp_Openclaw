import '../models/category_model.dart';
import '../models/price_option.dart';
import '../models/product_model.dart';
import '../models/store_model.dart';
import 'supabase_catalog_repository.dart';

List<StoreModel> stores = [
  const StoreModel(id: 'walmart', name: 'Walmart', type: 'Discount Supercenter', distanceMiles: 2.4, hasPickup: true, hasDelivery: true, membershipRequired: false, colorHex: 0xFF0071CE),
  const StoreModel(id: 'market-basket', name: 'Market Basket', type: 'Local Grocery', distanceMiles: 1.8, hasPickup: false, hasDelivery: false, membershipRequired: false, colorHex: 0xFF16833C),
  const StoreModel(id: 'bjs', name: 'BJ\'s Wholesale', type: 'Wholesale Club', distanceMiles: 5.3, hasPickup: true, hasDelivery: true, membershipRequired: true, colorHex: 0xFFB71C1C),
  const StoreModel(id: 'target', name: 'Target', type: 'General Retail', distanceMiles: 3.1, hasPickup: true, hasDelivery: true, membershipRequired: false, colorHex: 0xFFCC0000),
];

List<CategoryModel> categories = [
  const CategoryModel(id: 'grocery-deals', title: 'Grocery Deals', icon: '🏷️', itemCount: 0),
  const CategoryModel(id: 'frozen-foods', title: 'Frozen Foods', icon: '🧊', itemCount: 0),
  const CategoryModel(id: 'snacks', title: 'Snacks', icon: '🥨', itemCount: 0),
  const CategoryModel(id: 'meat', title: 'Fresh Meat & Seafood', icon: '🥩', itemCount: 1),
  const CategoryModel(id: 'produce', title: 'Produce', icon: '🥦', itemCount: 1),
  const CategoryModel(id: 'bakery', title: 'Bakery & Bread', icon: '🍞', itemCount: 0),
  const CategoryModel(id: 'beverages', title: 'Beverages', icon: '🥤', itemCount: 0),
  const CategoryModel(id: 'pantry', title: 'Pantry', icon: '🥫', itemCount: 0),
  const CategoryModel(id: 'breakfast', title: 'Breakfast & Cereal', icon: '🥣', itemCount: 1),
  const CategoryModel(id: 'dairy', title: 'Dairy, Eggs & Cheese', icon: '🥛', itemCount: 2),
  const CategoryModel(id: 'deli', title: 'Deli', icon: '🥪', itemCount: 0),
  const CategoryModel(id: 'international-foods', title: 'International Foods', icon: '🌮', itemCount: 0),
  const CategoryModel(id: 'candy', title: 'Candy', icon: '🍬', itemCount: 0),
  const CategoryModel(id: 'coffee', title: 'Coffee', icon: '☕', itemCount: 0),
  const CategoryModel(id: 'baby-food', title: 'Baby Food', icon: '🍼', itemCount: 0),
];

List<ProductModel> products = [
  const ProductModel(
    id: 'milk',
    name: 'Whole Milk',
    brand: 'Great Value / Store Brand',
    category: 'Dairy, Eggs & Cheese',
    categoryId: 'dairy',
    packageInfo: '1 gallon',
    imageEmoji: '🥛',
    healthyScore: 74,
    description: 'A staple dairy item with strong weekly price variation across stores and club membership offers.',
    tags: ['Breakfast', 'Protein', 'Family staple'],
    priceOptions: [
      PriceOption(storeId: 'walmart', price: 3.48, unitPrice: 0.92, unitLabel: 'qt', availability: true),
      PriceOption(storeId: 'market-basket', price: 3.29, unitPrice: 0.82, unitLabel: 'qt', availability: true, discountLabel: 'Weekly deal'),
      PriceOption(storeId: 'bjs', price: 3.89, unitPrice: 0.97, unitLabel: 'qt', availability: true, membershipPrice: 3.49),
      PriceOption(storeId: 'target', price: 3.69, unitPrice: 0.92, unitLabel: 'qt', availability: true),
    ],
  ),
  const ProductModel(
    id: 'banana',
    name: 'Bananas',
    brand: 'Fresh Produce',
    category: 'Produce',
    categoryId: 'produce',
    packageInfo: 'per lb',
    imageEmoji: '🍌',
    healthyScore: 96,
    description: 'One of the clearest produce price leaders, ideal for low-cost nutrition and unit-price comparison.',
    tags: ['Fresh', 'High fiber', 'Budget pick'],
    priceOptions: [
      PriceOption(storeId: 'walmart', price: 0.58, unitPrice: 0.58, unitLabel: 'lb', availability: true),
      PriceOption(storeId: 'market-basket', price: 0.49, unitPrice: 0.49, unitLabel: 'lb', availability: true),
      PriceOption(storeId: 'bjs', price: 0.63, unitPrice: 0.63, unitLabel: 'lb', availability: false),
      PriceOption(storeId: 'target', price: 0.59, unitPrice: 0.59, unitLabel: 'lb', availability: true),
    ],
  ),
  const ProductModel(
    id: 'eggs',
    name: 'Large Eggs',
    brand: 'Grade A',
    category: 'Dairy, Eggs & Cheese',
    categoryId: 'dairy',
    packageInfo: '12 count',
    imageEmoji: '🥚',
    healthyScore: 88,
    description: 'A high-frequency cart item that benefits from price alerts because weekly changes are common.',
    tags: ['Protein', 'Breakfast', 'Price alert'],
    priceOptions: [
      PriceOption(storeId: 'walmart', price: 4.12, unitPrice: 0.34, unitLabel: 'egg', availability: true),
      PriceOption(storeId: 'market-basket', price: 3.79, unitPrice: 0.32, unitLabel: 'egg', availability: true),
      PriceOption(storeId: 'bjs', price: 6.99, unitPrice: 0.29, unitLabel: 'egg', availability: true, membershipPrice: 6.49),
      PriceOption(storeId: 'target', price: 4.39, unitPrice: 0.37, unitLabel: 'egg', availability: true),
    ],
  ),
  const ProductModel(
    id: 'chicken',
    name: 'Chicken Breast',
    brand: 'Fresh Pack',
    category: 'Fresh Meat & Seafood',
    categoryId: 'meat',
    packageInfo: 'boneless, per lb',
    imageEmoji: '🍗',
    healthyScore: 91,
    description: 'Useful for comparing family packs, wholesale pricing, and membership savings.',
    tags: ['Lean protein', 'Meal prep', 'Bulk savings'],
    priceOptions: [
      PriceOption(storeId: 'walmart', price: 3.67, unitPrice: 3.67, unitLabel: 'lb', availability: true),
      PriceOption(storeId: 'market-basket', price: 3.49, unitPrice: 3.49, unitLabel: 'lb', availability: true, discountLabel: 'Family pack'),
      PriceOption(storeId: 'bjs', price: 3.19, unitPrice: 3.19, unitLabel: 'lb', availability: true, membershipPrice: 2.99),
      PriceOption(storeId: 'target', price: 4.29, unitPrice: 4.29, unitLabel: 'lb', availability: true),
    ],
  ),
  const ProductModel(
    id: 'cereal',
    name: 'Honey Oat Cereal',
    brand: 'Family Pantry',
    category: 'Breakfast & Cereal',
    categoryId: 'breakfast',
    packageInfo: '18 oz',
    imageEmoji: '🥣',
    healthyScore: 62,
    description: 'Good example of where unit price can matter more than sticker price because pack sizes vary.',
    tags: ['Breakfast', 'Deals', 'Multi-buy'],
    priceOptions: [
      PriceOption(storeId: 'walmart', price: 3.98, unitPrice: 0.22, unitLabel: 'oz', availability: true),
      PriceOption(storeId: 'market-basket', price: 4.29, unitPrice: 0.24, unitLabel: 'oz', availability: true),
      PriceOption(storeId: 'bjs', price: 7.99, unitPrice: 0.18, unitLabel: 'oz', availability: true, membershipPrice: 7.49),
      PriceOption(storeId: 'target', price: 4.49, unitPrice: 0.25, unitLabel: 'oz', availability: true, discountLabel: 'Buy 2 save 10%'),
    ],
  ),
];

void replaceCatalogData(CatalogData data) {
  if (data.stores.isNotEmpty) {
    stores = data.stores;
  }
  if (data.categories.isNotEmpty) {
    categories = data.categories;
  }
  if (data.products.isNotEmpty) {
    products = data.products;
  }
}
