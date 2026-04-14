import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:amaris_technical_test/features/funds/domain/entities/fund.dart';
import 'package:amaris_technical_test/features/funds/presentation/widgets/fund_card.dart';

void main() {
  const tFund = Fund(
    id: 1,
    name: 'FPV_BTG_PACTUAL_RECAUDADORA',
    minAmount: 75000,
    category: FundCategory.fpv,
  );

  testWidgets('renders fund details correctly', (tester) async {
    bool subscribeCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FundCard(
            fund: tFund,
            onSubscribe: () => subscribeCalled = true,
          ),
        ),
      ),
    );

    // Verify fund name is displayed
    expect(find.text('FPV_BTG_PACTUAL_RECAUDADORA'), findsOneWidget);

    // Verify minimum amount is displayed (formatted)
    expect(find.textContaining('75.000'), findsOneWidget);

    // Verify subscribe button is displayed
    expect(find.text('Suscribirse'), findsOneWidget);

    // Verify category badge
    expect(find.text('FPV'), findsOneWidget);

    // Verify callback is invoked when button is tapped
    await tester.tap(find.text('Suscribirse'));
    expect(subscribeCalled, true);
  });

  testWidgets('calls onSubscribe when button is tapped', (tester) async {
    bool subscribeCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FundCard(
            fund: tFund,
            onSubscribe: () => subscribeCalled = true,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Suscribirse'));
    await tester.pump();

    expect(subscribeCalled, true);
  });
}
