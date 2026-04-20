import 'package:equatable/equatable.dart';
import '../../domain/entities/fund.dart';
import '../../domain/entities/notification_channel.dart';

/// Base event for FundsBloc
sealed class FundsEvent extends Equatable {
  const FundsEvent();

  @override
  List<Object?> get props => [];
}

/// Initial load event
class FundsStarted extends FundsEvent {
  const FundsStarted();
}

/// Subscribe to a fund event
class FundSubscribed extends FundsEvent {
  final Fund fund;
  final double amount;
  final NotificationChannel channel;

  const FundSubscribed({
    required this.fund,
    required this.amount,
    required this.channel,
  });

  @override
  List<Object?> get props => [fund, amount, channel];
}

/// Cancel subscription event
class SubscriptionCancelled extends FundsEvent {
  final String subscriptionId;

  const SubscriptionCancelled(this.subscriptionId);

  @override
  List<Object?> get props => [subscriptionId];
}

/// Reset all state to initial values
class StateReset extends FundsEvent {
  const StateReset();
}
