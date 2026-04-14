import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../domain/entities/transaction.dart';

/// Modern panel displaying transaction history
class TransactionHistoryPanel extends StatelessWidget {
  final List<Transaction> transactions;

  const TransactionHistoryPanel({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: EmptyState(
          icon: Icons.receipt_long_outlined,
          title: 'Sin movimientos',
          subtitle: 'Sin movimientos todavía',
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final tx = transactions[index];
        final isSubscription = tx.type == TransactionType.subscription;

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 0,
            vertical: AppSpacing.md,
          ),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSubscription
                  ? AppColors.error.withValues(alpha: 0.1)
                  : AppColors.success.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isSubscription ? Icons.arrow_downward : Icons.arrow_upward,
              color: isSubscription ? AppColors.error : AppColors.success,
              size: 20,
            ),
          ),
          title: Text(
            tx.fund.name,
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                DateFormat('dd/MM/yyyy HH:mm').format(tx.timestamp),
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              if (tx.channel != null)
                Text(
                  'Canal: ${tx.channel!.label}',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
            ],
          ),
          trailing: Text(
            '${isSubscription ? '-' : '+'} ${formatCop(tx.amount)}',
            style: AppTypography.numberBody.copyWith(
              color: isSubscription ? AppColors.error : AppColors.success,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
      },
    );
  }
}
