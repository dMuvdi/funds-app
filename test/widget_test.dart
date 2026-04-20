import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:amaris_technical_test/core/theme/app_theme.dart';
import 'package:amaris_technical_test/core/widgets/category_badge.dart';
import 'package:amaris_technical_test/core/widgets/empty_state.dart';
import 'package:amaris_technical_test/core/widgets/segmented.dart';
import 'package:amaris_technical_test/features/funds/domain/entities/fund.dart';
import 'package:amaris_technical_test/features/funds/domain/entities/notification_channel.dart';
import 'package:amaris_technical_test/features/funds/domain/entities/subscription.dart';
import 'package:amaris_technical_test/features/funds/domain/entities/transaction.dart';
import 'package:amaris_technical_test/features/funds/presentation/widgets/active_subscriptions_panel.dart';
import 'package:amaris_technical_test/features/funds/presentation/widgets/allocation_card.dart';
import 'package:amaris_technical_test/features/funds/presentation/widgets/hero_balance_card.dart';
import 'package:amaris_technical_test/features/funds/presentation/widgets/transaction_history_panel.dart';

// ─── Helpers ─────────────────────────────────────────────────────────────────

Widget wrap(Widget child) => MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(body: SingleChildScrollView(child: child)),
    );

const tFund = Fund(
  id: 1,
  name: 'FPV_BTG_PACTUAL_RECAUDADORA',
  minAmount: 75000,
  category: FundCategory.fpv,
);

const tFicFund = Fund(
  id: 3,
  name: 'DEUDAPRIVADA',
  minAmount: 50000,
  category: FundCategory.fic,
);

final tSubscription = Subscription(
  id: 'sub_001',
  fund: tFund,
  amount: 100000,
  channel: NotificationChannel.email,
  createdAt: DateTime(2026, 4, 1),
);

final tSubTransaction = Transaction(
  id: 'tx_001',
  type: TransactionType.subscription,
  fund: tFund,
  amount: 100000,
  channel: NotificationChannel.email,
  timestamp: DateTime(2026, 4, 1, 10, 30),
);

final tCancelTransaction = Transaction(
  id: 'tx_002',
  type: TransactionType.cancellation,
  fund: tFund,
  amount: 100000,
  channel: null,
  timestamp: DateTime(2026, 4, 2, 9, 0),
);

// ─── Tests ───────────────────────────────────────────────────────────────────

