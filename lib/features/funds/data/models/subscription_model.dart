import '../../domain/entities/notification_channel.dart';
import '../../domain/entities/subscription.dart';
import 'fund_model.dart';

/// Subscription model with JSON serialization
class SubscriptionModel extends Subscription {
  const SubscriptionModel({
    required super.id,
    required super.fund,
    required super.amount,
    required super.channel,
    required super.createdAt,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) =>
      SubscriptionModel(
        id: json['id'] as String,
        fund: FundModel.fromJson(json['fund'] as Map<String, dynamic>),
        amount: (json['amount'] as num).toDouble(),
        channel: NotificationChannel.values.byName(json['channel'] as String),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'fund': (fund as FundModel).toJson(),
    'amount': amount,
    'channel': channel.name,
    'createdAt': createdAt.toIso8601String(),
  };
}
