# QuoteVault

**QuoteVault** is a premium Flutter application designed for discovering, saving, and creating beautiful quote compositions. It features a curated collection of wisdom, advanced search capabilities, and a powerful editor for sharing thoughts in style.

<img src="https://via.placeholder.com/800x400?text=QuoteVault+Banner" alt="QuoteVault Banner" width="100%" />

## ✨ Features

-   **Daily Inspiration**: Start your day with a new, thought-provoking quote.
-   **Curated Collections**: Browse quotes organized by topics (Wisdom, Motivation, Life, etc.).
-   **Advanced Search**: Instantly find quotes by keywords or explore trending authors.
-   **Quote Editor**: Create stunning visuals with custom typography, backgrounds, and layouts.
-   **Personal Library**: Save favorites and organize them into custom private collections.
-   **Secure Cloud Sync**: User data and collections are securely synced via Supabase.
-   **Dark/Light Mode**: Beautiful adaptive UI using `FlexColorScheme`.

## 🛠️ Tech Stack

-   **Frontend**: [Flutter](https://flutter.dev/) (Dart)
-   **State Management**: [Riverpod](https://riverpod.dev/) (2.6.x)
-   **Backend & Auth**: [Supabase](https://supabase.com/)
-   **Navigation**: [AutoRoute](https://pub.dev/packages/auto_route)
-   **Networking**: [Dio](https://pub.dev/packages/dio)
-   **UI/Theming**: 
    -   `flex_color_scheme`
    -   `google_fonts` (Playfair Display, Lora, Inter)
    -   `shimmer` for loading states

## 🚀 Getting Started

### Prerequisites

-   Flutter SDK (>=3.0.0)
-   Dart SDK

### Installation

1.  **Clone the repository**
    ```bash
    git clone https://github.com/yourusername/quote_vault.git
    cd quote_vault
    ```

2.  **Install dependencies**
    ```bash
    flutter pub get
    ```

3.  **Run the app**
    ```bash
    flutter run
    ```

### Configuration

The application authenticates with Supabase. The configuration is currently located in `lib/main.dart`. Ensure you have a valid internet connection for the app to function correctly.

## 📂 Project Structure

This project follows a **Feature-First** architecture:

```
lib/
├── core/               # App-wide configurations (Theme, Router, Constants)
├── features/           # Feature modules containing View, Controller, and State
│   ├── auth/           # Authentication (Login, SignUp, Forgot Password)
│   ├── discover/       # Home feed and Daily Quote
│   ├── editor/         # Quote Editor canvas and tools
│   ├── explore/        # Search and Categories
│   ├── saved/          # User Collections and Favorites
│   ├── search/         # Dedicated search functionality
│   └── settings/       # User Profile and App Settings
├── shared/             # Reusable widgets and providers
└── main.dart           # Application Entry Point
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1.  Fork the project
2.  Create your feature branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

## 📄 License

This project is licensed under the MIT License.
