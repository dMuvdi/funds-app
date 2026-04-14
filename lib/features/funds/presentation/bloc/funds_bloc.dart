import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/cancel_subscription.dart';
import '../../domain/usecases/get_active_subscriptions.dart';
import '../../domain/usecases/get_balance.dart';
import '../../domain/usecases/get_funds.dart';
import '../../domain/usecases/get_transactions.dart';
import '../../domain/usecases/subscribe_to_fund.dart';
import 'funds_event.dart';
import 'funds_state.dart';

/// Bloc for funds dashboard
class FundsBloc extends Bloc<FundsEvent, FundsState> {
  final GetFunds getFunds;
  final GetBalance getBalance;
  final GetActiveSubscriptions getActiveSubscriptions;
  final GetTransactions getTransactions;
  final SubscribeToFund subscribeToFund;
  final CancelSubscription cancelSubscription;

  FundsBloc({
    required this.getFunds,
    required this.getBalance,
    required this.getActiveSubscriptions,
    required this.getTransactions,
    required this.subscribeToFund,
    required this.cancelSubscription,
  }) : super(const FundsState()) {
    on<FundsStarted>(_onStarted);
    on<FundSubscribed>(_onFundSubscribed);
    on<SubscriptionCancelled>(_onSubscriptionCancelled);
  }

  Future<void> _onStarted(FundsStarted event, Emitter<FundsState> emit) async {
    emit(state.copyWith(status: FundsStatus.loading));

    try {
      final fundsResult = await getFunds();
      final balanceResult = await getBalance();
      final subsResult = await getActiveSubscriptions();
      final txsResult = await getTransactions();

      // Check if any failed
      if (fundsResult.isLeft() ||
          balanceResult.isLeft() ||
          subsResult.isLeft() ||
          txsResult.isLeft()) {
        final failure =
            fundsResult.fold((l) => l, (_) => null) ??
            balanceResult.fold((l) => l, (_) => null);
        emit(state.copyWith(status: FundsStatus.error, loadFailure: failure));
        return;
      }

      // All succeeded
      emit(
        state.copyWith(
          status: FundsStatus.ready,
          funds: fundsResult.getOrElse(() => []),
          balance: balanceResult.getOrElse(() => 0),
          activeSubscriptions: subsResult.getOrElse(() => []),
          transactions: txsResult.getOrElse(() => []),
          clearLoadFailure: true,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: FundsStatus.error));
    }
  }

  Future<void> _onFundSubscribed(
    FundSubscribed event,
    Emitter<FundsState> emit,
  ) async {
    print('🔵 Starting subscription process...');
    emit(
      state.copyWith(
        isProcessingAction: true,
        clearActionFailure: true,
        clearActionSuccessMessage: true,
      ),
    );
    print('🔵 State emitted: isProcessingAction = true');

    final result = await subscribeToFund(
      fund: event.fund,
      amount: event.amount,
      channel: event.channel,
    );
    print('🔵 Subscription result received');

    // Check if the result is a failure
    if (result.isLeft()) {
      final failure = result.fold((l) => l, (_) => throw UnimplementedError());
      print('🔴 Subscription failed: ${failure.message}');
      emit(state.copyWith(isProcessingAction: false, actionFailure: failure));
      return;
    }

    // Success case - refetch data
    print('✅ Subscription successful, fetching updated data...');
    final balanceResult = await getBalance();
    final subsResult = await getActiveSubscriptions();
    final txsResult = await getTransactions();

    print('✅ Data fetched, emitting new state...');
    emit(
      state.copyWith(
        isProcessingAction: false,
        balance: balanceResult.getOrElse(() => state.balance),
        activeSubscriptions: subsResult.getOrElse(
          () => state.activeSubscriptions,
        ),
        transactions: txsResult.getOrElse(() => state.transactions),
        actionSuccessMessage: 'Notificación enviada por ${event.channel.label}',
      ),
    );
    print('✅ State emitted: isProcessingAction = false, success message set');
  }

  Future<void> _onSubscriptionCancelled(
    SubscriptionCancelled event,
    Emitter<FundsState> emit,
  ) async {
    emit(
      state.copyWith(
        isProcessingAction: true,
        clearActionFailure: true,
        clearActionSuccessMessage: true,
      ),
    );

    final result = await cancelSubscription(event.subscriptionId);

    // Check if the result is a failure
    if (result.isLeft()) {
      final failure = result.fold((l) => l, (_) => throw UnimplementedError());
      emit(state.copyWith(isProcessingAction: false, actionFailure: failure));
      return;
    }

    // Success case - refetch data
    final balanceResult = await getBalance();
    final subsResult = await getActiveSubscriptions();
    final txsResult = await getTransactions();

    emit(
      state.copyWith(
        isProcessingAction: false,
        balance: balanceResult.getOrElse(() => state.balance),
        activeSubscriptions: subsResult.getOrElse(
          () => state.activeSubscriptions,
        ),
        transactions: txsResult.getOrElse(() => state.transactions),
        actionSuccessMessage: 'Suscripción cancelada exitosamente',
      ),
    );
  }
}
