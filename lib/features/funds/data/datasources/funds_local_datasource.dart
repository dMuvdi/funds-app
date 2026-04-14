import '../../../../core/error/exceptions.dart';
import '../../domain/entities/notification_channel.dart';
import '../models/fund_model.dart';
import '../models/subscription_model.dart';
import '../models/transaction_model.dart';

/// In-memory local datasource for funds
class FundsLocalDataSource {
  static const double _initialBalance = 500000;

  double _balance = _initialBalance;
  final List<SubscriptionModel> _activeSubscriptions = [];
  final List<TransactionModel> _transactions = [];

  static const List<Map<String, dynamic>> _seedFunds = [
    {
      'id': 1,
      'name': 'FPV_BTG_PACTUAL_RECAUDADORA',
      'minAmount': 75000,
      'category': 'fpv',
    },
    {
      'id': 2,
      'name': 'FPV_BTG_PACTUAL_ECOPETROL',
      'minAmount': 125000,
      'category': 'fpv',
    },
    {'id': 3, 'name': 'DEUDAPRIVADA', 'minAmount': 50000, 'category': 'fic'},
    {'id': 4, 'name': 'FDO-ACCIONES', 'minAmount': 250000, 'category': 'fic'},
    {
      'id': 5,
      'name': 'FPV_BTG_PACTUAL_DINAMICA',
      'minAmount': 100000,
      'category': 'fpv',
    },
  ];

  Future<List<FundModel>> getFunds() async {
    // No delay for local data
    return _seedFunds.map(FundModel.fromJson).toList();
  }

  Future<double> getBalance() async {
    // No delay for local data
    return _balance;
  }

  Future<List<SubscriptionModel>> getActiveSubscriptions() async {
    // No delay for local data
    return List.unmodifiable(_activeSubscriptions);
  }

  Future<List<TransactionModel>> getTransactions() async {
    // No delay for local data
    return List.unmodifiable(_transactions.reversed);
  }

  /// Subscribe to a fund
  /// Throws [InsufficientBalanceException] if amount > balance
  /// Throws [BelowMinimumException] if amount < fund.minAmount
  Future<SubscriptionModel> subscribe({
    required FundModel fund,
    required double amount,
    required NotificationChannel channel,
  }) async {
    // No delay for local data

    if (amount < fund.minAmount) {
      throw BelowMinimumException(fund.name, fund.minAmount);
    }

    if (amount > _balance) {
      throw InsufficientBalanceException(fund.name);
    }

    _balance -= amount;

    final sub = SubscriptionModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      fund: fund,
      amount: amount,
      channel: channel,
      createdAt: DateTime.now(),
    );

    _activeSubscriptions.add(sub);
    _transactions.add(TransactionModel.subscription(sub));

    return sub;
  }

  /// Cancel a subscription
  /// Throws [SubscriptionNotFoundException] if subscription not found
  Future<void> cancel(String subscriptionId) async {
    // No delay for local data

    final idx = _activeSubscriptions.indexWhere((s) => s.id == subscriptionId);
    if (idx == -1) {
      throw SubscriptionNotFoundException(subscriptionId);
    }

    final sub = _activeSubscriptions.removeAt(idx);
    _balance += sub.amount;
    _transactions.add(TransactionModel.cancellation(sub));
  }
}
