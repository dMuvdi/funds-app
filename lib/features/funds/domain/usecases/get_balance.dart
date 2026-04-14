import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/funds_repository.dart';

/// Get user's available balance
class GetBalance {
  final FundsRepository repository;

  const GetBalance(this.repository);

  Future<Either<Failure, double>> call() => repository.getBalance();
}
