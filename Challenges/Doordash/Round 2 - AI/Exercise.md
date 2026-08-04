Screen 1: Store Home Page

- Fetch store data from: `https://dd-interview.github.io/android/v1/feed?query=food&lat=37.7816&lng=-122.4156`
- Display stores in a scrollable vertical list.
- Each store row shows:
  - Store name
  - Cover image (loaded from `cover_img_url`)
  - Delivery fee (formatted as dollars -- there are 100 cents in a US dollar)
  - Description
- Tapping a store row navigates to its detail page.

## Screen 2: Store Detail Page

- Display the store name as the page title.
- Show the store's cover image, delivery fee, and description at the top.
- Fetch menu data from: `https://dd-interview.github.io/android/v1/menu`
- Display menu items in a list below the store info. Each item shows:
  - Item name
  - Price (formatted as dollars)

## API Schema Details

### Store List Endpoint

`GET https://dd-interview.github.io/android/v1/feed?query=food&lat=37.7816&lng=-122.4156`

Returns an array of store objects. The query parameters do not need to be changed. The endpoint is a mock and will always return the same results.

**Fields:**

| Field | Type | Description |
| ----- | ---- | ----------- |
| `id` | Int | Store identifier |
| `name` | String | Store name |
| `description` | String | Cuisine tags |
| `status` | String | Store availability (e.g. "Opened", "Closed", "30 mins") |
| `delivery_fee` | Int | Delivery fee in cents |
| `cover_img_url` | String | URL to the store's cover image |

**Example response:**

```json
[
    {
        "id": 62087,
        "name": "The Melt",
        "description": "Burgers, Fast Food, Sandwiches",
        "status": "Closed",
        "delivery_fee": 100,
        "cover_img_url": "https://cdn.doordash.com/media/restaurant/cover/The-Melt.png"
    },
    {
        "id": 738115,
        "name": "7-Eleven",
        "description": "Convenience, Grocery, Snacks",
        "status": "30 mins",
        "delivery_fee": 750,
        "cover_img_url": "https://cdn.doordash.com/media/restaurant/cover/big.png"
    }
]
```

### Menu Endpoint

`GET https://dd-interview.github.io/android/v1/menu`

Returns a menu object containing items. This is a mock endpoint -- all stores use the same menu.

**Top-level fields:**

| Field | Type | Description |
| ----- | ---- | ----------- |
| `id` | String | Menu identifier |
| `name` | String | Menu name |
| `items` | Array | Array of menu items |

**Item fields:**

| Field | Type | Description |
| ----- | ---- | ----------- |
| `id` | String | Item identifier |
| `name` | String | Item name |
| `price_cents` | Int | Item price in cents |

**Example response:**

```json
{
    "id": "1",
    "name": "Morning Menu",
    "items": [
        {
            "id": "11",
            "name": "Pizza",
            "price_cents": 100
        },
        {
            "id": "12",
            "name": "Coke",
            "price_cents": 50
        }
    ]
}
```

## Technology

- Use SwiftUI or UIKit (your choice).
- Target iOS 17+.
- Do not use third-party libraries.
- No authorization token is needed for the API endpoints.

## Guidelines

1. Get your code working with good coding practices first. If you have more time, improve your codebase to be production-worthy.
2. Focus on the functionality of the app first rather than UI refinement.
3. Architecture and code organization matter. Your implementation should reflect thoughtful design decisions that would scale well in a production environment.
// Enter your code here. Read input from STDIN. Print output to STDOUT
