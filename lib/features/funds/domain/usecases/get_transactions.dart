import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/transaction.dart';
import '../repositories/funds_repository.dart';

/// Get transaction history
class GetTransactions {
  final FundsRepository repository;

  const GetTransactions(this.repository);

  Future<Either<Failure, List<Transaction>>> call() =>
      repository.getTransactions();
}
