# Firebase Setup Guide for BlueNexus

## Prerequisites
- Firebase account
- FlutterFire CLI installed

## Setup Steps

### 1. Install FlutterFire CLI
```bash
dart pub global activate flutterfire_cli
```

### 2. Login to Firebase
```bash
firebase login
```

### 3. Configure Firebase for your project
```bash
cd C:\Users\chois\bluenexus
flutterfire configure
```

This will:
- Create a new Firebase project or use existing one
- Generate `firebase_options.dart` in `lib/`
- Configure Android and iOS settings automatically

### 4. Enable Firebase Services

In the Firebase Console (https://console.firebase.google.com):

1. **Authentication**
   - Enable Email/Password sign-in
   - Enable Google sign-in (optional)

2. **Cloud Firestore**
   - Create database in production mode
   - Set up security rules (see below)

3. **Firebase Storage**
   - Enable storage for image uploads
   - Configure storage rules

### 5. Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }

    // Dive logs collection
    match /dive_logs/{diveId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == resource.data.userId;
    }

    // Eco logs collection
    match /eco_logs/{logId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null && request.auth.uid == resource.data.userId;
    }

    // Crews collection
    match /crews/{crewId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }

    // Certifications collection
    match /certifications/{certId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == resource.data.userId;
    }

    // Marine species collection (read-only for users)
    match /marine_species/{speciesId} {
      allow read: if request.auth != null;
    }
  }
}
```

### 6. Storage Security Rules

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /users/{userId}/{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }

    match /dive_logs/{userId}/{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }

    match /eco_logs/{userId}/{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### 7. Update main.dart

After running `flutterfire configure`, update your main.dart:

```dart
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ... rest of initialization
}
```

## Running the App

```bash
flutter run
```

## Troubleshooting

- If you get "No Firebase App" error, ensure `Firebase.initializeApp()` is called before `runApp()`
- For Android, ensure `google-services.json` is in `android/app/`
- For iOS, ensure `GoogleService-Info.plist` is in `ios/Runner/`
