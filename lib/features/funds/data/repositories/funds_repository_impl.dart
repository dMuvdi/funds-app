import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/fund.dart';
import '../../domain/entities/notification_channel.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/funds_repository.dart';
import '../datasources/funds_local_datasource.dart';
import '../models/fund_model.dart';

/// Repository implementation using local datasource
class FundsRepositoryImpl implements FundsRepository {
  final FundsLocalDataSource dataSource;

  const FundsRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<Fund>>> getFunds() async {
    try {
      final funds = await dataSource.getFunds();
      return Right(funds);
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, double>> getBalance() async {
    try {
      final balance = await dataSource.getBalance();
      return Right(balance);
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, List<Subscription>>> getActiveSubscriptions() async {
    try {
      final subscriptions = await dataSource.getActiveSubscriptions();
      return Right(subscriptions);
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getTransactions() async {
    try {
      final transactions = await dataSource.getTransactions();
      return Right(transactions);
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Subscription>> subscribe({
    required Fund fund,
    required double amount,
    required NotificationChannel channel,
  }) async {
    try {
      final subscription = await dataSource.subscribe(
        fund: fund as FundModel,
        amount: amount,
        channel: channel,
      );
      return Right(subscription);
    } on InsufficientBalanceException catch (e) {
      return Left(InsufficientBalanceFailure(e.fundName));
    } on BelowMinimumException catch (e) {
      return Left(BelowMinimumFailure(e.fundName, e.minAmount));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> cancel(String subscriptionId) async {
    try {
      await dataSource.cancel(subscriptionId);
      return const Right(unit);
    } on SubscriptionNotFoundException {
      return const Left(UnexpectedFailure('Suscripción no encontrada'));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }
}
