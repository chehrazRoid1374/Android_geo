# LOOKFIT v0.1

Flutter Android-first demo for virtual fitting room UI.

## Current features
- Welcome and guest entry
- Capture or select a personal photo with image_picker
- Sample fashion catalogue and categories
- Garment details, demo preview, save looks
- Material 3 UI

**Note:** virtual try-on is a clearly labeled mock in this prototype; AI image generation, persistent accounts, payment and inventory have not been connected.

## Build
Run `flutter create . --platforms android --org com.lookfit --project-name lookfit` inside this folder, followed by `flutter pub get` and `flutter build apk --release`.

An automatic APK build is defined at the repository root: `.github/workflows/lookfit-apk.yml`.
