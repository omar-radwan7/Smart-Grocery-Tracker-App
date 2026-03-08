Smart Grocery Tracker

A Flutter mobile app that helps you track food items and their expiry dates. Get visual warnings for items about to expire so you never waste food again.

Features

- Firebase Authentication (Email/Password + Google Sign-In)
- Dashboard (View all food items with real-time expiry status)
- Add / Edit / Delete food items with name, category, quantity, and expiry date
- Expiry Warnings (Color-coded badges: Fresh, Expiring Soon, Expired)
- Search & Filter (Filter by category or search by name)
- Settings (Profile, change email/password, language selection EN/DE)
- Swipe to Delete (Swipe food cards to remove items)
- Responsive (Adapts to all screen sizes)
- Photo Upload, Activity Logging & Stats Tracking

Screenshots

(Insert links to screenshots here)

Architecture

The app uses a scalable MVVM-like architecture using the Provider package for state management. 
- Models: Data representations (e.g., FoodItem).
- Services: Handles interactions with Firebase (AuthService, FirestoreService, StorageService, ActivityService).
- Providers: Maintains the application state, caching data from services and exposing it to the UI (AuthProvider, FoodProvider).
- Screens: Feature-based UI pages (auth, dashboard, add_food, settings).
- Widgets: Reusable UI components (FoodCard, ExpiryBadge).
- Utils: Helpers such as constants, date formatters, and theme definitions.

Packages Used

- firebase_core: Firebase initialization
- firebase_auth: Email/Password and Google authentication
- google_sign_in: Google OAuth provider
- cloud_firestore: Real-time NoSQL database for saving food items and user activity
- firebase_storage: Cloud storage for user uploaded photos
- provider: Main state management solution
- intl: Date and time formatting
- image_picker: Camera and gallery access for food photos
- cached_network_image: Efficient loading and caching of images from Firebase Storage
- uuid: Unique identifier generation for uploaded images

Project Structure

lib/
- main.dart (App entry, Firebase init)
- app.dart (App shell + bottom nav bar)
- models/
  - food_item.dart (FoodItem model + Firestore serialization)
- services/
  - activity_service.dart
  - auth_service.dart
  - firestore_service.dart
  - storage_service.dart
- providers/
  - auth_provider.dart
  - food_provider.dart
- screens/
  - add_food/, auth/, dashboard/, settings/
- widgets/
  - category_filter_bar.dart, expiry_badge.dart, food_card.dart
- utils/
  - app_theme.dart, constants.dart, expiry_helper.dart

Setup Instructions

Prerequisites:
- Flutter SDK 3.9.0 or higher
- Firebase CLI
- Android Studio or Xcode
- A Firebase project

1. Clone the Repository
git clone <repository-url>
cd smart_grocery_tracker

2. Firebase Setup
Go to Firebase Console and create a new project.
Enable Authentication (Email/Password and Google).
Create Firestore Database in test mode.
Create Firebase Storage bucket.
Add an Android App (package name: com.smartgrocery.smart_grocery_tracker) and place the google-services.json file inside android/app/.

3. Firestore Security Rules
Ensure your Firestore rules allow per-user item/activity reads and writes, matching users/{userId}/food_items/{itemId} and users/{userId}/activity_logs/{logId}. A reference file named firestore.rules is included in the project root.

4. Install Dependencies
Run the command: flutter pub get

5. Run the App
Run the command: flutter run

6. Run using Docker (No Flutter/Dependencies Required)
To run the app on any system without installing Flutter, Dart, or project dependencies, use Docker:

run command: docker-compose up --build

Then open http://localhost:8085 in your web browser. This will build the Flutter Web app inside an isolated container and serve it automatically.

Test Scenarios

To verify all expiry states without waiting:
- Fresh Milk: Today + 10 days (Fresh)
- Yogurt: Today + 2 days (Expiring Soon)
- Old Bread: Yesterday (Expired)

License
MIT License
