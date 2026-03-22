# Smart Grocery Tracker

A cross-platform Flutter mobile application for tracking grocery items and their expiration dates. The app helps users reduce food waste through visual expiry warnings, smart categorization, and a clean, intuitive interface.

---

## Overview

Managing groceries and avoiding food waste is a daily challenge. Smart Grocery Tracker solves this by giving users a clear, visual overview of everything in their fridge and pantry — with color-coded expiry indicators, category filtering, and real-time Firestore sync across devices.

---

## Features

- **Firebase Authentication** — Email/Password and Google Sign-In
- **Expiry Tracking** — Visual indicators for Fresh, Expiring Soon, and Expired items
- **Full CRUD** — Add, edit, and delete grocery items with image support
- **Category Filtering** — Filter by Fruits, Vegetables, Dairy, and more
- **Search** — Quickly find items by name
- **Image Upload** — Attach photos to grocery items via camera or gallery
- **Activity Logging** — Every add, edit, and delete is recorded in the user's activity history
- **Responsive UI** — Clean Material Design interface optimized for mobile

---

## Screenshots

| Sign In | Dashboard | Grocery Grid |
|--------|-----------|--------------|
| ![Sign in](https://github.com/user-attachments/assets/05ec6707-a4aa-4ad9-9bb4-141b4254f124) | ![Dashboard](https://github.com/user-attachments/assets/11962f0f-a801-4d72-8f2d-50240a85db3d) | ![Grid](https://github.com/user-attachments/assets/f2adb803-bb5a-4ef8-aba8-d31958dbd079) |

| Add Item | Edit Item | Profile |
|----------|-----------|---------|
| ![Add](https://github.com/user-attachments/assets/9739642c-2ab0-4895-93c0-858dd50a420a) | ![Edit](https://github.com/user-attachments/assets/749115f5-2bfd-4c38-b431-b49eaaf86d4a) | ![Profile](https://github.com/user-attachments/assets/24d41fc5-7cda-4f6c-bd19-d08b8de24af7) |

---

## Architecture

The project follows a scalable **MVVM-inspired architecture** using the Provider package for state management, with clearly separated layers for models, services, providers, and UI.

```
lib/
├── app/
│   ├── models/           # Data structures (FoodItem, User, Activity)
│   ├── providers/        # State management (AuthProvider, FoodProvider)
│   ├── screens/          # Feature-based UI modules
│   │   ├── auth/         # Sign in, Sign up screens
│   │   ├── dashboard/    # Home dashboard
│   │   ├── add_food/     # Add and edit item screens
│   │   └── settings/     # Profile and preferences
│   ├── services/         # Firebase communication layer
│   │   ├── AuthService
│   │   ├── FirestoreService
│   │   ├── StorageService
│   │   └── ActivityService
│   └── widgets/          # Reusable UI components
│       ├── FoodCard
│       ├── ExpiryBadge
│       └── CategoryFilterBar
└── utils/                # Constants, theme, expiry calculations
```

---

## Tech Stack

| Layer | Technology |
|-------|------------|
| Framework | Flutter (Dart) |
| Authentication | Firebase Auth |
| Database | Cloud Firestore |
| Storage | Firebase Storage |
| State Management | Provider |
| Image Handling | image_picker, cached_network_image |
| Date Formatting | intl |

---

## Dependencies

```yaml
firebase_core: Firebase initialization
firebase_auth: Authentication system
google_sign_in: Google login integration
cloud_firestore: NoSQL real-time database
firebase_storage: File and image storage
provider: State management
intl: Date formatting
image_picker: Camera and gallery access
cached_network_image: Efficient image caching
uuid: Unique ID generation
```

---

## Getting Started

### Prerequisites

- Flutter SDK 3.9.0+
- Android Studio or Xcode
- A Firebase project

### 1. Clone the Repository

```bash
git clone https://github.com/omar-radwan7/Smart-Grocery-Tracker-App.git
cd Smart-Grocery-Tracker-App
```

### 2. Firebase Setup

1. Create a project in the [Firebase Console](https://console.firebase.google.com)
2. Enable Authentication:
   - Email/Password
   - Google Sign-In
3. Create a Firestore database
4. Enable Firebase Storage
5. Add an Android app with package name: `com.smartgrocery.smart_grocery_tracker`
6. Download `google-services.json` and place it in `android/app/`

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Run the App

```bash
flutter run
```

---

## Firestore Data Structure

```
users/
  {userId}/
    name: string
    email: string
    createdAt: timestamp

    groceryItems/
      {itemId}/
        name: string
        category: string
        quantity: number
        expiryDate: timestamp
        imageUrl: string
        status: "fresh" | "expiring" | "expired"
        createdAt: timestamp

    activityLog/
      {activityId}/
        action: "added" | "edited" | "deleted"
        itemName: string
        timestamp: timestamp
```

---

## Expiry Status Logic

| Status | Condition |
|--------|-----------|
| 🟢 Fresh | Expiry date > 3 days away |
| 🟡 Expiring Soon | Expiry date within 3 days |
| 🔴 Expired | Expiry date has passed |

---

## Test Scenarios

To quickly test all expiry states after setup:

| Item | Expiry |
|------|--------|
| Fresh Milk | Today + 10 days |
| Yogurt | Today + 2 days |
| Old Bread | Yesterday |

---

## License

MIT License
