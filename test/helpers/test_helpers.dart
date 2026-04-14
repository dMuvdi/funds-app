import 'package:mockito/annotations.dart';
import 'package:amaris_technical_test/features/funds/domain/repositories/funds_repository.dart';
import 'package:amaris_technical_test/features/funds/domain/usecases/get_funds.dart';
import 'package:amaris_technical_test/features/funds/domain/usecases/get_balance.dart';
import 'package:amaris_technical_test/features/funds/domain/usecases/get_active_subscriptions.dart';
import 'package:amaris_technical_test/features/funds/domain/usecases/get_transactions.dart';
import 'package:amaris_technical_test/features/funds/domain/usecases/subscribe_to_fund.dart';
import 'package:amaris_technical_test/features/funds/domain/usecases/cancel_subscription.dart';

@GenerateMocks([
  FundsRepository,
  GetFunds,
  GetBalance,
  GetActiveSubscriptions,
  GetTransactions,
  SubscribeToFund,
  CancelSubscription,
])
void main() {}
