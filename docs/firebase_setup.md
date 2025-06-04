# Firebase Setup Guide for CampusCare

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add Project"
3. Enter project name: **CampusCare-Sharda**
4. Disable Google Analytics (optional for development)
5. Click "Create Project"

---

## Step 2: Enable Authentication

1. In Firebase Console, go to **Authentication** → **Sign-in method**
2. Enable the following providers:
   - ✅ **Email/Password** (Required)
   - ✅ **Google** (Optional, recommended)

---

## Step 3: Create Firestore Database

1. Go to **Firestore Database** → **Create database**
2. Select **Start in test mode** (we'll add security rules later)
3. Choose location: **asia-south1 (Mumbai)** (closest to India)
4. Click "Enable"

---

## Step 4: Setup Cloud Storage

1. Go to **Storage** → **Get Started**
2. Start in **test mode**
3. Choose same location: **asia-south1**
4. Click "Done"

---

## Step 5: Setup Cloud Messaging (FCM)

1. Go to **Cloud Messaging**
2. Note down your **Server Key** (for sending notifications)

---

## Step 6: Add Android App

### 6.1 Register App
1. Click on Android icon in Project Overview
2. Enter Android package name: `com.sharda.campuscare`
3. App nickname: `CampusCare Student App`
4. Click "Register app"

### 6.2 Download google-services.json
1. Download `google-services.json`
2. Save it to: `student_app/android/app/google-services.json`

### 6.3 Add Firebase SDK
Firebase will provide gradle configuration. We'll add it when setting up the Flutter project.

---

## Step 7: Add Web App (for Admin Dashboard)

### 7.1 Register Web App
1. Click on Web icon `</>`
2. App nickname: `CampusCare Admin Dashboard`
3. Check "Also setup Firebase Hosting"
4. Click "Register app"

### 7.2 Copy Firebase Config
You'll get a config object like this:

```javascript
const firebaseConfig = {
  apiKey: "AIza...",
  authDomain: "campuscare-sharda.firebaseapp.com",
  projectId: "campuscare-sharda",
  storageBucket: "campuscare-sharda.appspot.com",
  messagingSenderId: "123456789",
  appId: "1:123456789:web:abcdef"
};
```

### 7.3 Save Configuration
Create `admin_dashboard/src/config/firebase.config.js` with this configuration.

---

## Step 8: Firestore Security Rules

Go to **Firestore Database** → **Rules** and paste the following:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Helper functions
    function isAuthenticated() {
      return request.auth != null;
    }
    
    function isOwner(userId) {
      return isAuthenticated() && request.auth.uid == userId;
    }
    
    function isAdmin() {
      return isAuthenticated() && 
             exists(/databases/$(database)/documents/admin/$(request.auth.uid));
    }
    
    // Users collection
    match /users/{userId} {
      allow read: if isAuthenticated();
      allow create: if isAuthenticated();
      allow update: if isOwner(userId) || isAdmin();
      allow delete: if isAdmin();
    }
    
    // Complaints collection
    match /complaints/{complaintId} {
      allow read: if isAuthenticated();
      allow create: if isAuthenticated();
      allow update: if isOwner(resource.data.userId) || isAdmin();
      allow delete: if isAdmin();
    }
    
    // Feedback collection
    match /feedback/{feedbackId} {
      allow read: if isAuthenticated();
      allow create: if isAuthenticated();
      allow update: if isOwner(resource.data.userId);
      allow delete: if isAdmin();
    }
    
    // Departments collection
    match /departments/{departmentId} {
      allow read: if isAuthenticated();
      allow write: if isAdmin();
    }
    
    // Admin collection
    match /admin/{adminId} {
      allow read: if isAdmin();
      allow write: if false; // Only through Firebase Console
    }
    
    // Notifications collection
    match /notifications/{notificationId} {
      allow read: if isOwner(resource.data.userId);
      allow create: if isAdmin();
      allow update: if isOwner(resource.data.userId); // Mark as read
      allow delete: if isOwner(resource.data.userId) || isAdmin();
    }
    
    // Analytics collection
    match /analytics/{analyticsId} {
      allow read: if isAuthenticated();
      allow write: if false; // Only through Cloud Functions
    }
    
    // Chat messages collection
    match /chat_messages/{messageId} {
      allow read: if isAuthenticated();
      allow create: if isAuthenticated();
      allow update: if isOwner(resource.data.senderId);
      allow delete: if isAdmin();
    }
    
    // App settings
    match /app_settings/{settingId} {
      allow read: if isAuthenticated();
      allow write: if isAdmin();
    }
  }
}
```

Click **Publish**

---

## Step 9: Storage Security Rules

Go to **Storage** → **Rules** and paste:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    
    // Complaint images
    match /complaints/{complaintId}/{imageFile} {
      allow read: if request.auth != null;
      allow write: if request.auth != null 
                   && request.resource.size < 5 * 1024 * 1024  // Max 5MB
                   && request.resource.contentType.matches('image/.*');
    }
    
    // Profile pictures
    match /profiles/{userId}/{imageFile} {
      allow read: if request.auth != null;
      allow write: if request.auth != null 
                   && request.auth.uid == userId
                   && request.resource.size < 2 * 1024 * 1024  // Max 2MB
                   && request.resource.contentType.matches('image/.*');
    }
    
    // Report exports (admin only)
    match /reports/{reportFile} {
      allow read: if request.auth != null;
      allow write: if false; // Only through Cloud Functions
    }
  }
}
```

