# Flutter CRUD app case study

Base CRUD app interacting with a REST API to illustrate some concepts of designing and architecturing a Flutter application.

## Features

- **CRUD operations**: List, view details, create, edit, and delete employees
- **Offline-First**: Local caching with optimistic UI data updates
- **Pull-to-Refresh**: Sync data on demand
- **Error Handling**: User-friendly error messages via snackbar notifications

> Note: Uses mocked API due to rate limits on test endpoint (configurable in `app_config.dart`)

## Architecture

- **State Management**: Riverpod
- **Data Models**: Freezed + json_serializable
- **Persistence**: Sembast (local database)
- **Navigation**: go_router (Navigator 2.0)
- **Localization**: easy_localization
- **Structure**: Clean Architecture (presentation, domain, data layers)
- **Design pattern**: Clean Architecture (presentation, domain, data layers)

## Getting started

Project is setup to use Dart >=3.10 along with Flutter 3.38.

- `flutter pub get`
- `flutter run`

## Improvement axis

- **Testing strategy**: unit test with repository mocking, widget test on some components, integration test for a full test flow.
- **Databases reconciliation**: local unpublished changes queuing & active network availability listening
