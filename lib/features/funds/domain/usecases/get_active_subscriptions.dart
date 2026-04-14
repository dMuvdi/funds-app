import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/subscription.dart';
import '../repositories/funds_repository.dart';

/// Get user's active subscriptions
class GetActiveSubscriptions {
  final FundsRepository repository;

  const GetActiveSubscriptions(this.repository);

  Future<Either<Failure, List<Subscription>>> call() =>
      repository.getActiveSubscriptions();
}
