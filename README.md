# 📚 Kutumba Library Management System

A Flutter-based **admin library management system** for maintaining a book
catalog, author directory, student roster, and book issue/return
transactions — built to demonstrate production-grade Flutter architecture
using **Clean Architecture**, the **Repository Pattern**, **Dependency
Injection**, and **BLoC state management with global state**.

> This is an **admin-only** application. There is no student-facing login
> or self-service portal — students are maintained as a managed directory
> that the admin uses when issuing books, not as user accounts.

---

## ✨ Features

| Module | Description |
|---|---|
| 🔐 **Admin Login** | Single authenticated admin session, gating access to the rest of the app |
| 📖 **Books** | Add, edit, and delete books in the catalog, tracking total and available copies |
| ✍️ **Authors** | Maintain an independent author directory |
| 🎓 **Students** | Maintain a student directory (Student ID, Name, Faculty, Email, Contact No.) |
| 🔄 **Transactions** | A full log of every book issued and returned, with status and overdue indicators |
| ➕ **Issue Book** | Record that a student has taken a book — select student, book, quantity, and date; available copies update automatically |
| ✅ **Mark Returned** | Close out an outstanding transaction and restore the book's availability in one action |

---

## 🏗️ Architecture

This project follows **Clean Architecture** with three strictly separated
layers. Dependencies only ever point **inward**, toward the domain layer —
never outward.

```
┌─────────────────────────────────────────────────┐
│                 PRESENTATION                     │
│   Widgets, Pages, and BLoCs (Events/States)      │
│   Depends only on the domain layer               │
└───────────────────────┬───────────────────────────┘
                         │
┌───────────────────────▼───────────────────────────┐
│                     DOMAIN                       │
│   Entities, Repository contracts, Use Cases      │
│   Depends on nothing else in the app             │
└───────────────────────▲───────────────────────────┘
                         │
┌───────────────────────┴───────────────────────────┐
│                      DATA                        │
│   Repository implementations, local data sources │
│   Depends only on the domain layer                │
└─────────────────────────────────────────────────┘
```

### Design Patterns Used

| Pattern | Purpose | Where |
|---|---|---|
| **Dependency Injection** | Every class receives its dependencies through its constructor rather than creating them itself, via a single registration point | `lib/core/di/service_locator.dart` (using [`get_it`](https://pub.dev/packages/get_it)) |
| **Repository Pattern** | Business logic depends only on an abstract contract, never on how data is actually stored or fetched | `lib/domain/repositories/` (contracts) + `lib/data/repositories/` (implementations) |
| **BLoC with Global State** | User actions become events; a BLoC turns them into new state; the UI reacts. Every BLoC is provided once at the app root, so state is consistent across every screen | `lib/presentation/bloc/` + `MultiBlocProvider` in `main.dart` |
| **Use Case Pattern** | Each user-facing action (add a book, issue a book, delete a student...) is its own single-responsibility class | `lib/domain/usecases/` |

---

## 📂 Project Structure

```
lib/
├── core/
│   └── di/
│       └── service_locator.dart        # Wires up every dependency in the app
├── data/
│   ├── datasources/                    # Local, in-memory seeded data sources
│   │   ├── auth_local_data_source.dart
│   │   ├── author_local_data_source.dart
│   │   ├── book_local_data_source.dart
│   │   ├── borrow_local_data_source.dart
│   │   └── student_local_data_source.dart
│   └── repositories/                   # Concrete repository implementations
├── domain/
│   ├── entities/                       # User, Book, Author, Student, BorrowRecord
│   ├── repositories/                   # Abstract repository contracts
│   └── usecases/                       # One class per user action
├── presentation/
│   ├── bloc/
│   │   ├── auth/                       # Admin session state (global)
│   │   ├── book/                       # Book catalog state
│   │   ├── author/                     # Author directory state
│   │   ├── student/                    # Student directory state
│   │   └── borrow/                     # Transaction state (global)
│   ├── pages/
│   │   ├── auth/                       # Login screen
│   │   └── admin/                      # Books, Authors, Students, Transaction, Issue Book
│   └── widgets/                        # Shared, reusable UI components
└── main.dart                            # App entry point: DI setup + global BLoC providers
```

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.x or later)
- Android Studio (or VS Code) with the Flutter and Dart plugins

### Installation

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Demo Credentials

| Field | Value |
|---|---|
| Email | `admin@library.com` |
| Password | `admin123` |

---

## 🧪 Testing

```bash
flutter test
```

Unit tests cover the domain layer (use cases) and presentation layer
(BLoCs), using mocked dependencies — made possible specifically because of
the Dependency Injection setup, since every class accepts its dependencies
as constructor parameters rather than constructing them internally.

---

## 📦 Building a Release APK

```bash
flutter build apk --release --split-per-abi
```

This produces per-architecture APKs at `build/app/outputs/flutter-apk/`,
keeping file size down compared to a single universal APK.

---

## 📌 Notes & Known Simplifications

- **Data persistence**: all data is held in memory via local data sources,
  seeded with sample records on launch. Restarting the app resets all data.
  Swapping in a real backend only requires changing the data source layer —
  the domain and presentation layers would not need to change, by design.
- **Returns are all-or-nothing**: a transaction's full quantity is returned
  in one action; partial returns of a multi-copy transaction aren't
  modeled.
- **Authors and Books are independent lists**: a book's author is stored
  as free text rather than a foreign key relationship, matching the
  reference system's design.

---

## 🛠️ Tech Stack

- **Flutter** & **Dart**
- [`flutter_bloc`](https://pub.dev/packages/flutter_bloc) — state management
- [`get_it`](https://pub.dev/packages/get_it) — dependency injection
- [`equatable`](https://pub.dev/packages/equatable) — value equality for BLoC events/states
- [`intl`](https://pub.dev/packages/intl) — date formatting

---

*Built as an internship assignment demonstrating professional Flutter
architecture: Clean Architecture, the Repository Pattern, Dependency
Injection, and BLoC with global state.*