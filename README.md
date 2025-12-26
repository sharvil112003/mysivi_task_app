# mysivi_task_app 🚀

A medium-sized Flutter application focused on modular feature-based architecture with offline-first behavior and a chat feature.

---

## Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Architecture](#architecture)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Run locally](#run-locally)
  - [Build APK](#build-apk)
  - [Run tests](#run-tests)
- [Connectivity behavior](#connectivity-behavior)
- [Customization & configuration](#customization--configuration)
- [Contributing](#contributing)
- [License](#license)
- [Links](#links)

---

## Overview
mysivi_task_app is built with Flutter and follows a modular, feature-first structure (e.g., chat, history, home, offers, users). It uses GetX for routing and DI, Hive for local persistence, and provides a persistent offline notification banner when network connectivity is lost.

## Features ✅
- Feature-based screens: Chat, History, Home, Offers, Settings, Users
- Offline support using Hive for local data
- Persistent non-dismissible offline banner with automatic detection and Retry action
- Lookup-in-dictionary: long-press any word in chat to fetch its top definitions (uses https://dictionaryapi.dev/) and show them in a bottom sheet
- Tap profile avatar in the chat to view user profile info (avatar, name, status, etc.)
- Platform support: Android, iOS, Web, Linux, macOS, Windows
- Integration tests & widget tests (example test for connectivity banner)
- Material 3 theming and Google Fonts

## Architecture 🏗️
- Presentation: GetX (controllers, pages/widgets), feature modules
- Domain / Data: Repositories (e.g., `data/repos/`), Hive-based storage (`data/hive/`)
- Services: reusable platform services (e.g., `ConnectivityService` in `lib/services/`)
- Tests: unit, widget tests under `test/`

This separation keeps UI logic isolated in controllers and routes, while repositories and services expose minimal interfaces for testability.

## Tech Stack 🛠️
- Flutter & Dart
- GetX (routing & DI)
- Hive (local storage)
- connectivity_plus (network detection)
- google_fonts
- flutter_test for widget/unit tests

## Project Structure 📂
Key folders:
- `lib/` — app source
  - `app/` — bindings, routes, utils
  - `data/` — repos, models, hive service
  - `features/` — feature modules (chat, history, home, offers, settings, users, shell)
  - `services/` — platform services (connectivity, etc.)
  - `main.dart` — app entrypoint and global configuration
- `test/` — tests (e.g., `connectivity_banner_test.dart`)
- platform folders: `android/`, `ios/`, `web/`, `windows/`, `macos/`, `linux/`

## Getting Started ⚡
### Prerequisites
- Flutter SDK (stable) installed: https://flutter.dev/docs/get-started/install
- Android SDK / Xcode (if targeting mobile platforms)
- Optional: VS Code or Android Studio

### Run locally
1. Clone repo:

```bash
git clone <repo-url>
cd mysivi_task_app
```

2. Install dependencies:

```bash
flutter pub get
```

3. Run on a device/emulator:

```bash
flutter run
# or specify a device
flutter run -d chrome  # web
flutter run -d windows # windows desktop
```

4. Lint & analyze:

```bash
flutter analyze
```

### Build APK

```bash
flutter build apk --release
# Generated APK: build/app/outputs/flutter-apk/app-release.apk
```

### Run tests

```bash
flutter test
# or run a single test
flutter test test/connectivity_banner_test.dart
```

## Connectivity behavior 📡
- The app uses `lib/services/connectivity_service.dart` to perform an initial DNS-based reachability check and then periodically polls (5s by default).
- When no internet is available, a **persistent MaterialBanner** is shown with the message: *"No internet connection. This message will remain until a connection is available."* and a **Retry** button to force an immediate re-check.
- The banner is automatically dismissed when connectivity is restored.

## Dictionary lookup 📚
- When reading chat messages rendered by `WordTapText` (`lib/features/chat/widgets/word_wrap_text.dart`), long-pressing a word will open a bottom sheet with definitions.
- Definitions are fetched by `lib/data/services/dictionary_api.dart` (uses `https://api.dictionaryapi.dev/` via `http` package). The service returns up to the first 3 definitions found.
- UI behavior: long-press highlights the tapped word, shows a modal bottom sheet with a loading state, and displays definitions or a "no meaning found" message.
- This feature requires network connectivity; consider handling offline behavior if you want cached or offline definitions.

## Customization & configuration 🔧
- Change poll interval or host used for the reachability test in `lib/services/connectivity_service.dart`.
- Banner text and appearance can be adjusted in `lib/main.dart`'s `_showOfflineBanner` method.
- Tests use a small `IConnectivityService` interface so you can inject fakes for deterministic behavior.

## Contributing 🤝
Contributions are welcome. Please open issues or create PRs with clear descriptions, tests, and small incremental changes.

## License
Add your license here (e.g., MIT). If this is a private project you may choose a closed license.

---

## Links
- APK: [APK](https://drive.google.com/file/d/1qNJPpw1OFgJTLoLPrmsOpJHFmCChwKoM/view?usp=drive_link)
- Demo video: [Demo](https://drive.google.com/file/d/1rEFaqvxYcFLFeQpZjb2Ozz9SvABniN7x/view?usp=sharing)

---
