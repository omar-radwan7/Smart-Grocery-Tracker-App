# 🥬 Smart Grocery Tracker

A Flutter mobile app that helps you track food items and their expiry dates. Get visual warnings for items about to expire so you never waste food again.

## Features

- **Firebase Authentication** — Email/Password + Google Sign-In
- **Dashboard** — View all food items with real-time expiry status
- **Add / Edit / Delete** food items with name, category, quantity, and expiry date
- **Expiry Warnings** — Color-coded badges:
  - 🟢 **Fresh** — expires in more than 3 days
  - 🟡 **Expiring Soon** — expires within 3 days
  - 🔴 **Expired** — already past expiry date
- **Search & Filter** — Filter by category or search by name
- **Settings** — Profile, change email/password, language selection (EN/DE)
- **Swipe to Delete** — Swipe food cards to remove items
- **Responsive** — Adapts to all screen sizes (phones & tablets)

## Architecture

```
lib/
├── main.dart                        # App entry, Firebase init
├── app.dart                         # App shell + bottom nav bar
├── models/
│   └── food_item.dart               # FoodItem model + Firestore serialization
├── services/
│   ├── auth_service.dart            # Firebase Auth wrapper
│   └── firestore_service.dart       # Firestore CRUD operations
├── providers/
│   ├── auth_provider.dart           # Auth state management
│   └── food_provider.dart           # Food items state + filtering
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── signup_screen.dart
│   ├── dashboard/
│   │   └── dashboard_screen.dart
│   ├── add_food/
│   │   └── add_food_screen.dart
│   └── settings/
│       └── settings_screen.dart
├── widgets/
│   ├── food_card.dart               # Food item card with expiry badge
│   ├── expiry_badge.dart            # Status badge widget
│   └── category_filter_bar.dart     # Horizontal category chips
└── utils/
    ├── app_theme.dart               # Theme (white + dark green)
    ├── constants.dart               # Categories, thresholds
    └── expiry_helper.dart           # Expiry status calculation
```

## Packages Used

| Package | Purpose |
|---------|---------|
| `firebase_core` | Firebase initialization |
| `firebase_auth` | Email/Password + Google authentication |
| `google_sign_in` | Google OAuth provider |
| `cloud_firestore` | Real-time NoSQL database |
| `provider` | State management (ChangeNotifier) |
| `intl` | Date formatting |
| `image_picker` | Camera / gallery access (bonus) |
| `uuid` | Unique ID generation |

## Setup Instructions

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (^3.9.0)
- [Firebase CLI](https://firebase.google.com/docs/cli)
- Android Studio / Xcode
- A Firebase project

### 1. Clone the Repository

```bash
git clone <repository-url>
cd smart_grocery_tracker
```

### 2. Firebase Setup

1. Go to [Firebase Console](https://console.firebase.google.com/) and create a new project
2. **Enable Authentication**:
   - Go to Authentication → Sign-in method
   - Enable **Email/Password**
   - Enable **Google** (add your SHA-1 fingerprint for Android)
3. **Create Firestore Database**:
   - Go to Firestore Database → Create database
   - Start in **test mode** for development
4. **Add Android App**:
   - Register with package name: `com.smartgrocery.smart_grocery_tracker`
   - Download `google-services.json`
   - Place it in `android/app/google-services.json`
5. **Add iOS App** (optional):
   - Register with bundle ID: `com.smartgrocery.smartGroceryTracker`
   - Download `GoogleService-Info.plist`
   - Place it in `ios/Runner/GoogleService-Info.plist`

### 3. Firestore Security Rules

Deploy these rules in your Firebase Console → Firestore → Rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/food_items/{itemId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### 4. Install Dependencies

```bash
flutter pub get
```

### 5. Run the App

```bash
flutter run
```

## Test Scenarios

To verify all expiry states without waiting:

| Item | Expiry Date | Expected Badge |
|------|-------------|----------------|
| Fresh Milk | Today + 10 days | 🟢 Fresh |
| Yogurt | Today + 2 days | 🟡 Expiring Soon |
| Old Bread | Yesterday | 🔴 Expired |

## Design Decisions

- **White + Dark Green** color palette for a clean, organic feel
- **Material Design 3** for modern component styling
- **Provider** for simple, testable state management
- **Per-user Firestore** paths (`/users/{uid}/food_items/`) for data isolation
- **Responsive layout** using `MediaQuery` and flexible widgets
- All expiry calculations use `DateTime.now()` dynamically — no hardcoded dates

## License

MIT License
