import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/segmented.dart';
import '../bloc/funds_bloc.dart';
import '../bloc/funds_event.dart';
import '../bloc/funds_state.dart';
import '../widgets/active_subscriptions_panel.dart';
import '../widgets/allocation_card.dart';
import '../widgets/fund_card.dart';
import '../widgets/funds_table.dart';
import '../widgets/hero_balance_card.dart';
import '../widgets/subscription_dialog.dart';
import '../widgets/transaction_history_panel.dart';

class FundsDashboardPage extends StatelessWidget {
  const FundsDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FundsBloc, FundsState>(
      listener: (context, state) {
        if (state.actionFailure != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.actionFailure!.message),
              backgroundColor: AppColors.danger,
              duration: const Duration(seconds: 4),
            ),
          );
        }
        if (state.actionSuccessMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.actionSuccessMessage!),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.paper,
          appBar: _Topbar(topPadding: MediaQuery.paddingOf(context).top),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, FundsState state) {
    if (state.status == FundsStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.ink),
      );
    }

    if (state.status == FundsStatus.error) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.dangerSoft,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline,
                  size: 22,
                  color: AppColors.danger,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Error al cargar datos',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                state.loadFailure?.message ?? 'Ocurrió un problema inesperado',
                style: GoogleFonts.inter(fontSize: 13, color: AppColors.muted),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () =>
                    context.read<FundsBloc>().add(const FundsStarted()),
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    return isDesktop(context)
        ? _DesktopLayout(state: state)
        : _MobileLayout(state: state);
  }
}

// ─── Topbar ─────────────────────────────────────────────────────────────────

class _Topbar extends StatelessWidget implements PreferredSizeWidget {
  const _Topbar({required this.topPadding});

  final double topPadding;

  @override
  Size get preferredSize => Size.fromHeight(64 + topPadding);

