import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/sparkline_painter.dart';

String _fmtNum(double v) =>
    NumberFormat('#,##0', 'es_CO').format(v);

class HeroBalanceCard extends StatelessWidget {
  final double balance;
  final double invested;

  const HeroBalanceCard({
    super.key,
    required this.balance,
    required this.invested,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SALDO DISPONIBLE · COP',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.muted2,
              letterSpacing: 0.12,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '\$',
                style: GoogleFonts.instrumentSerif(
                  fontSize: 34,
                  fontWeight: FontWeight.w400,
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                _fmtNum(balance),
                style: GoogleFonts.instrumentSerif(
                  fontSize: 72,
                  fontWeight: FontWeight.w400,
                  color: AppColors.ink,
                  letterSpacing: -1.5,
                  height: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _Deltas(balance: balance, invested: invested),
          const SizedBox(height: 18),
          const Sparkline(height: 56),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              'mar 20', 'mar 27', 'abr 3', 'abr 10', 'hoy',
            ].map((l) => Text(
              l,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 10,
                color: AppColors.muted2,
                letterSpacing: 0.04,
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }
}

class _Deltas extends StatelessWidget {
  final double balance;
  final double invested;

  const _Deltas({required this.balance, required this.invested});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 14,
      runSpacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const _DeltaChip(label: '+2,4%', sub: 'últimos 30 días', positive: true),
        _Sep(),
        _MetaItem(label: 'Disponible', value: '\$${_fmtNum(balance)}'),
        _Sep(),
        _MetaItem(label: 'Invertido', value: '\$${_fmtNum(invested)}'),
      ],
    );
  }
}

class _DeltaChip extends StatelessWidget {
  final String label;
  final String sub;
  final bool positive;

  const _DeltaChip({
    required this.label,
    required this.sub,
    required this.positive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: positive ? AppColors.accentSoft : AppColors.dangerSoft,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            positive ? Icons.arrow_upward : Icons.arrow_downward,
            size: 12,
            color: positive ? AppColors.accentInk : AppColors.danger,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: positive ? AppColors.accentInk : AppColors.danger,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            sub,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}

class _Sep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 14, color: AppColors.lineStrong);
  }
}

class _MetaItem extends StatelessWidget {
  final String label;
  final String value;

  const _MetaItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 12, color: AppColors.muted),
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.ink,
          ),
        ),
      ],
    );
  }
}
