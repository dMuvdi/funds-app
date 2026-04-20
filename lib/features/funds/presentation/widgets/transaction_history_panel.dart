import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../domain/entities/transaction.dart';

class TransactionHistoryPanel extends StatelessWidget {
  final List<Transaction> transactions;

  const TransactionHistoryPanel({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const EmptyState(
        icon: Icons.access_time_outlined,
        title: 'Sin movimientos',
        subtitle: 'Tus suscripciones y cancelaciones aparecerán aquí.',
      );
    }

    return Column(
      children: List.generate(transactions.length, (i) {
        final tx = transactions[i];
        final isLast = i == transactions.length - 1;
        return _ActivityRow(tx: tx, isLast: isLast);
      }),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final Transaction tx;
  final bool isLast;

  const _ActivityRow({required this.tx, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final isSub = tx.type == TransactionType.subscription;
    final dotBg = isSub ? AppColors.paper2 : AppColors.accentSoft;
    final dotFg = isSub ? AppColors.ink : AppColors.accentInk;
    final amountColor = isSub ? AppColors.ink : AppColors.accentInk;
    final sign = isSub ? '−' : '+';

    final meta = DateFormat('dd MMM yyyy · HH:mm', 'es').format(tx.timestamp);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: isLast
          ? null
          : const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.line, width: 1),
              ),
            ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: dotBg,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isSub ? Icons.arrow_downward : Icons.arrow_upward,
              size: 14,
              color: dotFg,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isSub ? 'Suscripción · ' : 'Cancelación · ',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.muted,
                  ),
                ),
                Text(
                  tx.fund.name,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  meta,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 10,
                    color: AppColors.muted2,
                    letterSpacing: 0.02,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$sign ${formatCop(tx.amount)}',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: amountColor,
            ),
          ),
        ],
      ),
    );
  }
}
