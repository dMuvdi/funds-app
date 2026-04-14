import '../../domain/entities/notification_channel.dart';
import '../../domain/entities/transaction.dart';
import 'fund_model.dart';
import 'subscription_model.dart';

/// Transaction model with JSON serialization
class TransactionModel extends Transaction {
  const TransactionModel({
    required super.id,
    required super.type,
    required super.fund,
    required super.amount,
    required super.channel,
    required super.timestamp,
  });

  /// Create transaction from subscription
  factory TransactionModel.subscription(SubscriptionModel sub) =>
      TransactionModel(
        id: 'tx_${sub.id}',
        type: TransactionType.subscription,
        fund: sub.fund,
        amount: sub.amount,
        channel: sub.channel,
        timestamp: sub.createdAt,
      );

  /// Create transaction from cancellation
  factory TransactionModel.cancellation(SubscriptionModel sub) =>
      TransactionModel(
        id: 'tx_cancel_${sub.id}',
        type: TransactionType.cancellation,
        fund: sub.fund,
        amount: sub.amount,
        channel: null,
        timestamp: DateTime.now(),
      );

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        id: json['id'] as String,
        type: TransactionType.values.byName(json['type'] as String),
        fund: FundModel.fromJson(json['fund'] as Map<String, dynamic>),
        amount: (json['amount'] as num).toDouble(),
        channel: json['channel'] != null
            ? NotificationChannel.values.byName(json['channel'] as String)
            : null,
        timestamp: DateTime.parse(json['timestamp'] as String),
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'fund': (fund as FundModel).toJson(),
    'amount': amount,
    'channel': channel?.name,
    'timestamp': timestamp.toIso8601String(),
  };
}
