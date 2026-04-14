import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/fund.dart';
import '../entities/notification_channel.dart';
import '../entities/subscription.dart';
import '../repositories/funds_repository.dart';

/// Subscribe to a fund
class SubscribeToFund {
  final FundsRepository repository;

  const SubscribeToFund(this.repository);

  Future<Either<Failure, Subscription>> call({
    required Fund fund,
    required double amount,
    required NotificationChannel channel,
  }) => repository.subscribe(fund: fund, amount: amount, channel: channel);
}
