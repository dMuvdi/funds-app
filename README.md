# BTG Fondos — Fund Management Application

A production-quality Flutter web/mobile application for managing BTG Pactual investment fund subscriptions, built with Clean Architecture principles.

## 🚀 Live Demo

[https://main.d3dkxx53edhkx8.amplifyapp.com/](https://main.d3dkxx53edhkx8.amplifyapp.com/)

## 📱 Features

- **Browse Funds**: View all available FPV (Voluntary Pension Funds) and FIC (Collective Investment Funds) in a responsive table (desktop) or card list (mobile)
- **Subscribe**: Invest in funds with minimum amount validation, quick-amount chips and live balance preview
- **Manage Subscriptions**: View active subscriptions with canal, amount and date stats; cancel with confirmation
- **Transaction History**: Track all subscription and cancellation activities with signed amounts
- **Notification Preferences**: Choose between Email or SMS notifications per subscription
- **Reset State**: Restore the portfolio to its initial state via the footer control
- **Responsive Design**: Optimized for both mobile and desktop (breakpoint at 800px)
- **Real-time Balance**: Available balance updates instantly after every action

## 🛠 Tech Stack

- **Framework**: Flutter 3.10.8+
- **State Management**: flutter_bloc (^8.1.6) with Equatable
- **Architecture**: Clean Architecture (Data/Domain/Presentation layers)
- **Dependency Injection**: get_it (^7.7.0)
- **Routing**: go_router (^14.2.7)
- **Functional Programming**: dartz (^0.10.1) for error handling
- **UI**: google_fonts (^6.2.1), Material Design 3
- **Formatting**: intl (^0.19.0) for Colombian Peso and Spanish date formatting
- **Testing**: mockito (^5.4.4), bloc_test (^9.1.7)

## 🏗 Architecture

The application follows Clean Architecture with clear layer separation:

- **Presentation** → Domain (uses entities and use cases)
- **Data** → Domain (implements repository contracts)
- **Domain** → No dependencies (pure business logic)
- **Core** → Shared utilities (no feature dependencies)

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

The app follows a modern fintech design language inspired by high-end portfolio management interfaces:

- **Background**: Warm cream (`#F6F4EE`)
- **Foreground**: Near-black ink (`#111114` / `#2A2A30`)
- **Accent**: Electric green (`#4ADE80`) — used for FIC badges and allocation donut
- **Danger**: `#DC2626` for cancellation actions
- **Typography**:
  - **Instrument Serif** — hero amounts, modal titles
  - **Inter** — all body and UI text
  - **JetBrains Mono** — IDs, kickers, meta labels, currency axis
- **Spacing**: 4pt grid system (`xs: 4`, `sm: 8`, `md: 16`, `lg: 24`, `xl: 32`, `xxl: 48`)
- **Radius**: `sm: 6`, `md: 10`, `lg: 14`, `xl: 20`
- **Components**: pill badges, segmented controls, ghost/primary buttons, `CustomPainter` charts

### Charts (no external chart library)

- **Sparkline** (`SparklinePainter`): 30-day balance curve with filled gradient area and mono axis labels
- **Allocation Donut** (`AllocationDonut`): three-arc breakdown of FPV / FIC / Available drawn with `CustomPainter`

### Responsive Breakpoints

- **Mobile**: < 800px — hero stacks vertically, funds collapse to cards, subscription modal becomes a bottom sheet
- **Desktop**: ≥ 800px — hero row (1.55 : 1 ratio), two-column panel grid, funds displayed in table with hover rows

### Dashboard Layout

- **Topbar**: brand block (serif "Funds" + mono subtitle) + user chip (avatar, name, ID)
- **Hero**: `HeroBalanceCard` with sparkline + `AllocationCard` with donut and legend
- **Panel 01 — Oportunidades**: segmented filter (`Todos / FPV / FIC`), desktop table / mobile cards
- **Panel 02 — En curso**: active subscriptions with canal, amount and date stats per item
- **Panel 03 — Historial**: signed activity rows with circular type icon and mono timestamp
- **Footer**: "Restablecer" button → confirmation dialog → `StateReset` event → toast

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

- **Unit Tests**: Currency formatter, repository implementation, use cases (including `ResetState`)
- **Bloc Tests**: Full state machine coverage — `FundsStarted`, `FundSubscribed`, `SubscriptionCancelled`, `StateReset`
- **Widget Tests**: 21 tests across `HeroBalanceCard`, `AllocationCard`, `CategoryBadge`, `EmptyState`, `SegmentedControl`, `ActiveSubscriptionsPanel`, `TransactionHistoryPanel`

All 40 tests pass with `flutter test`. Code analysis is clean with `flutter analyze`.

## 🤝 Contributing

This is a technical assessment project. For questions or feedback:

- GitHub: [@dMuvdi](https://github.com/dMuvdi)
- Repository: [dMuvdi/funds-app](https://github.com/dMuvdi/funds-app)
