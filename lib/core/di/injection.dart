import 'package:get_it/get_it.dart';
import '../../features/funds/data/datasources/funds_local_datasource.dart';
import '../../features/funds/data/repositories/funds_repository_impl.dart';
import '../../features/funds/domain/repositories/funds_repository.dart';
import '../../features/funds/domain/usecases/cancel_subscription.dart';
import '../../features/funds/domain/usecases/get_active_subscriptions.dart';
import '../../features/funds/domain/usecases/get_balance.dart';
import '../../features/funds/domain/usecases/get_funds.dart';
import '../../features/funds/domain/usecases/get_transactions.dart';
import '../../features/funds/domain/usecases/reset_state.dart';
import '../../features/funds/domain/usecases/subscribe_to_fund.dart';
import '../../features/funds/presentation/bloc/funds_bloc.dart';

final sl = GetIt.instance;

/// Setup dependency injection
void setupInjection() {
  // Datasource (singleton — holds in-memory state)
  sl.registerLazySingleton<FundsLocalDataSource>(() => FundsLocalDataSource());

  // Repository
  sl.registerLazySingleton<FundsRepository>(() => FundsRepositoryImpl(sl()));

  // Use cases
  sl.registerFactory(() => GetFunds(sl()));
  sl.registerFactory(() => GetBalance(sl()));
  sl.registerFactory(() => GetActiveSubscriptions(sl()));
  sl.registerFactory(() => GetTransactions(sl()));
  sl.registerFactory(() => SubscribeToFund(sl()));
  sl.registerFactory(() => CancelSubscription(sl()));
  sl.registerFactory(() => ResetState(sl()));

  // Bloc
  sl.registerFactory(
    () => FundsBloc(
      getFunds: sl(),
      getBalance: sl(),
      getActiveSubscriptions: sl(),
      getTransactions: sl(),
      subscribeToFund: sl(),
      cancelSubscription: sl(),
      resetState: sl(),
    ),
  );
}
