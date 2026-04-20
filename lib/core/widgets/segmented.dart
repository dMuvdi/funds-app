import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class SegmentedControl extends StatelessWidget {
  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final bool small;

  const SegmentedControl({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onChanged,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.paper2,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(options.length, (i) {
          final selected = i == selectedIndex;
          return GestureDetector(
            onTap: () => onChanged(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: small
                  ? const EdgeInsets.symmetric(horizontal: 10, vertical: 4)
                  : const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: selected ? AppColors.card : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: AppColors.ink.withValues(alpha: 0.04),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                options[i],
                style: GoogleFonts.inter(
                  fontSize: small ? 11 : 12,
                  fontWeight: FontWeight.w500,
                  color: selected ? AppColors.ink : AppColors.muted,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
