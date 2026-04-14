import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/fund.dart';
import '../repositories/funds_repository.dart';

/// Get all available funds
class GetFunds {
  final FundsRepository repository;

  const GetFunds(this.repository);

  Future<Either<Failure, List<Fund>>> call() => repository.getFunds();
}
