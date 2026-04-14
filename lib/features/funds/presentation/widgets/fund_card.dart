import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/category_badge.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/entities/fund.dart';

/// Modern fund card displaying fund details
class FundCard extends StatelessWidget {
  final Fund fund;
  final VoidCallback onSubscribe;

  const FundCard({super.key, required this.fund, required this.onSubscribe});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CategoryBadge(category: fund.category),
                const Spacer(),
                Text(
                  'ID: ${fund.id}',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(fund.name, style: AppTypography.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Text(
                  'Monto mínimo: ',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  formatCop(fund.minAmount),
                  style: AppTypography.numberMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(text: 'Suscribirse', onPressed: onSubscribe),
          ],
        ),
      ),
    );
  }
}
