# Drunken Flutter

A mobile-first Flutter prototype for friend tracking, map interaction, and mock messaging.

## Overview

This app is a lightweight prototype built around a dark purple/kiwi UI. It includes:

- friend location tracking on an OpenStreetMap-based map
- direct message and call-style UI flows
- a settings panel with tracking session controls and ghost mode
- a mobile-first experience that is optimized for phone-sized screens

## Running the App

Install dependencies and run the app as usual:

```bash
flutter pub get
flutter run
```

### Prerequisites

This project requires Flutter. If Flutter is not installed, follow the official setup guide:

https://docs.flutter.dev/install

Once installed, make sure `flutter` is available in your terminal.

If you use a browser for web debugging, keep in mind that the app is intended for mobile layouts.

## Web Browser View

The web version scales to fill the browser width by default, which can make the UI look oversized on large screens.

For the best results, use a mobile device frame such as **iPhone 17** in responsive design mode.

This app is designed for phone-sized screens and is not fully tested on all desktop or unusual web resolutions.

## Notes

- User GPS is attempted first and falls back to a hardcoded location if unavailable.
- Friends are currently using hardcoded mock data.
- The prototype uses Flutter widgets and a simple state-based UI rather than a full backend.
