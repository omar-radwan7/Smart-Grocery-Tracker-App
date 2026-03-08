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
sign_i![Sign in](https://github.com/user-attachments/assets/bdfa7926-9f15-414e-bd1a-4e570d64840a) 
  Enter your email and password to access your account, or use "Continue with Google" to sign in. Tap "Sign Up" to create a new account.
  
  [signing in with google screen](https://github.com/user-attachments/assets/53f2c423-bef9-4390-8a39-69af744a141a)
Select a Google account to continue signing in with Google. Shows the account name and email and the option to add another account.

![Home page screen](https://github.com/user-attachments/assets/4458d58d-df1a-47c9-9e82-48f8a36941e5)
  Dashboard showing a greeting, a summary card with counts (Fresh / Expiring / Expired) and a progress indicator. Use category chips to filter items or the search icon to find items.

- home_grid![scroll items screen](https://github.com/user-attachments/assets/b97b6cdb-6d37-4a6b-b129-131f4c939889) 
  Scrollable grid of grocery item cards showing an image, name, category, expiry date, and quantity badge. Tap a card to view or edit the item.

- add_item_form![add item screen](https://github.com/user-attachments/assets/1c3c280d-528e-4d5a-a04f-43ee5fddcae6)
 (image5)  
  Form to add a new item: choose category and food name, set quantity, and pick an expiry date. Tap "Add Item" to save.

- date_picker![food expiry date screen](https://github.com/user-attachments/assets/271f8f3c-3a39-4df0-94af-35f1677e16d6)(image6)  
  Calendar modal for selecting an expiry date. Use "Cancel" to abort or "OK" to confirm the date.

- category_picker![food expiry date screen](https://github.com/user-attachments/assets/36ec7979-408b-45fe-b857-96fff884209a)
 (image7)  
  Dropdown showing available categories (Fruits, Vegetables, Dairy, Meat & Poultry, Seafood). Select one to scope food-name options and organize the item.

- edit_item![Edit item screen](https://github.com/user-attachments/assets/01bee60d-e9ef-4bc7-8cef-1bf9217ec626)
 (image8)  
  Pre-filled form to update item details. Use "Update Item" to save changes or "Delete Item" to remove the item.

- home_filtered_vegetables![Item filter screen](https://github.com/user-attachments/assets/325f0351-4ec5-4c43-ae5f-8bc2920c0f30)
 (image9)  
  Home view filtered by a category (example: Vegetables), showing only items that belong to the selected category.

- settings![user profile](https://github.com/user-attachments/assets/6cdc3dec-ebe2-44f5-b05c-becf65d6e86d)
 (image10)  
  Settings page with a profile card (editable avatar and name/email), account actions like change password and language preference, and a "Sign Out" button.

- create_account![sign up](https://github.com/user-attachments/assets/b71e9237-442a-44ad-a003-68c40f22d597)
 (image11)  
  Registration screen to enter full name, email, password and confirm password. Tap "Create Account" or continue with Google to register.

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
