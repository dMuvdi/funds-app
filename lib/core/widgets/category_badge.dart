import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../features/funds/domain/entities/fund.dart';
import '../theme/app_colors.dart';

/// Modern category badge for FPV and FIC funds
class CategoryBadge extends StatelessWidget {
  final FundCategory category;

  const CategoryBadge({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final isFpv = category == FundCategory.fpv;

    return Container(
      height: 26,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: isFpv ? AppColors.fpvBadgeBg : AppColors.ficBadgeBg,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Center(
        child: Text(
          category.name.toUpperCase(),
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: isFpv ? AppColors.fpvBadgeFg : AppColors.ficBadgeFg,
          ),
        ),
      ),
    );
  }
}
