import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/fund.dart';
import '../entities/notification_channel.dart';
import '../entities/subscription.dart';
import '../entities/transaction.dart';

/// Abstract repository for fund operations
abstract class FundsRepository {
  Future<Either<Failure, List<Fund>>> getFunds();

  Future<Either<Failure, double>> getBalance();

  Future<Either<Failure, List<Subscription>>> getActiveSubscriptions();

  Future<Either<Failure, List<Transaction>>> getTransactions();

  Future<Either<Failure, Subscription>> subscribe({
    required Fund fund,
    required double amount,
    required NotificationChannel channel,
  });

  Future<Either<Failure, Unit>> cancel(String subscriptionId);
}
