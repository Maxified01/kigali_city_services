# Kigali City Services Directory

A Flutter mobile app that helps Kigali residents locate and navigate to public services, cafés, restaurants, hospitals, and tourist attractions. Built with **Firebase Authentication**, **Cloud Firestore**, **Google Maps**, and **Riverpod** for state management.

## Features

- **Email/Password Authentication** with email verification.
- **CRUD Listings** – Create, read, update, delete service/place entries.
- **Search & Filter** – Search by name and filter by category.
- **Map Integration** – View all listings on a map; tap markers for details.
- **Directions** – Launch Google Maps for turn‑by‑turn navigation.
- **My Listings** – Manage only your own listings.
- **Settings** – View profile and toggle notifications (simulated).
- **Rwanda Flag Theme** – Blue, yellow, and green color scheme.

## Firestore Structure

### `users` Collection
| Field       | Type      | Description                     |
|-------------|-----------|---------------------------------|
| `uid`       | string    | Firebase Auth UID (document ID) |
| `email`     | string    | User’s email                    |
| `name`      | string    | Display name                    |
| `createdAt` | timestamp | Profile creation time           |

### `listings` Collection (auto‑generated document IDs)
| Field         | Type      | Description                          |
|---------------|-----------|--------------------------------------|
| `name`        | string    | Place/service name                   |
| `category`    | string    | e.g., Café, Hospital, Restaurant     |
| `address`     | string    | Physical address                     |
| `phone`       | string    | Contact number                       |
| `description` | string    | Optional details                     |
| `latitude`    | double    | Geographic latitude                  |
| `longitude`   | double    | Geographic longitude                 |
| `createdBy`   | string    | UID of the user who created it       |
| `createdAt`   | timestamp | When the listing was added           |

## State Management (Riverpod)

- **`authStateProvider`** – Stream of Firebase User.
- **`allListingsStreamProvider`** – Real‑time stream of all listings.
- **`filteredListingsProvider`** – Combines search query and category filters.
- **`myListingsProvider`** – Filters listings by current user’s UID.
- **`selectedCategoryProvider`** – Holds the active category filter.

All data flows from `FirestoreService` → providers → UI widgets, ensuring a clean separation.

## Setup Instructions

### 1. Clone the Repository
```bash
git clone https://github.com/yourusername/kigali-city-services.git
cd kigali-city-services
flutter run