  @override
  Widget build(BuildContext context) {
    final mobile = !isDesktop(context);
    final horizontal = mobile ? 16.0 : 40.0;

    return Container(
      height: 64 + topPadding,
      padding: EdgeInsets.only(
        top: topPadding,
        left: horizontal,
        right: horizontal,
      ),
      decoration: const BoxDecoration(
        color: AppColors.paper,
        border: Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: Row(
        children: [
          // Brand
          const Icon(Icons.show_chart_rounded, size: 22, color: AppColors.ink),
          const SizedBox(width: 12),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Funds',
                style: GoogleFonts.instrumentSerif(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  color: AppColors.ink,
                  letterSpacing: -0.01,
                  height: 1,
                ),
              ),
              Text(
                'Gestión de fondos · FPV & FIC',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  color: AppColors.muted2,
                  letterSpacing: 0.04,
                ),
              ),
            ],
          ),
          const Spacer(),
          // User avatar — compact on mobile, full chip on desktop
          if (mobile)
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: AppColors.ink,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  'CB',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.fromLTRB(6, 6, 14, 6),
              decoration: BoxDecoration(
                color: AppColors.card,
                border: Border.all(color: AppColors.line),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: AppColors.ink,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        'CB',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cliente Fondos',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.ink,
                          height: 1.2,
                        ),
                      ),
                      Text(
                        'ID · 000-4821',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 10,
                          color: AppColors.muted2,
                          letterSpacing: 0.04,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Desktop Layout ──────────────────────────────────────────────────────────

class _DesktopLayout extends StatelessWidget {
  final FundsState state;
  const _DesktopLayout({required this.state});

  double get _fpvInvested => state.activeSubscriptions
      .where((s) => s.fund.category.name == 'fpv')
      .fold(0.0, (sum, s) => sum + s.amount);

  double get _ficInvested => state.activeSubscriptions
      .where((s) => s.fund.category.name == 'fic')
      .fold(0.0, (sum, s) => sum + s.amount);

  @override
  Widget build(BuildContext context) {
    final invested = _fpvInvested + _ficInvested;

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1440),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 28, 40, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero row
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 155,
                      child: HeroBalanceCard(
                        balance: state.balance,
                        invested: invested,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 100,
                      child: AllocationCard(
                        fpvAmount: _fpvInvested,
                        ficAmount: _ficInvested,
                        available: state.balance,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Main grid
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Funds panel (spans 2 rows)
                  Expanded(
                    flex: 17,
                    child: _PanelCard(
                      kicker: '01 / Oportunidades',
                      title: 'Fondos disponibles',
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.ink,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          '${state.funds.length}',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      noPadding: true,
                      child: FundsTable(
                        funds: state.funds,
                        onSubscribe: (fund) => SubscriptionDialog.show(
                          context: context,
                          fund: fund,
                          balance: state.balance,
                          onConfirm: (amount, channel) =>
                              context.read<FundsBloc>().add(
                                FundSubscribed(
                                  fund: fund,
                                  amount: amount,
                                  channel: channel,
                                ),
                              ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Right column: subs + activity stacked
                  Expanded(
                    flex: 10,
                    child: Column(
                      children: [
                        _PanelCard(
                          kicker: '02 / En curso',
                          title: 'Suscripciones activas',
                          trailing: _Badge(
                            '${state.activeSubscriptions.length}',
                          ),
                          child: ActiveSubscriptionsPanel(
                            subscriptions: state.activeSubscriptions,
                            onCancel: (id) => context.read<FundsBloc>().add(
                              SubscriptionCancelled(id),
                            ),
                            isProcessing: state.isProcessingAction,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _ActivityPanel(state: state),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              _Footer(),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Mobile Layout ───────────────────────────────────────────────────────────

class _MobileLayout extends StatefulWidget {
  final FundsState state;
  const _MobileLayout({required this.state});

  @override
  State<_MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<_MobileLayout> {
  double get _fpvInvested => widget.state.activeSubscriptions
      .where((s) => s.fund.category.name == 'fpv')
      .fold(0.0, (sum, s) => sum + s.amount);

  double get _ficInvested => widget.state.activeSubscriptions
      .where((s) => s.fund.category.name == 'fic')
      .fold(0.0, (sum, s) => sum + s.amount);

  @override
  Widget build(BuildContext context) {
    final invested = _fpvInvested + _ficInvested;
    final state = widget.state;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeroBalanceCard(balance: state.balance, invested: invested),
          const SizedBox(height: 16),
          AllocationCard(
            fpvAmount: _fpvInvested,
            ficAmount: _ficInvested,
            available: state.balance,
          ),
          const SizedBox(height: 16),

          // Funds panel
          _PanelCard(
            kicker: '01 / Oportunidades',
            title: 'Fondos disponibles',
            trailing: _Badge('${state.funds.length}'),
            child: Column(
              children: state.funds.map((f) => FundCard(
                fund: f,
                onSubscribe: () => SubscriptionDialog.show(
                  context: context,
                  fund: f,
                  balance: state.balance,
                  onConfirm: (amount, channel) =>
                      context.read<FundsBloc>().add(
                        FundSubscribed(
                          fund: f,
                          amount: amount,
                          channel: channel,
                        ),
                      ),
                ),
              )).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Active subs
          _PanelCard(
            kicker: '02 / En curso',
            title: 'Suscripciones activas',
            trailing: _Badge('${state.activeSubscriptions.length}'),
            child: ActiveSubscriptionsPanel(
              subscriptions: state.activeSubscriptions,
              onCancel: (id) =>
                  context.read<FundsBloc>().add(SubscriptionCancelled(id)),
              isProcessing: state.isProcessingAction,
            ),
          ),
          const SizedBox(height: 16),

          // Activity
          _ActivityPanel(state: state),
          const SizedBox(height: 24),
          _Footer(),
        ],
      ),
    );
  }
}

// ─── Shared Widgets ──────────────────────────────────────────────────────────

class _PanelCard extends StatelessWidget {
  final String kicker;
  final String title;
  final Widget? trailing;
  final Widget child;
  final bool noPadding;

  const _PanelCard({
    required this.kicker,
    required this.title,
    this.trailing,
    required this.child,
    this.noPadding = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        kicker,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 10,
                          color: AppColors.muted2,
                          letterSpacing: 0.1,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.ink,
                          letterSpacing: -0.01,
                        ),
                      ),
                    ],
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
          const Divider(height: 1),
          noPadding
              ? child
              : Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
                  child: child,
                ),
        ],
      ),
    );
  }
}

class _ActivityPanel extends StatefulWidget {
  final FundsState state;
  const _ActivityPanel({required this.state});

  @override
  State<_ActivityPanel> createState() => _ActivityPanelState();
}

class _ActivityPanelState extends State<_ActivityPanel> {
  int _filterIndex = 0;

  List get _filtered {
    if (_filterIndex == 1) {
      return widget.state.transactions
          .where((t) => t.type.name == 'subscription')
          .toList();
    }
    if (_filterIndex == 2) {
      return widget.state.transactions
          .where((t) => t.type.name == 'cancellation')
          .toList();
    }
    return widget.state.transactions;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '03 / Historial',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 10,
                          color: AppColors.muted2,
                          letterSpacing: 0.1,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Movimientos',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.ink,
                          letterSpacing: -0.01,
                        ),
                      ),
                    ],
                  ),
                ),
                SegmentedControl(
                  options: const ['Todos', 'Susc.', 'Cancel.'],
                  selectedIndex: _filterIndex,
                  onChanged: (i) => setState(() => _filterIndex = i),
                  small: true,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
            child: TransactionHistoryPanel(
              transactions: List.from(_filtered),
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  const _Badge(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 24),
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Center(
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          'Funds App · Prueba técnica',
          style: GoogleFonts.jetBrainsMono(
            fontSize: 11,
            color: AppColors.muted2,
            letterSpacing: 0.02,
          ),
        ),
        Text('·',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 11,
              color: AppColors.muted2,
            )),
        Text(
          'Saldo inicial COP \$500.000 · Datos en memoria',
          style: GoogleFonts.jetBrainsMono(
            fontSize: 11,
            color: AppColors.muted2,
            letterSpacing: 0.02,
          ),
        ),
        Text('·',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 11,
              color: AppColors.muted2,
            )),
        GestureDetector(
          onTap: () => _confirmReset(context),
          child: Text(
            'Restablecer',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 11,
              color: AppColors.ink,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.ink,
              letterSpacing: 0.02,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _confirmReset(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        ),
        title: Text(
          'Restablecer estado',
          style: GoogleFonts.instrumentSerif(
            fontSize: 22,
            fontWeight: FontWeight.w400,
            color: AppColors.ink,
          ),
        ),
        content: Text(
          'Esto devolverá el saldo a \$500.000 COP y eliminará todas las suscripciones y movimientos.',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: AppColors.muted,
            height: 1.55,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Restablecer'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<FundsBloc>().add(const StateReset());
    }
  }
}
