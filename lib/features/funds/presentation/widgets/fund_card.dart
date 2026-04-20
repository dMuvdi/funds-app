import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/category_badge.dart';
import '../../domain/entities/fund.dart';

String fundDescription(Fund fund) {
  const desc = {
    'FPV_BTG_PACTUAL_RECAUDADORA': 'Recaudo voluntario · riesgo bajo',
    'FPV_BTG_PACTUAL_ECOPETROL': 'Sector energético · riesgo medio',
    'DEUDAPRIVADA': 'Deuda privada corporativa · riesgo bajo',
    'FDO-ACCIONES': 'Acciones locales · riesgo alto',
    'FPV_BTG_PACTUAL_DINAMICA': 'Portafolio dinámico · riesgo medio',
  };
  return desc[fund.name] ?? fund.category.name.toUpperCase();
}

class FundCard extends StatelessWidget {
  final Fund fund;
  final VoidCallback onSubscribe;

  const FundCard({super.key, required this.fund, required this.onSubscribe});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                fund.id.toString().padLeft(2, '0'),
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  color: AppColors.muted2,
                  letterSpacing: 0.04,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              CategoryBadge(category: fund.category),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            fund.name,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
              letterSpacing: -0.005,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            fundDescription(fund),
            style: GoogleFonts.inter(
              fontSize: 11,
              color: AppColors.muted,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MONTO MÍN.',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: AppColors.muted2,
                      letterSpacing: 0.06,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    formatCop(fund.minAmount),
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
                  ),
                ],
              ),
              SubscribeButton(onPressed: onSubscribe),
            ],
          ),
        ],
      ),
    );
  }
}

class SubscribeButton extends StatefulWidget {
  final VoidCallback onPressed;
  const SubscribeButton({super.key, required this.onPressed});

  @override
  State<SubscribeButton> createState() => _SubscribeButtonState();
}

class _SubscribeButtonState extends State<SubscribeButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.ink2 : AppColors.ink,
            borderRadius: BorderRadius.circular(AppSpacing.radius),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Suscribirse',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: -0.005,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.arrow_forward,
                size: 13,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
