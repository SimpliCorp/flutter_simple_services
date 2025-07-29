<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

A simple Flutter package that provides basic calculation services for Flutter applications.

## Features

- **Calculator Service**: Provides basic mathematical operations
- **Simple API**: Easy-to-use interface for common calculations
- **Lightweight**: Minimal dependencies and small footprint
- **Well-tested**: Comprehensive test coverage

## Getting started

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_simple_services: ^0.0.1
```

Then run:
```bash
flutter pub get
```


## Project library
- State managerment: GetX
- Network: dio, retrofit, json_serializable
- Image: CacheImageNetwork
- Fonts: google_fonts
- Icons svg: flutter_svg
- Multi Language:  intl_utils
- Auto generate: flutter_gen_runner, build_runner, retrofit_generator, json_serializable
- Create App icon: [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons), config on pubspec.yaml

## Step Run
- Get package
    ```
    flutter pub get
    ```
- Build runner Generate
    ```
    dart run build_runner build --delete-conflicting-outputs
    ```

    
## Dev
- How to use images, icons svg, color: [flutter_gen](https://pub.dev/packages/flutter_gen)
    ```
    Image.asset('assets/images/profile.jpeg') -> Assets.images.profile.image();
    ```
- How to use mutil language:

- How to change new app icon:
    1. Replace icon in __assets/images/app_icon.png__
    2. Run command
        ```
        dart pub run flutter_launcher_icons
        ```
- How to change Splash icon:
    1. Replace icon in __flutter_native_splash.yaml__ or __assets/images/logo_l7mobile.png__
    2. Run command
        ```
        dart run flutter_native_splash:create --path=flutter_native_splash.yaml 
        ```


## Visual Studio Code Extensions
- Flutter Intl - **required** - VS Code extension to create a binding between your translations from .arb files and your Flutter app. It generates boilerplate code for official Dart Intl library and adds auto-complete for keys in Dart code.
- Flutter Widget Snippets


## Build
- Build iOS app: `flutter build ipa --release`
    build with option export .ipa `flutter build ipa --release --export-options-plist=ios/BuildRelease/development-export-options.plist`

- Build android app
  .aab: `flutter build appbundle --release`
  .apk: `flutter build apk --release`


## Usage

