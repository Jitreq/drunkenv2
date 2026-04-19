# Drunken Flutter

A mobile-first Flutter prototype for late-night friend tracking, map interaction, and mock messaging. Built as a UI concept for social safety during evenings out - see where friends are, who's home safe, and quickly message or call.

> [!WARNING]
> Routes may draw incorrectly in Flutter web builds. The app works best on native targets (iOS/Android/desktop)

## Prerequisites

You need Flutter installed. If you don't have it, follow the official setup guide:

https://docs.flutter.dev/get-started/install

Verify it's available:

```bash
flutter doctor
```

## Run

Clone the repository and run the app:

```bash
git clone https://github.com/Jitreq/drunkenv2
cd drunkenv2
flutter pub get
flutter run
```

> [!TIP]
> For the best experience, run on a native device. Web builds (`flutter run -d chrome`) are supported but have known route rendering issues.

## Stack

- Flutter SDK ^3.11.5
- flutter_map with OpenStreetMap tiles
- geolocator for device GPS
- routing_engine (Valhalla) for dynamic route calculation
- Custom dark theme
- Hardcoded mock data for friends only

## Layout

```
lib/
  main.dart               # Fixed viewport size, login/logout state
  core/
    strings.dart          # App text strings
    theme/                # Dark theme setup
  data/
    mock_data.dart        # Hardcoded friends and default location fallback
  screens/
    login_screen.dart     # Mock login screen
    root_shell.dart       # Bottom navigation with three tabs
    home_screen.dart      # Map view with friend list
    map_screen.dart       # Full screen map
    chat_screen.dart      # Direct message UI
    call_screen.dart      # Call style UI
    settings_screen.dart  # Tracking controls and ghost mode
```

## Notes

- The app requests device GPS permission. If granted, it shows your actual location on the map and calculates routes from that position to friend destinations using Valhalla. If denied or unavailable, it falls back to a hardcoded default location.
- Friend positions, names, and statuses are static mock data. No backend services are connected.
- This is a UI prototype. No user accounts, authentication, or real friend tracking is implemented.

## License

MIT License - see [LICENSE](LICENSE) file.