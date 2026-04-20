import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../features/funds/domain/entities/fund.dart';
import '../theme/app_colors.dart';

class CategoryBadge extends StatelessWidget {
  final FundCategory category;

  const CategoryBadge({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final isFpv = category == FundCategory.fpv;
    final bg = isFpv ? AppColors.fpvBadgeBg : AppColors.ficBadgeBg;
    final fg = isFpv ? AppColors.fpvBadgeFg : AppColors.ficBadgeFg;
    final dot = isFpv ? AppColors.ink : AppColors.accent;

    return Container(
      padding: const EdgeInsets.only(left: 6, right: 8, top: 3, bottom: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            category.name.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.04,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}