void main() {
  setUpAll(() async {
    await initializeDateFormatting('es', null);
  });

// ─── HeroBalanceCard ─────────────────────────────────────────────────────────

group('HeroBalanceCard', () {
  testWidgets('shows formatted available balance', (tester) async {
    await tester.pumpWidget(
      wrap(const HeroBalanceCard(balance: 500000, invested: 0)),
    );
    await tester.pump();

    expect(find.textContaining('500.000'), findsWidgets);
    expect(find.textContaining('SALDO DISPONIBLE'), findsOneWidget);
  });

  testWidgets('shows updated balance after investment', (tester) async {
    await tester.pumpWidget(
      wrap(const HeroBalanceCard(balance: 400000, invested: 100000)),
    );
    await tester.pump();

    expect(find.textContaining('400.000'), findsWidgets);
  });

  testWidgets('shows Disponible and Invertido meta items', (tester) async {
    await tester.pumpWidget(
      wrap(const HeroBalanceCard(balance: 300000, invested: 200000)),
    );
    await tester.pump();

    expect(find.text('Disponible'), findsOneWidget);
    expect(find.text('Invertido'), findsOneWidget);
  });
});

// ─── AllocationCard ──────────────────────────────────────────────────────────

group('AllocationCard', () {
  testWidgets('shows Distribución title and legend labels', (tester) async {
    await tester.pumpWidget(
      wrap(const AllocationCard(
        fpvAmount: 100000,
        ficAmount: 50000,
        available: 350000,
      )),
    );
    await tester.pump();

    expect(find.text('Distribución'), findsOneWidget);
    expect(find.text('FPV'), findsOneWidget);
    expect(find.text('FIC'), findsOneWidget);
    expect(find.text('DISPONIBLE'), findsOneWidget);
  });

  testWidgets('shows formatted amounts in legend', (tester) async {
    await tester.pumpWidget(
      wrap(const AllocationCard(
        fpvAmount: 100000,
        ficAmount: 0,
        available: 400000,
      )),
    );
    await tester.pump();

    expect(find.textContaining('100.000'), findsWidgets);
    expect(find.textContaining('400.000'), findsWidgets);
  });
});

// ─── CategoryBadge ───────────────────────────────────────────────────────────

group('CategoryBadge', () {
  testWidgets('renders FPV label', (tester) async {
    await tester.pumpWidget(
      wrap(const CategoryBadge(category: FundCategory.fpv)),
    );
    expect(find.text('FPV'), findsOneWidget);
  });

  testWidgets('renders FIC label', (tester) async {
    await tester.pumpWidget(
      wrap(const CategoryBadge(category: FundCategory.fic)),
    );
    expect(find.text('FIC'), findsOneWidget);
  });
});

// ─── EmptyState ──────────────────────────────────────────────────────────────

group('EmptyState', () {
  testWidgets('renders title and subtitle', (tester) async {
    await tester.pumpWidget(
      wrap(const EmptyState(
        icon: Icons.inbox_outlined,
        title: 'Sin datos',
        subtitle: 'No hay nada por aquí todavía.',
      )),
    );

    expect(find.text('Sin datos'), findsOneWidget);
    expect(find.text('No hay nada por aquí todavía.'), findsOneWidget);
  });
});

// ─── SegmentedControl ────────────────────────────────────────────────────────

group('SegmentedControl', () {
  testWidgets('renders all option labels', (tester) async {
    await tester.pumpWidget(
      wrap(SegmentedControl(
        options: const ['Todos', 'FPV', 'FIC'],
        selectedIndex: 0,
        onChanged: (_) {},
      )),
    );

    expect(find.text('Todos'), findsOneWidget);
    expect(find.text('FPV'), findsOneWidget);
    expect(find.text('FIC'), findsOneWidget);
  });

  testWidgets('calls onChanged with correct index when option tapped',
      (tester) async {
    int tapped = -1;

    await tester.pumpWidget(
      wrap(SegmentedControl(
        options: const ['Todos', 'FPV', 'FIC'],
        selectedIndex: 0,
        onChanged: (i) => tapped = i,
      )),
    );

    await tester.tap(find.text('FPV'));
    await tester.pump();

    expect(tapped, 1);
  });

  testWidgets('highlights the selected option', (tester) async {
    await tester.pumpWidget(
      wrap(SegmentedControl(
        options: const ['Todos', 'FPV', 'FIC'],
        selectedIndex: 2,
        onChanged: (_) {},
      )),
    );

    // Just verifies it renders without error with a non-zero selection
    expect(find.text('FIC'), findsOneWidget);
  });
});

// ─── ActiveSubscriptionsPanel ────────────────────────────────────────────────

group('ActiveSubscriptionsPanel', () {
  testWidgets('shows empty state when no subscriptions', (tester) async {
    await tester.pumpWidget(
      wrap(ActiveSubscriptionsPanel(
        subscriptions: const [],
        onCancel: (_) {},
      )),
    );

    expect(find.text('Aún no tienes suscripciones'), findsOneWidget);
  });

  testWidgets('renders subscription fund name and amount', (tester) async {
    await tester.pumpWidget(
      wrap(ActiveSubscriptionsPanel(
        subscriptions: [tSubscription],
        onCancel: (_) {},
      )),
    );

    expect(find.text('FPV_BTG_PACTUAL_RECAUDADORA'), findsOneWidget);
    expect(find.textContaining('100.000'), findsWidgets);
  });

  testWidgets('shows cancel trigger for each subscription', (tester) async {
    await tester.pumpWidget(
      wrap(ActiveSubscriptionsPanel(
        subscriptions: [tSubscription],
        onCancel: (_) {},
      )),
    );

    expect(find.textContaining('Cancelar'), findsOneWidget);
  });

  testWidgets('renders multiple subscriptions', (tester) async {
    final sub2 = Subscription(
      id: 'sub_002',
      fund: tFicFund,
      amount: 50000,
      channel: NotificationChannel.sms,
      createdAt: DateTime(2026, 4, 5),
    );

    await tester.pumpWidget(
      wrap(ActiveSubscriptionsPanel(
        subscriptions: [tSubscription, sub2],
        onCancel: (_) {},
      )),
    );

    expect(find.text('FPV_BTG_PACTUAL_RECAUDADORA'), findsOneWidget);
    expect(find.text('DEUDAPRIVADA'), findsOneWidget);
  });

  testWidgets('shows stat labels Canal, Monto, Desde', (tester) async {
    await tester.pumpWidget(
      wrap(ActiveSubscriptionsPanel(
        subscriptions: [tSubscription],
        onCancel: (_) {},
      )),
    );

    expect(find.text('CANAL'), findsOneWidget);
    expect(find.text('MONTO'), findsOneWidget);
    expect(find.text('DESDE'), findsOneWidget);
  });
});

// ─── TransactionHistoryPanel ─────────────────────────────────────────────────

group('TransactionHistoryPanel', () {
  testWidgets('shows empty state when no transactions', (tester) async {
    await tester.pumpWidget(
      wrap(const TransactionHistoryPanel(transactions: [])),
    );

    expect(find.text('Sin movimientos'), findsOneWidget);
  });

  testWidgets('renders subscription transaction with fund name', (tester) async {
    await tester.pumpWidget(
      wrap(TransactionHistoryPanel(transactions: [tSubTransaction])),
    );

    expect(find.text('FPV_BTG_PACTUAL_RECAUDADORA'), findsOneWidget);
    expect(find.textContaining('Suscripción'), findsOneWidget);
    expect(find.textContaining('100.000'), findsWidgets);
  });

  testWidgets('renders cancellation transaction', (tester) async {
    await tester.pumpWidget(
      wrap(TransactionHistoryPanel(transactions: [tCancelTransaction])),
    );

    expect(find.textContaining('Cancelación'), findsOneWidget);
  });

  testWidgets('renders both transaction types when mixed', (tester) async {
    await tester.pumpWidget(
      wrap(TransactionHistoryPanel(
        transactions: [tSubTransaction, tCancelTransaction],
      )),
    );

    expect(find.textContaining('Suscripción'), findsOneWidget);
    expect(find.textContaining('Cancelación'), findsOneWidget);
  });

  testWidgets('shows debit sign for subscriptions and credit for cancellations',
      (tester) async {
    await tester.pumpWidget(
      wrap(TransactionHistoryPanel(
        transactions: [tSubTransaction, tCancelTransaction],
      )),
    );

    expect(find.textContaining('−'), findsOneWidget);
    expect(find.textContaining('+'), findsOneWidget);
  });
});

} // end main
