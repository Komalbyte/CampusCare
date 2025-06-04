// Firebase configuration file
// This file should be updated after creating Firebase project

class FirebaseConfig {
  static const bool useEmulator = false; // Set to true for local testing
  
  // Android configuration (from google-services.json)
  static const String androidApiKey = 'YOUR_ANDROID_API_KEY';
  static const String androidAppId = 'YOUR_ANDROID_APP_ID';
  static const String androidMessagingSenderId = 'YOUR_MESSAGING_SENDER_ID';
  static const String androidProjectId = 'YOUR_PROJECT_ID';
  
  // iOS configuration (from GoogleService-Info.plist)
  static const String iosApiKey = 'YOUR_IOS_API_KEY';
  static const String iosAppId = 'YOUR_IOS_APP_ID';
  static const String iosMessagingSenderId = 'YOUR_MESSAGING_SENDER_ID';
  static const String iosProjectId = 'YOUR_PROJECT_ID';
  
  // Common configuration
  static const String projectId = 'campuscare-sharda';
  static const String storageBucket = 'campuscare-sharda.appspot.com';
  static const String authDomain = 'campuscare-sharda.firebaseapp.com';
  
  // Emulator configuration (for development)
  static const String emulatorHost = 'localhost';
  static const int authEmulatorPort = 9099;
  static const int firestoreEmulatorPort = 8080;
  static const int storageEmulatorPort = 9199;
}
