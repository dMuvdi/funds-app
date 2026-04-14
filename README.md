# BTG Fondos — Fund Management Application

A production-quality Flutter web/mobile application for managing BTG Pactual investment fund subscriptions, built with Clean Architecture principles.

## 🚀 Live Demo

[https://funds-app-strg.s3-website-us-east-1.amazonaws.com](https://funds-app-strg.s3-website-us-east-1.amazonaws.com) *(Update with actual URL after deployment)*

## 📱 Features

- **Browse Funds**: View all available FPV (Voluntary Pension Funds) and FIC (Collective Investment Funds)
- **Subscribe**: Invest in funds with minimum amount validation and balance checking
- **Manage Subscriptions**: View active subscriptions and cancel when needed
- **Transaction History**: Track all subscription and cancellation activities
- **Notification Preferences**: Choose between Email or SMS notifications
- **Responsive Design**: Optimized for both mobile and desktop (breakpoint at 800px)
- **Real-time Balance**: See your available balance update instantly

## 🛠 Tech Stack

- **Framework**: Flutter 3.10.8+
- **State Management**: flutter_bloc (^8.1.6) with Equatable
- **Architecture**: Clean Architecture (Data/Domain/Presentation layers)
- **Dependency Injection**: get_it (^7.7.0)
- **Routing**: go_router (^14.2.7)
- **Functional Programming**: dartz (^0.10.1) for error handling
- **UI**: google_fonts (^6.2.1), Material Design 3
- **Formatting**: intl (^0.19.0) for Colombian Peso formatting
- **Testing**: mockito (^5.4.4), bloc_test (^9.1.7)

## 🏗 Architecture

The application follows Clean Architecture with clear layer separation:

- **Presentation** → Domain (uses entities and use cases)
- **Data** → Domain (implements repository contracts)
- **Domain** → No dependencies (pure business logic)
- **Core** → Shared utilities (no feature dependencies)

See [docs/02_ARCHITECTURE.md](docs/02_ARCHITECTURE.md) for detailed structure.

## 🚦 Getting Started

### Prerequisites

- Flutter SDK: >= 3.10.8
- Dart SDK: >= 3.0.0
- Chrome (for web development) or Android/iOS simulator

### Installation

```bash
# Clone the repository
git clone https://github.com/dMuvdi/funds-app.git
cd funds-app

# Install dependencies
flutter pub get

# Generate mock files for testing
dart run build_runner build --delete-conflicting-outputs

# Run the app on Chrome
flutter run -d chrome

# Or run on your simulator/emulator
flutter run
```

### Running Tests

```bash
# Run all tests
flutter test

# Analyze code
flutter analyze
```

## 💰 Available Funds

| ID | Name | Category | Minimum Amount (COP) |
|----|------|----------|----------------------|
| 1 | FPV_BTG_PACTUAL_RECAUDADORA | FPV | \$ 75.000 |
| 2 | FPV_BTG_PACTUAL_ECOPETROL | FPV | \$ 125.000 |
| 3 | DEUDAPRIVADA | FIC | \$ 50.000 |
| 4 | FDO-ACCIONES | FIC | \$ 250.000 |
| 5 | FPV_BTG_PACTUAL_DINAMICA | FPV | \$ 100.000 |

**Initial Balance**: COP \$ 500.000

## 🎨 Design System

The app follows a modern fintech design language with professional aesthetics:

- **Primary Color**: Modern Navy (#1A1F36)
- **Accent Color**: Vibrant Orange (#FF6B35)
- **Typography**: Poppins (text/UI), Nunito (numbers/currency)
- **Spacing**: 4pt grid system (xs: 4, sm: 8, md: 16, lg: 24, xl: 32, xxl: 48)
- **Components**: Material Design 3, rounded corners (8-16px), modern shadows, gradient accents

### Responsive Breakpoints

- **Mobile**: < 800px (single column, bottom sheet dialogs, vertical statistics cards)
- **Desktop**: >= 800px (7:5 column split, modal dialogs, horizontal statistics cards)

### Dashboard Features

- **Statistics Cards**: Fondos Disponibles, Suscripciones Activas, Total Invertido with icon badges
- **Professional Layout**: Section headers, improved spacing, organized activity panels
- **Balance Card**: Orange gradient header with real-time balance updates
- **Responsive Panels**: Active subscriptions and transaction history with proper mobile padding

## 🔒 Known Limitations

This is a demo application with the following intentional constraints:

1. **In-Memory State**: All data resets on app refresh (no persistent storage)
2. **Single User**: Hardcoded "Cliente BTG" with initial balance
3. **Mock Notifications**: Notification preferences are recorded but not actually sent
4. **No Authentication**: Single-session demo without login
5. **Client-Side Only**: No backend API (instant local operations for demo purposes)

These limitations are by design for the technical assessment and would be addressed in a production implementation.

## 🚀 Deployment

The application is configured for automated deployment to AWS S3 + CloudFront via GitHub Actions.

### AWS Setup (Manual - One Time)

1. Create S3 bucket: `funds-app-strg`
2. Enable static website hosting
3. Create CloudFront distribution
4. Configure IAM user with S3/CloudFront permissions
5. Add GitHub secrets: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION`, `S3_BUCKET`, `CLOUDFRONT_DISTRIBUTION_ID`

### Automatic Deployment

Pushes to `main` branch trigger the deployment workflow. See [.github/workflows/deploy.yml](.github/workflows/deploy.yml) for details.

## 🧪 Testing

Comprehensive test coverage includes:

- **Unit Tests**: Currency formatter, repository implementation, use cases
- **Bloc Tests**: State management with bloc_test (14 tests passing)
- **Widget Tests**: Fund card rendering and interactions

All tests verified with instant state updates and proper async/await handling.

## 🤝 Contributing

This is a technical assessment project. For questions or feedback:

- GitHub: [@dMuvdi](https://github.com/dMuvdi)
- Repository: [dMuvdi/funds-app](https://github.com/dMuvdi/funds-app)
