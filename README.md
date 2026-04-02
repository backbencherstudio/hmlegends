# Foods LTD

Foods LTD is a high-performance, feature-rich mobile application developed with Flutter. The app provides a seamless user experience for community engagement and resource management, leveraging modern architecture and state-of-the-art Flutter development practices.

##  Project Overview
Food LTD App is designed to be a scalable, maintainable platform. It integrates complex features such as real-time notifications, secure user authentication, and dynamic content feeds, all while maintaining a buttery-smooth 60 FPS UI.

##  Architecture
The project follows **Clean Architecture** combined with the **MVVM (Model-View-ViewModel)** design pattern. This ensures:
- **Separation of Concerns**: UI, Business Logic, and Data sources are strictly isolated.
- **Testability**: Logic can be unit tested without UI dependencies.
- **Maintainability**: New features can be added with minimal impact on existing code.

##  Folder Structure
The `lib` directory is organized by feature to ensure modularity:

```text
lib/
├── core/                  # Global constants, themes, and shared utilities
│   ├── constants/         # API endpoints, image paths, strings
│   ├── network/           # Dio configuration & interceptors
│   ├── theme/             # App colors, text styles, and themes
│   └── routes/            # AppRouter and navigation logic
├── data/                  # Data Layer (Repositories & Models)
│   ├── models/            # JSON Parsers and DTOs
│   ├── repositories/      # Repository implementations
│   └── datasources/       # Remote and local data handlers
├── domain/                # Domain Layer (Business Logic Entities)
│   ├── entities/          # Plain Dart objects for business logic
│   └── usecases/          # Independent business logic units
├── presentation/          # UI Layer (MVVM)
│   ├── viewmodels/        # Provider/Riverpod State Management
│   ├── views/             # Screens/Pages
│   └── widgets/           # Reusable UI components
└── main.dart              # Entry point of the application


## Tech Stack
Framework: Flutter (Dart)

State Management: Provider / Riverpod

Networking: Dio (with Interceptors)

Dependency Injection: Get_it

Local Storage: Shared Preferences / Hive

Serialization: JsonSerializable / Equatable

## Setup Instructions
Clone the Repo: git clone https://github.com/backbencherstudio/hmlegends.git

Install Dependencies: flutter pub get

Run Code Generation: flutter pub run build_runner build

Launch App: flutter run
