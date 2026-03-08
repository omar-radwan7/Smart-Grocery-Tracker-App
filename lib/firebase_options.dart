import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default Firebase configuration options for each platform.
///
/// These values were extracted from google-services.json (Android)
/// and the Firebase Console (Web).
///
/// To regenerate, you can use the FlutterFire CLI:
///   flutterfire configure
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.linux:
        return web; // Use web config for Linux desktop
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // Android configuration
  static FirebaseOptions get android => FirebaseOptions(
        apiKey: 'AIzaSyC1qcwmUx324IhpFpJpUoBIuLr3dzBSp3I',
        appId: '1:108972889957:android:978ca03508b41025c9738c',
        messagingSenderId: '108972889957',
        projectId: 'smart-grocery-tracker-c0424',
        storageBucket: 'smart-grocery-tracker-c0424.firebasestorage.app',
      );

  // Web configuration
  static FirebaseOptions get web => FirebaseOptions(
        apiKey: 'AIzaSyC1qcwmUx324IhpFpJpUoBIuLr3dzBSp3I',
        appId: '1:108972889957:android:978ca03508b41025c9738c',
        messagingSenderId: '108972889957',
        projectId: 'smart-grocery-tracker-c0424',
        storageBucket: 'smart-grocery-tracker-c0424.firebasestorage.app',
        authDomain: 'smart-grocery-tracker-c0424.firebaseapp.com',
      );

  // iOS configuration
  static FirebaseOptions get ios => FirebaseOptions(
        apiKey: 'AIzaSyC1qcwmUx324IhpFpJpUoBIuLr3dzBSp3I',
        appId: '1:108972889957:android:978ca03508b41025c9738c',
        messagingSenderId: '108972889957',
        projectId: 'smart-grocery-tracker-c0424',
        storageBucket: 'smart-grocery-tracker-c0424.firebasestorage.app',
        iosBundleId: 'com.smartgrocery.smartGroceryTracker',
      );
}
