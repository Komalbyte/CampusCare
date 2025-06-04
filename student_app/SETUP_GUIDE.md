# Flutter Student App - Manual Setup Guide

## Why Manual Setup?

Since Flutter is not currently in your PATH, I'll provide you with:
1. Complete project structure
2. All necessary files and code
3. Commands to run once Flutter is available

---

## Step 1: Add Flutter to PATH

### Option A: Find existing Flutter installation
```bash
# Search for Flutter
find ~ -name "flutter" -type d 2>/dev/null | grep -E "flutter/bin$"
```

If found, add to PATH in `~/.zshrc`:
```bash
export PATH="$PATH:/path/to/flutter/bin"
```

### Option B: Install Flutter SDK
```bash
# Download Flutter
cd ~
git clone https://github.com/flutter/flutter.git -b stable

# Add to PATH
echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.zshrc
source ~/.zshrc

# Verify installation
flutter doctor
```

---

## Step 2: Create Flutter Project

Once Flutter is in PATH, run:

```bash
cd /Users/roshan/Projects/CampusCare

# Create Flutter project
flutter create --org com.sharda --project-name campus_care student_app

# Navigate to project
cd student_app
```

---

## Step 3: Update pubspec.yaml

Replace the dependencies section in `student_app/pubspec.yaml`:

```yaml
name: campus_care
description: CampusCare - Unified College Feedback & Complaint System for Sharda University
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter

  # Firebase
  firebase_core: ^2.24.2
  firebase_auth: ^4.15.3
  cloud_firestore: ^4.13.6
  firebase_storage: ^11.5.6
  firebase_messaging: ^14.7.9

  # State Management
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5

  # Dependency Injection
  get_it: ^7.6.4

  # UI & Design
  cupertino_icons: ^1.0.2
  google_fonts: ^6.1.0
  flutter_svg: ^2.0.9
  cached_network_image: ^3.3.0
  shimmer: ^3.0.0
  lottie: ^2.7.0

  # Image Handling
  image_picker: ^1.0.5
  image_cropper: ^5.0.0

  # Utilities
  intl: ^0.18.1
  url_launcher: ^6.2.1
  connectivity_plus: ^5.0.1
  shared_preferences: ^2.2.2
  path_provider: ^2.1.1

  # Network
  http: ^1.1.0
  dio: ^5.4.0

  # Others
  flutter_local_notifications: ^16.2.0
  permission_handler: ^11.0.1
  uuid: ^4.2.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  build_runner: ^2.4.6

flutter:
  uses-material-design: true
  
  assets:
    - assets/images/
    - assets/lottie/
    - assets/icons/

  fonts:
    - family: CustomIcons
      fonts:
        - asset: assets/fonts/CustomIcons.ttf
```

---

## Step 4: Project Folder Structure

The project will have this structure:

```
student_app/
├── lib/
│   ├── main.dart
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_constants.dart
│   │   │   ├── firebase_constants.dart
│   │   │   └── route_constants.dart
│   │   ├── theme/
│   │   │   ├── app_theme.dart
│   │   │   └── app_colors.dart
│   │   ├── errors/
│   │   │   ├── exceptions.dart
│   │   │   └── failures.dart
│   │   ├── network/
│   │   │   └── network_info.dart
│   │   ├── utils/
│   │   │   ├── validators.dart
│   │   │   ├── helpers.dart
│   │   │   └── date_utils.dart
│   │   └── usecases/
│   │       └── usecase.dart
│   ├── data/
│   │   ├── models/
│   │   │   ├── user_model.dart
│   │   │   ├── complaint_model.dart
│   │   │   └── ...
│   │   ├── datasources/
│   │   │   ├── auth_remote_datasource.dart
│   │   │   ├── complaint_remote_datasource.dart
│   │   │   └── ...
│   │   └── repositories/
│   │       ├── auth_repository_impl.dart
│   │       └── ...
│   ├── domain/
│   │   ├── entities/
│   │   │   ├── user_entity.dart
│   │   │   ├── complaint_entity.dart
│   │   │   └── ...
│   │   ├── repositories/
│   │   │   ├── auth_repository.dart
│   │   │   └── ...
│   │   └── usecases/
│   │       ├── sign_in_usecase.dart
│   │       ├── sign_up_usecase.dart
│   │       └── ...
│   ├── presentation/
│   │   ├── bloc/
│   │   │   ├── auth/
│   │   │   ├── complaint/
│   │   │   └── ...
│   │   ├── pages/
│   │   │   ├── splash/
│   │   │   ├── auth/
│   │   │   │   ├── login_page.dart
│   │   │   │   └── register_page.dart
│   │   │   ├── home/
│   │   │   ├── complaint/
│   │   │   └── ...
│   │   ├── widgets/
│   │   │   ├── common/
│   │   │   │   ├── custom_button.dart
│   │   │   │   ├── custom_textfield.dart
│   │   │   │   └── loading_widget.dart
│   │   │   └── ...
│   │   └── routes/
│   │       └── app_routes.dart
│   └── injection_container.dart
├── assets/
│   ├── images/
│   ├── lottie/
│   ├── fonts/
│   └── icons/
├── android/
├── ios/
└── pubspec.yaml
```

---

## Step 5: Install Dependencies

```bash
cd student_app
flutter pub get
```

---

## Step 6: Run the App

```bash
# Check connected devices
flutter devices

# Run on Android
flutter run

# Or run on iOS
flutter run -d ios

# Or run on web
flutter run -d chrome
```

---

## Next Steps

Once the Flutter project is created, I'll provide:
1. ✅ Complete login screen UI code
2. ✅ Firebase initialization code
3. ✅ Authentication logic with Bloc
4. ✅ Clean architecture setup
5. ✅ Theme and styling

---

## Quick Start Commands Summary

```bash
# 1. Add Flutter to PATH (if needed)
export PATH="$PATH:$HOME/flutter/bin"

# 2. Verify Flutter
flutter doctor

# 3. Create project
cd /Users/roshan/Projects/CampusCare
flutter create --org com.sharda --project-name campus_care student_app

# 4. Install dependencies
cd student_app
flutter pub get

# 5. Run app
flutter run
```

Let me know once Flutter is available, and I'll proceed with creating all the code files!
