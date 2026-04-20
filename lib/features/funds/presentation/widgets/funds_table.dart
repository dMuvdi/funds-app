import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/category_badge.dart';
import '../../../../core/widgets/segmented.dart';
import '../../domain/entities/fund.dart';
import 'fund_card.dart' show fundDescription, SubscribeButton;

class FundsTable extends StatefulWidget {
  final List<Fund> funds;
  final void Function(Fund) onSubscribe;

  const FundsTable({
    super.key,
    required this.funds,
    required this.onSubscribe,
  });

  @override
  State<FundsTable> createState() => _FundsTableState();
}

class _FundsTableState extends State<FundsTable> {
  int _filterIndex = 0; // 0=All, 1=FPV, 2=FIC

  List<Fund> get _filtered {
    if (_filterIndex == 1) {
      return widget.funds
          .where((f) => f.category.name == 'fpv')
          .toList();
    }
    if (_filterIndex == 2) {
      return widget.funds
          .where((f) => f.category.name == 'fic')
          .toList();
    }
    return widget.funds;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Column(
      children: [
        // Table header row with filter
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    SegmentedControl(
                      options: const ['Todos', 'FPV', 'FIC'],
                      selectedIndex: _filterIndex,
                      onChanged: (i) => setState(() => _filterIndex = i),
                    ),
                  ],
                ),
              ),
              Text(
                '${filtered.length} de ${widget.funds.length}',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  color: AppColors.muted,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        // Column headers
        Container(
          color: AppColors.paper,
          child: _TableHeader(),
        ),
        // Rows
        if (filtered.isEmpty)
          Padding(
            padding: const EdgeInsets.all(48),
            child: Text(
              'Sin fondos para este filtro',
              style: GoogleFonts.inter(fontSize: 13, color: AppColors.muted),
              textAlign: TextAlign.center,
            ),
          )
        else
          ...filtered.map((f) => _FundRow(
            fund: f,
            onSubscribe: () => widget.onSubscribe(f),
          )),
      ],
    );
  }
}

class _TableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final style = GoogleFonts.inter(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      color: AppColors.muted2,
      letterSpacing: 0.06,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          SizedBox(width: 46, child: Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Text('#', style: style),
          )),
          Expanded(child: Text('FONDO', style: style)),
          SizedBox(width: 80, child: Text('TIPO', style: style)),
          SizedBox(width: 140, child: Text(
            'MONTO MÍN.',
            style: style,
            textAlign: TextAlign.right,
          )),
          const SizedBox(width: 24),
          SizedBox(width: 130, child: Text('', style: style)),
        ],
      ),
    );
  }
}

class _FundRow extends StatefulWidget {
  final Fund fund;
  final VoidCallback onSubscribe;

  const _FundRow({required this.fund, required this.onSubscribe});

  @override
  State<_FundRow> createState() => _FundRowState();
}

class _FundRowState extends State<_FundRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Container(
        decoration: BoxDecoration(
          color: _hovered ? AppColors.paper : Colors.transparent,
          border: const Border(
            bottom: BorderSide(color: AppColors.line, width: 1),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 46,
                child: Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: Text(
                    widget.fund.id.toString().padLeft(2, '0'),
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                      color: AppColors.muted2,
                      letterSpacing: 0.04,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.fund.name,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                        letterSpacing: -0.005,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      fundDescription(widget.fund),
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 80,
                child: CategoryBadge(category: widget.fund.category),
              ),
              SizedBox(
                width: 140,
                child: Text(
                  formatCop(widget.fund.minAmount),
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              const SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.only(right: 24),
                child: SubscribeButton(onPressed: widget.onSubscribe),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
