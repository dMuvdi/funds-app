import 'package:equatable/equatable.dart';

/// Base failure class for domain layer errors
sealed class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Insufficient balance to subscribe to fund
class InsufficientBalanceFailure extends Failure {
  final String fundName;

  const InsufficientBalanceFailure(this.fundName)
    : super('No tiene saldo disponible para vincularse al fondo $fundName');

  @override
  List<Object?> get props => [fundName, message];
}

/// Amount below minimum required for fund
class BelowMinimumFailure extends Failure {
  final String fundName;
  final double minAmount;

  const BelowMinimumFailure(this.fundName, this.minAmount)
    : super('El monto es inferior al mínimo requerido para $fundName');

  @override
  List<Object?> get props => [fundName, minAmount, message];
}

/// Generic unexpected error
class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'Ocurrió un error inesperado']);
}
