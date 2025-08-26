# Final Project

A Flutter application that fetches data from a local JSON server.

## Prerequisites

- Flutter SDK (^3.8.1)
- Python 3 (for local server)
- Dart SDK

## Setup & Installation

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Start the Local JSON Server
Before running the app, you need to start a local server to serve the JSON data:

```bash
python3 -m http.server 3000 --directory /home/mustafa/final_project
```

The server will start on `http://localhost:3000` and serve the JSON file at:
- **JSON Endpoint**: `http://localhost:3000/assets/data.json`

### 3. Run the Flutter App
```bash
flutter run
```

## Environment Configuration

The app uses environment variables stored in `.env` file:
- `API_BASE_URL`: Base URL for the local server
- `API_DATA_ENDPOINT`: Direct endpoint to the JSON data

## Platform-Specific URLs

- **Web/Desktop**: `http://localhost:3000/assets/data.json`
- **Android Emulator**: `http://10.0.2.2:3000/assets/data.json`
- **iOS Simulator**: `http://localhost:3000/assets/data.json`

## Project Structure

```
lib/
├── config/
│   └── app_config.dart    # Environment configuration
├── main.dart              # App entry point
assets/
└── data.json              # JSON data file
```

## Troubleshooting

- If the server fails to start, ensure Python 3 is installed
- For Android emulator, use `10.0.2.2` instead of `localhost`
- Make sure port 3000 is not already in use
