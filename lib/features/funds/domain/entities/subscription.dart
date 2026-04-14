import 'package:equatable/equatable.dart';
import 'fund.dart';
import 'notification_channel.dart';

/// Active subscription to a fund
class Subscription extends Equatable {
  final String id;
  final Fund fund;
  final double amount;
  final NotificationChannel channel;
  final DateTime createdAt;

  const Subscription({
    required this.id,
    required this.fund,
    required this.amount,
    required this.channel,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, fund, amount, channel, createdAt];
}
