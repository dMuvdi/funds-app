import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/funds_repository.dart';

/// Cancel an active subscription
class CancelSubscription {
  final FundsRepository repository;

  const CancelSubscription(this.repository);

  Future<Either<Failure, Unit>> call(String subscriptionId) =>
      repository.cancel(subscriptionId);
}
