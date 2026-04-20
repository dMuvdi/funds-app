import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../domain/entities/subscription.dart';

class ActiveSubscriptionsPanel extends StatelessWidget {
  final List<Subscription> subscriptions;
  final Function(String subscriptionId) onCancel;
  final bool isProcessing;

  const ActiveSubscriptionsPanel({
    super.key,
    required this.subscriptions,
    required this.onCancel,
    this.isProcessing = false,
  });

  @override
  Widget build(BuildContext context) {
    if (subscriptions.isEmpty) {
      return const EmptyState(
        icon: Icons.credit_card_outlined,
        title: 'Aún no tienes suscripciones',
        subtitle: 'Elige un fondo de la lista y suscríbete para comenzar.',
      );
    }

    return Column(
      children: subscriptions.map((sub) => _SubItem(
        sub: sub,
        isProcessing: isProcessing,
        onCancel: onCancel,
      )).toList(),
    );
  }
}

class _SubItem extends StatelessWidget {
  final Subscription sub;
  final bool isProcessing;
  final Function(String) onCancel;

  const _SubItem({
    required this.sub,
    required this.isProcessing,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final since = DateFormat('dd MMM yyyy', 'es').format(sub.createdAt);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.paper,
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(AppSpacing.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  sub.fund.name,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                    letterSpacing: -0.005,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              GestureDetector(
                onTap: isProcessing
                    ? null
                    : () => _confirmCancel(context, sub),
                child: Text(
                  '✕ Cancelar',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.muted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              _StatCell(label: 'CANAL', value: sub.channel.label),
              const SizedBox(width: AppSpacing.md),
              _StatCell(label: 'MONTO', value: formatCop(sub.amount)),
              const SizedBox(width: AppSpacing.md),
              _StatCell(label: 'DESDE', value: since),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _confirmCancel(BuildContext context, Subscription sub) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        ),
        title: Text(
          'Cancelar suscripción',
          style: GoogleFonts.instrumentSerif(
            fontSize: 22,
            fontWeight: FontWeight.w400,
            color: AppColors.ink,
          ),
        ),
        content: Text(
          '¿Estás seguro de cancelar ${sub.fund.name}? El monto será devuelto a tu saldo disponible.',
          style: GoogleFonts.inter(fontSize: 13, color: AppColors.muted, height: 1.55),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sí, cancelar'),
          ),
        ],
      ),
    );
    if (confirmed == true) onCancel(sub.id);
  }
}

class _StatCell extends StatelessWidget {
  final String label;
  final String value;

  const _StatCell({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              color: AppColors.muted2,
              letterSpacing: 0.08,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
