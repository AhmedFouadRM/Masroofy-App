# Masroofy (مصروفي) 💰

An offline-first, privacy-focused, and bilingual (English/Arabic) personal expense tracking application built with Flutter.

Masroofy is designed to be simple, fast, and secure. It runs entirely on-device with zero cloud dependencies, ensuring your financial data never leaves your phone.

## ✨ Features

- **💸 Expense Tracking**: Quickly log daily expenses with categories and notes.
- **📊 Analytics Dashboard**: Visualize your spending with interactive pie charts (category breakdown) and bar charts (daily spending) using `fl_chart`.
- **🎯 Budgets**: Set weekly or monthly spending limits per category and track your progress with color-coded indicators.
- **🔄 Recurring Expenses**: Set up templates for predictable costs (rent, subscriptions) and Masroofy will auto-generate the entries when they're due.
- **🏷️ Custom Categories**: Use the bilingual pre-seeded defaults or create your own categories with custom icons and colors.
- **🔒 App Lock**: Secure your data with a 4-digit PIN or biometric unlock (fingerprint/face).
- **🌍 Bilingual & RTL Ready**: Full support for English (LTR) and Arabic (RTL) with seamless, on-the-fly switching.
- **🌙 Dark/Light Theme**: Adapts to your system settings or can be manually overridden.
- **📤 Data Export**: Export your transaction history to CSV at any time.

## 🛠️ Tech Stack

Masroofy is built on a robust, modern Flutter stack:

- **Framework:** Flutter 3.47 (Dart 3.x)
- **Architecture:** Clean Architecture (Feature-First vertical slices: Domain → Data → Presentation)
- **State Management:** `flutter_bloc` (Cubit), DI via `RepositoryProvider`
- **Database:** Drift (SQLite) for reactive, type-safe SQL and relational data
- **Data Models:** `freezed` + `json_serializable` for immutable entities and DTOs
- **Routing:** `go_router` for declarative navigation and auth guarding
- **Error Handling:** `fpdart` (`Either` monad)
- **Localization:** `easy_localization` + a strictly typed `StringManager`
- **UI & Charts:** Material 3, `gap`, `flutter_animate`, `fl_chart`

## 🏗️ Project Architecture

Masroofy follows a strict **Clean Architecture** approach. The app is divided into features (`lib/features/`), where each feature contains:
- `domain/`: Pure Dart interfaces and entities.
- `data/`: Drift DAOs, repositories, and DTOs.
- `presentation/`: Cubits, screens, and widgets.

For detailed product requirements, architecture decisions, and feature specifications, please explore the [`Product-Architecture/`](./Product-Architecture/) directory in this repository. 
- Start with [`INDEX.md`](./Product-Architecture/INDEX.md) and [`MEMORY.md`](./Product-Architecture/MEMORY.md).

## 🚀 Getting Started

To run Masroofy locally, you need [Flutter](https://docs.flutter.dev/get-started/install) installed.

1. **Clone the repository:**
   ```bash
   git clone https://github.com/AhmedFouadRM/Masroofy-App.git
   cd Masroofy-App
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run code generation (for Freezed and Drift):**
   ```bash
   dart run build_runner build -d
   ```

4. **Run the app:**
   ```bash
   flutter run
   ```

## 🛡️ Privacy

Masroofy has no backend, no analytics, and no telemetry. Your database is local to your device, and you have complete control over your data.
