# 💱 Exchange Rate - BRL Currency Converter

[![Flutter](https://img.shields.io/badge/Flutter-3.9+-blue.svg)](https://flutter.dev/)
[![BLoC](https://img.shields.io/badge/BLoC-9.1.1-green.svg)](https://bloclibrary.dev/)

An elegant and responsive Flutter application for checking Brazilian Real (BRL) exchange rates against other currencies, developed as a technical challenge for Action Labs.

## ✨ Features

- **Current Rate**: Real-time consultation of current exchange rate
- **30-Day History**: Visualization of daily rates from the last 30 days
- **Difference Calculation**: "Close diff" field showing variation between consecutive days
- **Responsive Design**: Adaptable to different screen sizes
- **Modern Interface**: Clean and intuitive UI following Material Design

## 🎯 Supported Currencies

- **USD** - US Dollar
- **EUR** - Euro
- **GBP** - British Pound
- **JPY** - Japanese Yen
- **CAD** - Canadian Dollar
- And many other currencies available in the API

## 🏗️ Architecture

The project follows a clean and well-structured architecture:

```
lib/
├── src/
│   ├── core/           # Global configurations, theme and constants
│   │   ├── constants/  # Responsive constants
│   │   ├── shared/     # Shared utilities
│   │   └── theme/      # Theme configuration
│   └── features/
│       └── home/       # Main functionality
│           ├── data/   # Repositories and datasources
│           ├── domain/ # Entities and use cases
│           └── presentation/ # UI and BLoCs
```

## 🛠️ Technologies Used

- **Flutter 3.9+** - Development framework
- **BLoC/Cubit** - State management
- **GetIt** - Dependency injection
- **HTTP** - HTTP client for APIs
- **Equatable** - Object comparison
- **Flutter SVG** - SVG image rendering
- **Roboto** - Custom font

## 🚀 How to Run

### Prerequisites

- Flutter SDK 3.9.0 or higher
- Dart SDK
- Android Studio / VS Code
- Android emulator or physical device

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/levivcruz/exchange_rate.git
   cd exchange_rate
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Configure environment variables**
   Create a `.env` file in the project root:

   ```env
   API_BASE_URL=your_base_url_here
   API_KEY=your_api_key_here
   ```

4. **Run the application**

   ```bash
   flutter run
   ```

## 📱 How to Use

1. **Type the currency code** you want (e.g., USD, EUR, GBP)
2. **View the current rate** of exchange
3. **Access the history** of 30 days for detailed analysis
4. **Monitor variations** through the "close diff" field

## 🔌 API

The application uses the Action Labs API to obtain exchange rate data:

- **Documentation**: [Swagger UI](https://api-brl-exchange.actionlabs.com.br/api/1.0/swagger-ui.html)
- **Endpoints**:
  - Current rate: `/open/currentExchangeRate`
  - History: `/open/exchangeRateHistory`
- **Limits**: 5 calls/minute, 500 calls/day
- **Authentication**: API Key required

## 🧪 Testing

The project includes a complete test suite:

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage
```

### Test Coverage

- **Unit Tests**: Business logic and repositories
- **Widget Tests**: UI components

## 📊 Data Structure

### Current Rate

```dart
class CurrentExchangeRateEntity {
  final double? exchangeRate;
  final String? fromSymbol;
  final String? toSymbol;
  final String? lastUpdatedAt;
  final bool? success;
  final bool? rateLimitExceeded;
}
```

### Daily History

```dart
class ExchangeRateDataEntity {
  final double? open;
  final double? high;
  final double? low;
  final double? close;
  final String? date;
}
```

## 🎨 Design System

- **Main Font**: Roboto (Regular, Medium, SemiBold, Bold)
- **Theme**: Material Design 3
- **Responsiveness**: Adaptive constants for different screen sizes
- **Colors**: Consistent and accessible palette

## 📱 Responsiveness

The application is fully responsive, adapting to different screen sizes through:

- Responsive constants based on `MediaQuery`
- Flexible and adaptive layout
- Components that automatically adjust

## 🔒 Security

- API Key stored in environment variables
- User input validation
- API error handling
- Rate limiting implemented

## 🚧 Known Limitations

- API rate limit: 5 calls/minute, 500/day
- Internet connection required
- Data limited to last 30 days

## 👨‍💻 Developer

**Levi V.** - [GitHub](https://github.com/levivcruz)

---

⭐ **If this project was helpful to you, consider giving it a star!**
