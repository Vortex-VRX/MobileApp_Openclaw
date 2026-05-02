# Firebase Database Design

This app should use Cloud Firestore. Firestore is not SQL, so instead of tables, columns, and rows, it uses collections, documents, and fields.

## Main Collections

### stores
Stores that products can be compared against.

| Field | Type | Required | Example |
| --- | --- | --- | --- |
| name | string | yes | Walmart |
| type | string | yes | Discount Supercenter |
| distanceMiles | number | yes | 2.4 |
| hasPickup | boolean | yes | true |
| hasDelivery | boolean | yes | true |
| membershipRequired | boolean | yes | false |
| colorHex | string | yes | #0071CE |
| active | boolean | yes | true |
| createdAt | timestamp | yes | server timestamp |
| updatedAt | timestamp | yes | server timestamp |

### categories
Product browsing categories.

| Field | Type | Required | Example |
| --- | --- | --- | --- |
| title | string | yes | Fruits & Vegetables |
| icon | string | yes | 🥦 |
| itemCount | number | yes | 24 |
| sortOrder | number | yes | 1 |
| active | boolean | yes | true |

### products
Grocery products.

| Field | Type | Required | Example |
| --- | --- | --- | --- |
| name | string | yes | Whole Milk |
| brand | string | yes | Great Value / Store Brand |
| categoryId | string | yes | dairy |
| categoryTitle | string | yes | Dairy Products |
| packageInfo | string | yes | 1 gallon |
| imageEmoji | string | yes | 🥛 |
| healthyScore | number | yes | 74 |
| description | string | yes | A staple dairy item... |
| tags | array<string> | yes | Breakfast, Protein |
| searchableKeywords | array<string> | yes | milk, whole, dairy |
| active | boolean | yes | true |
| createdAt | timestamp | yes | server timestamp |
| updatedAt | timestamp | yes | server timestamp |

### products/{productId}/prices
Store-specific prices for each product.

| Field | Type | Required | Example |
| --- | --- | --- | --- |
| storeId | string | yes | walmart |
| storeName | string | yes | Walmart |
| price | number | yes | 3.48 |
| unitPrice | number | yes | 0.92 |
| unitLabel | string | yes | qt |
| availability | boolean | yes | true |
| discountLabel | string/null | no | Weekly deal |
| membershipPrice | number/null | no | 3.49 |
| lastUpdated | timestamp | yes | server timestamp |
| source | string | yes | manual |

### users
User profiles. Document id should be the Firebase Auth uid.

| Field | Type | Required | Example |
| --- | --- | --- | --- |
| displayName | string | no | Alex |
| email | string | no | alex@example.com |
| homeZipCode | string | no | 01801 |
| preferredStores | array<string> | no | walmart, target |
| premium | boolean | yes | false |
| createdAt | timestamp | yes | server timestamp |
| updatedAt | timestamp | yes | server timestamp |

### users/{userId}/cart
User cart items.

| Field | Type | Required | Example |
| --- | --- | --- | --- |
| productId | string | yes | milk |
| quantity | number | yes | 1 |
| addedAt | timestamp | yes | server timestamp |

### users/{userId}/favorites
Favorite products watched for later.

| Field | Type | Required | Example |
| --- | --- | --- | --- |
| productId | string | yes | milk |
| createdAt | timestamp | yes | server timestamp |

### users/{userId}/alerts
Price alert rules.

| Field | Type | Required | Example |
| --- | --- | --- | --- |
| productId | string | yes | eggs |
| targetPrice | number | yes | 3.50 |
| enabled | boolean | yes | true |
| createdAt | timestamp | yes | server timestamp |
| updatedAt | timestamp | yes | server timestamp |

## Recommended Launch Version

For version 1, use manual/admin-managed product and price data. Live grocery integrations can come later after legal/API access is clear.

## Query Plan

- Home screen: read `categories`, read active `products`, read each product's `prices` subcollection.
- Search screen: query active `products` and filter by `searchableKeywords`.
- Cart screen: read user cart, then calculate totals from product price subcollections.
- Stores screen: read active `stores`.
- Profile screen: read user document plus cart/favorites/alerts counts.

## Future Admin Role

Add a custom Firebase Auth claim named `admin`. Admin users can create/update stores, categories, products, and prices. Normal users can only read public catalog data and manage their own cart/favorites/alerts.
