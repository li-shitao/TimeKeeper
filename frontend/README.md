# Frontend (Flutter)

This directory contains the Flutter frontend for the Family Time Tracker app.

## Running the application

First, make sure you have the Flutter SDK installed and a device (or simulator/emulator) running.

Then, get the dependencies:

```bash
flutter pub get
```

Finally, run the app:

```bash
flutter run
```

## Building for release

### Android

To build a release APK for Android:

```bash
flutter build apk --release
```

The output file will be at `build/app/outputs/flutter-apk/app-release.apk`.

### iOS

To build a release IPA for iOS:

```bash
flutter build ios --release
```

This requires you to have a valid Apple Developer account and code signing set up in Xcode. The output will be in the `build/ios/archive/` directory.
