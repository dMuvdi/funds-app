import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/funds_repository.dart';

class ResetState {
  final FundsRepository repository;

  const ResetState(this.repository);

  Future<Either<Failure, Unit>> call() => repository.resetState();
}
