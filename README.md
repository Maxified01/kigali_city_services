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

### 2. Firebase Configuration
Create a Firebase project at Firebase Console.

Enable Email/Password authentication.

Create a Firestore database in test mode (or use the rules below).

Register an Android app with package name com.example.kigali_city_services.

Download google-services.json and place it in android/app/.

Add SHA‑1 fingerprint of your debug keystore (see Firebase docs).

Enable Google Maps SDK for Android in Google Cloud Console and get an API key.

### 3. Add API Keys
In android/app/src/main/AndroidManifest.xml, add your Maps API key:

xml
<meta-data android:name="com.google.android.geo.API_KEY"
           android:value="YOUR_API_KEY_HERE"/>
### 4. Run the App
bash
flutter pub get
flutter run
### 5. Firestore Security Rules (for development)
javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /listings/{listing} {
      allow read: if true;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null 
                            && request.auth.uid == resource.data.createdBy;
    }
  }
}
Built With
Flutter

Firebase Auth & Firestore

Google Maps Flutter

Riverpod

url_launcher

Author
Emoh Anthony Chinedu
