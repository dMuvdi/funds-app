import 'package:equatable/equatable.dart';
import 'fund.dart';
import 'notification_channel.dart';

/// Transaction type
enum TransactionType { subscription, cancellation }

/// Transaction history entry
class Transaction extends Equatable {
  final String id;
  final TransactionType type;
  final Fund fund;
  final double amount;
  final NotificationChannel? channel;
  final DateTime timestamp;

  const Transaction({
    required this.id,
    required this.type,
    required this.fund,
    required this.amount,
    required this.channel,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [id, type, fund, amount, channel, timestamp];
}