Click **Publish**

---

## Step 10: Create Initial Admin User

1. Go to **Authentication** → **Users** → **Add user**
2. Email: Your admin email (e.g., `admin@sharda.ac.in`)
3. Password: Create a secure password
4. Click "Add user"
5. Copy the User UID

6. Go to **Firestore Database** → **Start collection**
   - Collection ID: `admin`
   - Document ID: (paste the User UID)
   - Fields:
     ```
     userId: <same User UID>
     permissions: ["view_all", "assign", "resolve", "delete", "manage_users"]
     departmentId: null
     assignedComplaints: []
     createdAt: <current timestamp>
     lastActive: <current timestamp>
     ```

7. Create user profile in `users` collection:
   - Document ID: (paste the User UID)
   - Fields:
     ```
     userId: <User UID>
     email: "admin@sharda.ac.in"
     name: "Admin User"
     phoneNumber: "+911234567890"
     rollNumber: null
     department: "IT"
     year: null
     hostelBlock: null
     roomNumber: null
     role: "admin"
     profilePicUrl: null
     createdAt: <current timestamp>
     lastLogin: <current timestamp>
     isActive: true
     fcmToken: null
     ```

---

## Step 11: Create Department Documents

Go to Firestore and create `departments` collection with these documents:

### Document 1: DEPT_TRANSPORT
```javascript
{
  departmentId: "DEPT_TRANSPORT",
  name: "Transport Department",
  headName: "Mr. Rajesh Kumar",
  email: "transport@sharda.ac.in",
  phoneNumber: "+911234567891",
  categories: ["transport"],
  activeComplaints: 0,
  resolvedComplaints: 0,
  avgResolutionTime: 0,
  createdAt: <timestamp>,
  isActive: true
}
```

### Document 2: DEPT_HOSTEL
```javascript
{
  departmentId: "DEPT_HOSTEL",
  name: "Hostel Management",
  headName: "Ms. Priya Sharma",
  email: "hostel@sharda.ac.in",
  phoneNumber: "+911234567892",
  categories: ["hostel", "laundry"],
  activeComplaints: 0,
  resolvedComplaints: 0,
  avgResolutionTime: 0,
  createdAt: <timestamp>,
  isActive: true
}
```

### Document 3: DEPT_MESS
```javascript
{
  departmentId: "DEPT_MESS",
  name: "Mess & Cafeteria",
  headName: "Mr. Amit Singh",
  email: "mess@sharda.ac.in",
  phoneNumber: "+911234567893",
  categories: ["mess"],
  activeComplaints: 0,
  resolvedComplaints: 0,
  avgResolutionTime: 0,
  createdAt: <timestamp>,
  isActive: true
}
```

