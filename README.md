Smart Grocery Tracker

A Flutter mobile application for tracking grocery items and their expiration dates.
The app helps users avoid food waste by providing visual expiry warnings and simple grocery management tools.

Features

Firebase Authentication (Email/Password + Google Sign-In)

Expiry tracking with visual indicators (Fresh / Expiring / Expired)

Add, edit, and delete grocery items

Category filtering and search

Image upload for grocery items

Activity logging for user actions

Responsive mobile UI

Screenshots
Sign In
![Sign in](https://github.com/user-attachments/assets/05ec6707-a4aa-4ad9-9bb4-141b4254f124)

Users log in with email/password or Google authentication. Successful login starts a user session and loads the personal grocery dashboard.

Google Sign In
![signing in with google screen](https://github.com/user-attachments/assets/e7849176-a450-49f0-9fd6-af80f652413c)

Users select a Google account to authenticate. This action creates or links a user account in Firebase Authentication.

Create Account
![sign up](https://github.com/user-attachments/assets/e68324e0-81d9-4301-87c3-86eebd50f17e)

New users register with name, email, and password. Account creation initializes the user's Firestore data structure.

Dashboard
![Home page screen](https://github.com/user-attachments/assets/11962f0f-a801-4d72-8f2d-50240a85db3d)

The dashboard shows grocery statistics and expiry summaries. Users can search, filter, or navigate to manage items.

Grocery Items Grid
![scroll items screen](https://github.com/user-attachments/assets/f2adb803-bb5a-4ef8-aba8-d31958dbd079)

Displays grocery cards with images, quantities, and expiry dates. Users can tap items to edit them or swipe to delete.

Category Filter
![Item filter screen](https://github.com/user-attachments/assets/ad688df3-2fc6-4b87-8917-c6b036219446)

Users filter groceries by category such as Fruits, Vegetables, or Dairy to quickly find specific items.

Add Item
![add item screen](https://github.com/user-attachments/assets/9739642c-2ab0-4895-93c0-858dd50a420a)

Users add a new grocery item by selecting a category, setting quantity, choosing an expiry date, and optionally uploading a photo.

Each creation action is logged in the activity history.

Edit Item
![Edit item screen](https://github.com/user-attachments/assets/749115f5-2bfd-4c38-b431-b49eaaf86d4a)

Users update item details or delete an item. Edits and deletions are recorded as user activity even

Settings
User Profile
![user profile](https://github.com/user-attachments/assets/24d41fc5-7cda-4f6c-bd19-d08b8de24af7)

Manage profile information, password, language preferences, and sign out.
rchitecture

The project follows a scalable MVVM-inspired architecture using the Provider package for state management.

Models
Data structures representing application entities.

Example:
FoodItem

Services
Responsible for communicating with Firebase services.

AuthService
FirestoreService
StorageService
ActivityService

Providers
Manage application state and expose data to the UI.

AuthProvider
FoodProvider

Screens
Feature-based UI modules:

auth
dashboard
add_food
settings

Widgets
Reusable UI components such as:

FoodCard
ExpiryBadge
CategoryFilterBar

Utils
Shared helpers including:

constants
theme
expiry calculations

Packages Used

firebase_core – Firebase initialization
firebase_auth – Authentication system
google_sign_in – Google login integration
cloud_firestore – NoSQL database
firebase_storage – File and image storage
provider – State management
intl – Date formatting
image_picker – Image selection from camera/gallery
cached_network_image – Efficient image caching
uuid – Unique ID generation

Project Structure
lib/
 ├── main.dart
 ├── app.dart
 ├── models/
 │   └── food_item.dart
 ├── services/
 │   ├── activity_service.dart
 │   ├── auth_service.dart
 │   ├── firestore_service.dart
 │   └── storage_service.dart
 ├── providers/
 │   ├── auth_provider.dart
 │   └── food_provider.dart
 ├── screens/
 │   ├── auth/
 │   ├── dashboard/
 │   ├── add_food/
 │   └── settings/
 ├── widgets/
 │   ├── food_card.dart
 │   ├── expiry_badge.dart
 │   └── category_filter_bar.dart
 └── utils/
     ├── constants.dart
     ├── expiry_helper.dart
     └── app_theme.dart
     
Setup Instructions
Prerequisites

Flutter SDK 3.9.0+
Android Studio or Xcode
Firebase project

1 Clone Repository
git clone https://github.com/omar-radwan7/Smart-Grocery-Tracker-App.git
cd Smart-Grocery-Tracker-App
2 Firebase Setup

Create a project in the Firebase Console.

Enable Authentication:

Email/Password

Google Sign-In

Create a Firestore database.

Enable Firebase Storage.

Add an Android application with package name:

com.smartgrocery.smart_grocery_tracker

Download google-services.json and place it inside:

android/app/
3 Install Dependencies
flutter pub get
4 Run the App
flutter run
Optional: Run with Docker

Run the application without installing Flutter:

docker-compose up --build

Then open:

http://localhost:8085
Test Scenarios

To quickly test expiry states:

Fresh Milk
Expiry: Today + 10 days

Yogurt
Expiry: Today + 2 days

Old Bread
Expiry: Yesterday

License

MIT License
