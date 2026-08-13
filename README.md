# Elyx Assignment App

A production-style Flutter application simulating a secure transaction dashboard for BFSI/fintech use cases, built with Clean Architecture and BLoC state management.

## Project Overview

This app demonstrates:
- Mock authentication with secure token storage
- Paginated transaction list with pull-to-refresh
- Transaction detail view
- Session expiry handling with auto-logout
- Clean, layered architecture separating UI, business logic, and data

**Demo credentials:** `user` / `pass`

## Architecture

The project follows **Clean Architecture** with a feature-based folder structure:

lib/
├── core/ # Shared code across features
│ ├── network/
│ │ └── api_service.dart # Centralized HTTP client (token attach, error handling, mock API)
│ ├── storage/
│ │ └── secure_storage_service.dart # flutter_secure_storage wrapper for token persistence
│ └── utils/
│ └── either.dart # Custom Either<L, R> for functional-style error handling
│
├── features/
│ ├── auth/
│ │ ├── data/ # Models, remote datasource, repository implementation
│ │ ├── domain/
│ │ │ ├── repositories/ # Abstract AuthRepository contract
│ │ │ └── usecases/
│ │ │ └── login_usecase.dart
│ │ └── presentation/ # AuthBloc + Login UI
│ │
│ └── transactions/
│ ├── data/
│ ├── domain/
│ └── presentation/ # TransactionBloc (pagination) + List/Detail UI
│
└── main.dart

### Layer Responsibilities

- **Presentation** – Widgets + Bloc. Widgets only dispatch events and render states; no business logic lives inside widgets.
- **Domain** – Pure Dart entities, repository contracts (abstract), and use cases (e.g. `login_usecase.dart`). Independent of Flutter and any data source.
- **Data** – Models (JSON parsing), remote data sources, and repository implementations that convert exceptions into `Failure` objects.

Each layer only depends on the layer directly below it (Presentation → Domain → Data), never the other way around.

### State Management

**flutter_bloc** is used throughout. Every async operation explicitly emits Loading, Success (data-bearing), and Error states — no business logic relies on `setState`.

- `AuthBloc` – handles login, logout, session-expiry, and app-start auth check.
- `TransactionBloc` – handles first load, pull-to-refresh, and paginated "load more", with guards to prevent duplicate/overlapping requests.

## How to Run

```bash
flutter pub get
flutter run
```

Login with:
- Username: `user`
- Password: `pass`

## Libraries Used & Why

| Package | Purpose |
|---|---|
| `flutter_bloc` + `equatable` | State management with explicit Loading/Success/Error states |
| `http` | REST client for API calls |
| `flutter_secure_storage` | Encrypted token storage (Android Keystore / iOS Keychain backed) |
| `get_it` | Dependency injection / service locator |
| `intl` | Currency and date formatting |

## Key Design Decisions

1. **Mock API via `api_service.dart`**: Since no real backend was provided, this service simulates network delay and returns realistic JSON-like data (50 transactions, paginated 10 at a time). It's structured so the app behaves exactly as it would with a real REST API — if a real backend is introduced later, only this file needs to change; the rest of the architecture (repository, bloc, UI) stays unchanged.

2. **Custom `Either<L, R>` (`either.dart`) instead of `dartz`**: A minimal custom implementation was used to keep dependencies lean while still getting explicit, exception-free error propagation from the data layer up to the Bloc. `Left` = failure, `Right` = success.

3. **Centralized API layer**: All HTTP calls go through `api_service.dart`, which attaches the auth token to every request (except login), applies a timeout, and converts responses/errors into typed exceptions. This keeps error-handling logic in one place instead of scattered across repositories.

4. **Automatic session expiry**: A `401` response anywhere in the app triggers a callback that dispatches a `SessionExpired` event to `AuthBloc`. This clears the stored token and redirects the user to the Login screen, even if they were several screens deep (e.g., on the Transaction Detail page).

5. **Security**: Token is stored exclusively via `flutter_secure_storage` (AES-256 backed `EncryptedSharedPreferences` on Android, Keychain on iOS) inside `secure_storage_service.dart`. No token or sensitive data is ever logged or stored in `SharedPreferences`/plain memory.

6. **Pagination guard clauses**: "Load more" is a no-op if a load is already in progress or the last page has been reached, preventing duplicate API calls during fast scrolling.

## Known Limitations / Future Improvements

- Automated tests were not included in this submission due to time constraints; given more time, `bloc_test` and `mocktail` would be used to test `AuthBloc`, `TransactionBloc`, and the Login/List screens.
- Currently uses a mock API in `api_service.dart` in place of a real backend; swapping to a real REST API only requires changes to that file, per the architecture's separation of concerns.