### Document 4: DEPT_INFRASTRUCTURE
```javascript
{
  departmentId: "DEPT_INFRASTRUCTURE",
  name: "Infrastructure & Maintenance",
  headName: "Mr. Vijay Verma",
  email: "infrastructure@sharda.ac.in",
  phoneNumber: "+911234567894",
  categories: ["infrastructure"],
  activeComplaints: 0,
  resolvedComplaints: 0,
  avgResolutionTime: 0,
  createdAt: <timestamp>,
  isActive: true
}
```

### Document 5: DEPT_ACADEMIC
```javascript
{
  departmentId: "DEPT_ACADEMIC",
  name: "Academic Affairs",
  headName: "Dr. Sunita Gupta",
  email: "academic@sharda.ac.in",
  phoneNumber: "+911234567895",
  categories: ["academic"],
  activeComplaints: 0,
  resolvedComplaints: 0,
  avgResolutionTime: 0,
  createdAt: <timestamp>,
  isActive: true
}
```

---

## Step 12: Setup Indexes

Create composite indexes for better query performance:

1. Go to **Firestore Database** → **Indexes** → **Composite**
2. Click "Add Index" for each:

### Index 1
- Collection: `complaints`
- Fields: `userId` (Ascending), `createdAt` (Descending)

### Index 2
- Collection: `complaints`
- Fields: `status` (Ascending), `createdAt` (Descending)

### Index 3
- Collection: `complaints`
- Fields: `category` (Ascending), `status` (Ascending)

### Index 4
- Collection: `complaints`
- Fields: `assignedTo` (Ascending), `status` (Ascending)

### Index 5
- Collection: `notifications`
- Fields: `userId` (Ascending), `createdAt` (Descending)

### Index 6
- Collection: `chat_messages`
- Fields: `complaintId` (Ascending), `timestamp` (Ascending)

---

## Step 13: Save Configuration Files

### For Flutter App
Create `student_app/lib/core/constants/firebase_constants.dart`:

```dart
class FirebaseConstants {
  // These will be auto-loaded from google-services.json
  static const String androidPackageName = 'com.sharda.campuscare';
  
  // Collections
  static const String usersCollection = 'users';
  static const String complaintsCollection = 'complaints';
  static const String feedbackCollection = 'feedback';
  static const String departmentsCollection = 'departments';
  static const String adminCollection = 'admin';
  static const String notificationsCollection = 'notifications';
  static const String analyticsCollection = 'analytics';
  static const String chatMessagesCollection = 'chat_messages';
  static const String appSettingsCollection = 'app_settings';
  
  // Storage paths
  static const String complaintsImagesPath = 'complaints';
  static const String profilePicturesPath = 'profiles';
  static const String reportsPath = 'reports';
}
```

### For React Admin Dashboard
Create `admin_dashboard/src/config/firebase.config.js`:

```javascript
// TODO: Replace with your actual Firebase config from Firebase Console
export const firebaseConfig = {
  apiKey: "YOUR_API_KEY",
  authDomain: "campuscare-sharda.firebaseapp.com",
  projectId: "campuscare-sharda",
  storageBucket: "campuscare-sharda.appspot.com",
  messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
  appId: "YOUR_APP_ID"
};

// Collection names
export const COLLECTIONS = {
  USERS: 'users',
  COMPLAINTS: 'complaints',
  FEEDBACK: 'feedback',
  DEPARTMENTS: 'departments',
  ADMIN: 'admin',
  NOTIFICATIONS: 'notifications',
  ANALYTICS: 'analytics',
  CHAT_MESSAGES: 'chat_messages',
  APP_SETTINGS: 'app_settings'
};

// Storage paths
export const STORAGE_PATHS = {
  COMPLAINTS: 'complaints',
  PROFILES: 'profiles',
  REPORTS: 'reports'
};
```

---

## ✅ Firebase Setup Complete!

You now have:
- ✅ Firebase project created
- ✅ Authentication enabled
- ✅ Firestore database setup
- ✅ Cloud Storage configured
- ✅ Security rules in place
- ✅ Initial admin user created
- ✅ Department documents created
- ✅ Indexes configured

**Next Steps:**
1. Download `google-services.json` for Android app
2. Copy Firebase web config for React app
3. Continue with Flutter app development
