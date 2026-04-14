import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/funds/presentation/bloc/funds_bloc.dart';
import '../../features/funds/presentation/bloc/funds_event.dart';
import '../../features/funds/presentation/pages/funds_dashboard_page.dart';
import '../di/injection.dart';

/// App router configuration
final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => BlocProvider(
        create: (_) => sl<FundsBloc>()..add(const FundsStarted()),
        child: const FundsDashboardPage(),
      ),
    ),
  ],
);
