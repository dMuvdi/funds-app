import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/balance_card.dart';
import '../bloc/funds_bloc.dart';
import '../bloc/funds_event.dart';
import '../bloc/funds_state.dart';
import '../widgets/active_subscriptions_panel.dart';
import '../widgets/fund_card.dart';
import '../widgets/subscription_dialog.dart';
import '../widgets/transaction_history_panel.dart';

/// Professional funds dashboard with modern layout
class FundsDashboardPage extends StatelessWidget {
  const FundsDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FundsBloc, FundsState>(
      listener: (context, state) {
        // Show snackbar for action failures
        if (state.actionFailure != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.actionFailure!.message),
              backgroundColor: AppColors.error,
              action: SnackBarAction(
                label: 'Cerrar',
                textColor: AppColors.textOnPrimary,
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              ),
              duration: const Duration(seconds: 4),
            ),
          );
        }

        // Show snackbar for action success
        if (state.actionSuccessMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.actionSuccessMessage!),
              backgroundColor: AppColors.success,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: _buildAppBar(context, state),
          body: _buildBody(context, state),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, FundsState state) {
    return AppBar(
      elevation: 0,
      toolbarHeight: 72,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.account_balance_wallet_rounded,
              color: AppColors.accent,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Fondos de Inversión',
                style: AppTypography.headlineMedium.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Gestiona tus inversiones',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, FundsState state) {
    if (state.status == FundsStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == FundsStatus.error) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  size: 64,
                  color: AppColors.error,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Error al cargar datos',
                style: AppTypography.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                state.loadFailure?.message ?? 'Ocurrió un problema inesperado',
                style: AppTypography.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              ElevatedButton.icon(
                onPressed: () {
                  context.read<FundsBloc>().add(const FundsStarted());
                },
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    final desktop = isDesktop(context);

    if (desktop) {
      return _buildDesktopLayout(context, state);
    } else {
      return _buildMobileLayout(context, state);
    }
  }

  Widget _buildDesktopLayout(BuildContext context, FundsState state) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Balance Card
            Row(children: [BalanceCard(balance: state.balance)]),
            const SizedBox(height: AppSpacing.xl),

            // Statistics Overview Section
            _buildStatisticsSection(state),
            const SizedBox(height: AppSpacing.xl),

            // Main Content Grid
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column - Funds List
                Expanded(
                  flex: 7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader(
                        'Fondos Disponibles',
                        'Explora y suscríbete a fondos de inversión',
                        Icons.trending_up_rounded,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _buildFundsList(context, state),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.xl),

                // Right Column - Activity Panel
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader(
                        'Tu Actividad',
                        'Suscripciones y movimientos',
                        Icons.history_rounded,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _buildActivityPanel(context, state),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, FundsState state) {
    return CustomScrollView(
      slivers: [
        // Balance Card Header
        SliverToBoxAdapter(
          child: Container(
            color: AppColors.surface,
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: BalanceCard(balance: state.balance),
          ),
        ),

        // Statistics Section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: _buildMobileStatisticsSection(state),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),

        // Funds Section Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: _buildSectionHeader(
              'Fondos Disponibles',
              'Explora y suscríbete',
              Icons.trending_up_rounded,
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),

        // Funds List
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final fund = state.funds[index];
            return Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                index == state.funds.length - 1 ? AppSpacing.lg : 0,
              ),
              child: FundCard(
                fund: fund,
                onSubscribe: () =>
                    _showSubscriptionDialog(context, state, fund),
              ),
            );
          }, childCount: state.funds.length),
        ),

        // Activity Section
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.only(top: AppSpacing.md),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowLight,
                  blurRadius: 8,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: _buildSectionHeader(
                    'Tu Actividad',
                    'Suscripciones y movimientos',
                    Icons.history_rounded,
                  ),
                ),
                DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      const TabBar(
                        tabs: [
                          Tab(
                            icon: Icon(
                              Icons.check_circle_outline_rounded,
                              size: 20,
                            ),
                            text: 'Activos',
                          ),
                          Tab(
                            icon: Icon(Icons.receipt_long_outlined, size: 20),
                            text: 'Historial',
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 350,
                        child: TabBarView(
                          children: [
                            SingleChildScrollView(
                              child: ActiveSubscriptionsPanel(
                                subscriptions: state.activeSubscriptions,
                                onCancel: (id) => context.read<FundsBloc>().add(
                                  SubscriptionCancelled(id),
                                ),
                                isProcessing: state.isProcessingAction,
                              ),
                            ),
                            SingleChildScrollView(
                              child: TransactionHistoryPanel(
                                transactions: state.transactions,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFundsList(BuildContext context, FundsState state) {
    return Column(
      children: List.generate(state.funds.length, (index) {
        final fund = state.funds[index];
        return FundCard(
          fund: fund,
          onSubscribe: () => _showSubscriptionDialog(context, state, fund),
        );
      }),
    );
  }

  Widget _buildActivityPanel(BuildContext context, FundsState state) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.surfaceDark, width: 1),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.surfaceDark, width: 1),
                ),
              ),
              child: const TabBar(
                tabs: [
                  Tab(
                    icon: Icon(Icons.check_circle_outline_rounded, size: 20),
                    text: 'Activos',
                  ),
                  Tab(
                    icon: Icon(Icons.receipt_long_outlined, size: 20),
                    text: 'Historial',
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 600,
              child: TabBarView(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: ActiveSubscriptionsPanel(
                        subscriptions: state.activeSubscriptions,
                        onCancel: (id) => context.read<FundsBloc>().add(
                          SubscriptionCancelled(id),
                        ),
                        isProcessing: state.isProcessingAction,
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: TransactionHistoryPanel(
                        transactions: state.transactions,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsSection(FundsState state) {
    final totalInvested = state.activeSubscriptions.fold(
      0.0,
      (sum, sub) => sum + sub.amount,
    );

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Fondos Disponibles',
            '${state.funds.length}',
            Icons.account_balance_rounded,
            AppColors.accent,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _buildStatCard(
            'Suscripciones Activas',
            '${state.activeSubscriptions.length}',
            Icons.check_circle_rounded,
            AppColors.success,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _buildStatCard(
            'Total Invertido',
            formatCop(totalInvested),
            Icons.trending_up_rounded,
            AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildMobileStatisticsSection(FundsState state) {
    final totalInvested = state.activeSubscriptions.fold(
      0.0,
      (sum, sub) => sum + sub.amount,
    );

    return Column(
      children: [
        _buildStatCard(
          'Fondos Disponibles',
          '${state.funds.length}',
          Icons.account_balance_rounded,
          AppColors.accent,
        ),
        const SizedBox(height: AppSpacing.md),
        _buildStatCard(
          'Suscripciones Activas',
          '${state.activeSubscriptions.length}',
          Icons.check_circle_rounded,
          AppColors.success,
        ),
        const SizedBox(height: AppSpacing.md),
        _buildStatCard(
          'Total Invertido',
          formatCop(totalInvested),
          Icons.trending_up_rounded,
          AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceDark, width: 1),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: value.contains('\$')
                ? AppTypography.numberMedium.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  )
                : AppTypography.displayMedium.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.accent, size: 22),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.headlineSmall),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showSubscriptionDialog(BuildContext context, FundsState state, fund) {
    SubscriptionDialog.show(
      context: context,
      fund: fund,
      balance: state.balance,
      onConfirm: (amount, channel) {
        context.read<FundsBloc>().add(
          FundSubscribed(fund: fund, amount: amount, channel: channel),
        );
        // Don't close immediately - let the dialog close itself after processing
        // The dialog will listen to bloc state changes via BlocListener
      },
      isLoading: state.isProcessingAction,
    );
  }
}
