import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/fund.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/entities/transaction.dart';

/// Funds status enum
enum FundsStatus { initial, loading, ready, error }

/// Funds state
class FundsState extends Equatable {
  final FundsStatus status;
  final List<Fund> funds;
  final double balance;
  final List<Subscription> activeSubscriptions;
  final List<Transaction> transactions;
  final Failure? loadFailure;
  final Failure? actionFailure;
  final String? actionSuccessMessage;
  final bool isProcessingAction;

  const FundsState({
    this.status = FundsStatus.initial,
    this.funds = const [],
    this.balance = 0,
    this.activeSubscriptions = const [],
    this.transactions = const [],
    this.loadFailure,
    this.actionFailure,
    this.actionSuccessMessage,
    this.isProcessingAction = false,
  });

  FundsState copyWith({
    FundsStatus? status,
    List<Fund>? funds,
    double? balance,
    List<Subscription>? activeSubscriptions,
    List<Transaction>? transactions,
    Failure? loadFailure,
    Failure? actionFailure,
    String? actionSuccessMessage,
    bool? isProcessingAction,
    bool clearLoadFailure = false,
    bool clearActionFailure = false,
    bool clearActionSuccessMessage = false,
  }) {
    return FundsState(
      status: status ?? this.status,
      funds: funds ?? this.funds,
      balance: balance ?? this.balance,
      activeSubscriptions: activeSubscriptions ?? this.activeSubscriptions,
      transactions: transactions ?? this.transactions,
      loadFailure: clearLoadFailure ? null : (loadFailure ?? this.loadFailure),
      actionFailure: clearActionFailure
          ? null
          : (actionFailure ?? this.actionFailure),
      actionSuccessMessage: clearActionSuccessMessage
          ? null
          : (actionSuccessMessage ?? this.actionSuccessMessage),
      isProcessingAction: isProcessingAction ?? this.isProcessingAction,
    );
  }

  @override
  List<Object?> get props => [
    status,
    funds,
    balance,
    activeSubscriptions,
    transactions,
    loadFailure,
    actionFailure,
    actionSuccessMessage,
    isProcessingAction,
  ];
}
