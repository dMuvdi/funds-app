import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/entities/fund.dart';
import '../../domain/entities/notification_channel.dart';
import '../bloc/funds_bloc.dart';
import '../bloc/funds_state.dart';

String _fmtNum(double v) => NumberFormat('#,##0', 'es_CO').format(v);

class SubscriptionDialog extends StatefulWidget {
  final Fund fund;
  final double balance;
  final Function(double amount, NotificationChannel channel) onConfirm;
  final bool isLoading;

  const SubscriptionDialog({
    super.key,
    required this.fund,
    required this.balance,
    required this.onConfirm,
    this.isLoading = false,
  });

  @override
  State<SubscriptionDialog> createState() => _SubscriptionDialogState();

  static Future<void> show({
    required BuildContext context,
    required Fund fund,
    required double balance,
    required Function(double, NotificationChannel) onConfirm,
    bool isLoading = false,
  }) {
    final fundsBloc = context.read<FundsBloc>();
    final desktop = isDesktop(context);

    Widget wrap(BuildContext dialogContext) => BlocProvider<FundsBloc>.value(
      value: fundsBloc,
      child: BlocListener<FundsBloc, FundsState>(
        listenWhen: (prev, cur) =>
            prev.isProcessingAction != cur.isProcessingAction ||
            prev.actionSuccessMessage != cur.actionSuccessMessage,
        listener: (_, state) {
          if (!state.isProcessingAction && state.actionSuccessMessage != null) {
            Navigator.of(dialogContext).pop();
          }
        },
        child: BlocBuilder<FundsBloc, FundsState>(
          builder: (_, state) => SubscriptionDialog(
            fund: fund,
            balance: balance,
            onConfirm: onConfirm,
            isLoading: state.isProcessingAction,
          ),
        ),
      ),
    );

    if (desktop) {
      return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          ),
          insetPadding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 820),
            child: wrap(ctx),
          ),
        ),
      );
    } else {
      return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusXl),
          ),
        ),
        builder: (ctx) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: SafeArea(child: SingleChildScrollView(child: wrap(ctx))),
        ),
      );
    }
  }
}

class _SubscriptionDialogState extends State<SubscriptionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  NotificationChannel _channel = NotificationChannel.email;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double? get _parsedAmount => double.tryParse(_controller.text);

  double get _remaining =>
      widget.balance - (_parsedAmount ?? 0);

  String? _validate(String? v) {
    if (v == null || v.isEmpty) return 'Ingrese un monto';
    final a = double.tryParse(v);
    if (a == null) return 'Monto inválido';
    if (a < widget.fund.minAmount) {
      return 'Mínimo: \$${_fmtNum(widget.fund.minAmount)}';
    }
    if (a > widget.balance) return 'Saldo insuficiente';
    return null;
  }

  void _setQuick(double v) {
    _controller.text = v.toStringAsFixed(0);
    setState(() {});
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onConfirm(_parsedAmount!, _channel);
    }
  }

  @override
  Widget build(BuildContext context) {
    final desktop = isDesktop(context);

    return ClipRRect(
      borderRadius: desktop
          ? BorderRadius.circular(AppSpacing.radiusXl)
          : const BorderRadius.vertical(
              top: Radius.circular(AppSpacing.radiusXl),
            ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Header(fund: widget.fund),
          desktop
              ? _DesktopBody(
                  fund: widget.fund,
                  balance: widget.balance,
                  remaining: _remaining,
                  formKey: _formKey,
                  controller: _controller,
                  channel: _channel,
                  isLoading: widget.isLoading,
                  onChannelChange: (c) => setState(() => _channel = c),
                  onQuick: _setQuick,
                  onValidate: _validate,
                  onSubmit: _submit,
                  onCancel: () => Navigator.of(context).pop(),
                  onChanged: () => setState(() {}),
                )
              : _MobileBody(
                  fund: widget.fund,
                  balance: widget.balance,
                  remaining: _remaining,
                  formKey: _formKey,
                  controller: _controller,
                  channel: _channel,
                  isLoading: widget.isLoading,
                  onChannelChange: (c) => setState(() => _channel = c),
                  onQuick: _setQuick,
                  onValidate: _validate,
                  onSubmit: _submit,
                  onCancel: () => Navigator.of(context).pop(),
                  onChanged: () => setState(() {}),
                ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final Fund fund;
  const _Header({required this.fund});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '01 / NUEVA SUSCRIPCIÓN',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 10,
                    color: AppColors.muted2,
                    letterSpacing: 0.12,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Invertir en ${fund.name}',
                  style: GoogleFonts.instrumentSerif(
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                    color: AppColors.ink,
                    letterSpacing: -0.01,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            color: AppColors.muted,
            splashRadius: 18,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

class _DesktopBody extends StatelessWidget {
  final Fund fund;
  final double balance;
  final double remaining;
  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  final NotificationChannel channel;
  final bool isLoading;
  final ValueChanged<NotificationChannel> onChannelChange;
  final ValueChanged<double> onQuick;
  final FormFieldValidator<String> onValidate;
  final VoidCallback onSubmit;
  final VoidCallback onCancel;
  final VoidCallback onChanged;

  const _DesktopBody({
    required this.fund,
    required this.balance,
    required this.remaining,
    required this.formKey,
    required this.controller,
    required this.channel,
    required this.isLoading,
    required this.onChannelChange,
    required this.onQuick,
    required this.onValidate,
    required this.onSubmit,
    required this.onCancel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _FieldLabel('Monto a invertir'),
                    const SizedBox(height: 8),
                    _AmountField(
                      controller: controller,
                      isLoading: isLoading,
                      validator: onValidate,
                      onChanged: (_) => onChanged(),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Mínimo: \$${_fmtNum(fund.minAmount)}',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppColors.muted,
                          ),
                        ),
                        Text(
                          'Saldo: \$${_fmtNum(balance)}',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _QuickChips(
                      fund: fund,
                      balance: balance,
                      onQuick: onQuick,
                    ),
                    const SizedBox(height: 24),
                    const _FieldLabel('Canal de notificación'),
                    const SizedBox(height: 12),
                    _ChannelGrid(
                      selected: channel,
                      onChanged: onChannelChange,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: isLoading ? null : onCancel,
                          child: const Text('Cancelar'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: 260,
            decoration: const BoxDecoration(
              color: AppColors.paper,
              border: Border(left: BorderSide(color: AppColors.line)),
            ),
            padding: const EdgeInsets.all(28),
            child: _Summary(
              fund: fund,
              balance: balance,
              remaining: remaining,
              controller: controller,
              isLoading: isLoading,
              onSubmit: onSubmit,
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileBody extends StatelessWidget {
  final Fund fund;
  final double balance;
  final double remaining;
  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  final NotificationChannel channel;
  final bool isLoading;
  final ValueChanged<NotificationChannel> onChannelChange;
  final ValueChanged<double> onQuick;
  final FormFieldValidator<String> onValidate;
  final VoidCallback onSubmit;
  final VoidCallback onCancel;
  final VoidCallback onChanged;

  const _MobileBody({
    required this.fund,
    required this.balance,
    required this.remaining,
    required this.formKey,
    required this.controller,
    required this.channel,
    required this.isLoading,
    required this.onChannelChange,
    required this.onQuick,
    required this.onValidate,
    required this.onSubmit,
    required this.onCancel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _FieldLabel('Monto a invertir'),
              const SizedBox(height: 8),
              _AmountField(
                controller: controller,
                isLoading: isLoading,
                validator: onValidate,
                onChanged: (_) => onChanged(),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mínimo: \$${_fmtNum(fund.minAmount)}',
                    style: GoogleFonts.inter(fontSize: 11, color: AppColors.muted),
                  ),
                  Text(
                    'Saldo: \$${_fmtNum(balance)}',
                    style: GoogleFonts.inter(fontSize: 11, color: AppColors.muted),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _QuickChips(fund: fund, balance: balance, onQuick: onQuick),
              const SizedBox(height: 20),
              const _FieldLabel('Canal de notificación'),
              const SizedBox(height: 12),
              _ChannelGrid(selected: channel, onChanged: onChannelChange),
              const SizedBox(height: 20),
              _Summary(
                fund: fund,
                balance: balance,
                remaining: remaining,
                controller: controller,
                isLoading: isLoading,
                onSubmit: onSubmit,
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: isLoading ? null : onCancel,
                child: const Text('Cancelar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.ink,
        letterSpacing: -0.005,
      ),
    );
  }
}

class _AmountField extends StatelessWidget {
  final TextEditingController controller;
  final bool isLoading;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onChanged;

  const _AmountField({
    required this.controller,
    required this.isLoading,
    required this.validator,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 16, right: 4, top: 4),
          child: Text(
            '\$',
            style: GoogleFonts.instrumentSerif(
              fontSize: 28,
              color: AppColors.muted,
            ),
          ),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        suffix: Text(
          'COP',
          style: GoogleFonts.jetBrainsMono(
            fontSize: 11,
            color: AppColors.muted2,
            letterSpacing: 0.08,
          ),
        ),
        hintText: '0',
        hintStyle: GoogleFonts.instrumentSerif(
          fontSize: 32,
          color: AppColors.muted2,
        ),
      ),
      style: GoogleFonts.instrumentSerif(
        fontSize: 32,
        fontWeight: FontWeight.w400,
        color: AppColors.ink,
        letterSpacing: -0.01,
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: validator,
      enabled: !isLoading,
      onChanged: onChanged,
    );
  }
}

class _QuickChips extends StatelessWidget {
  final Fund fund;
  final double balance;
  final ValueChanged<double> onQuick;

  const _QuickChips({
    required this.fund,
    required this.balance,
    required this.onQuick,
  });

  @override
  Widget build(BuildContext context) {
    final min = fund.minAmount;
    final chips = [
      ('Mín.', min),
      ('2×', min * 2),
      ('Máx.', balance),
    ];

    return Wrap(
      spacing: 8,
      children: chips.map((c) {
        final enabled = c.$2 <= balance && c.$2 >= min;
        return GestureDetector(
          onTap: enabled ? () => onQuick(c.$2) : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.paper,
              border: Border.all(color: AppColors.line),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              c.$1,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: enabled ? AppColors.ink : AppColors.muted2,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ChannelGrid extends StatelessWidget {
  final NotificationChannel selected;
  final ValueChanged<NotificationChannel> onChanged;

  const _ChannelGrid({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: NotificationChannel.values.map((c) {
        final sel = selected == c;
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(c),
            child: Container(
              margin: EdgeInsets.only(
                right: c == NotificationChannel.values.last ? 0 : 10,
              ),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: sel ? AppColors.paper : AppColors.card,
                border: Border.all(
                  color: sel ? AppColors.ink : AppColors.line,
                ),
                borderRadius: BorderRadius.circular(AppSpacing.radius),
              ),
              child: Row(
                children: [
                  Icon(
                    c == NotificationChannel.email
                        ? Icons.email_outlined
                        : Icons.sms_outlined,
                    size: 20,
                    color: AppColors.muted,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          c.label,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.ink,
                          ),
                        ),
                        Text(
                          c == NotificationChannel.email
                              ? 'usuario@email.com'
                              : '+57 ··· ···',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 10,
                            color: AppColors.muted2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: sel ? AppColors.ink : AppColors.lineStrong,
                        width: 1.5,
                      ),
                    ),
                    child: sel
                        ? Center(
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.ink,
                                shape: BoxShape.circle,
                              ),
                            ),
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _Summary extends StatelessWidget {
  final Fund fund;
  final double balance;
  final double remaining;
  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback onSubmit;

  const _Summary({
    required this.fund,
    required this.balance,
    required this.remaining,
    required this.controller,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final amount = double.tryParse(controller.text) ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'RESUMEN',
          style: GoogleFonts.jetBrainsMono(
            fontSize: 10,
            color: AppColors.muted2,
            letterSpacing: 0.12,
          ),
        ),
        const SizedBox(height: 16),
        _SumRow(label: 'Fondo', value: fund.name),
        const SizedBox(height: 12),
        _SumRow(label: 'Categoría', value: fund.category.name.toUpperCase()),
        const SizedBox(height: 12),
        _SumRow(label: 'Monto mín.', value: '\$${_fmtNum(fund.minAmount)}'),
        const SizedBox(height: 12),
        Container(height: 1, color: AppColors.line),
        const SizedBox(height: 12),
        _SumRow(
          label: 'Tu inversión',
          value: amount > 0 ? '\$${_fmtNum(amount)}' : '—',
          valueLarge: true,
        ),
        const SizedBox(height: 12),
        _SumRow(
          label: 'Saldo restante',
          value: amount > 0
              ? '\$${_fmtNum(remaining > 0 ? remaining : 0)}'
              : '\$${_fmtNum(balance)}',
        ),
        const SizedBox(height: 20),
        PrimaryButton(
          text: 'Confirmar inversión',
          onPressed: onSubmit,
          isLoading: isLoading,
          fullWidth: true,
        ),
        const SizedBox(height: 12),
        Text(
          'Al confirmar, el monto se debitará inmediatamente de tu saldo.',
          style: GoogleFonts.inter(
            fontSize: 11,
            color: AppColors.muted,
            height: 1.55,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _SumRow extends StatelessWidget {
  final String label;
  final String value;
  final bool valueLarge;

  const _SumRow({
    required this.label,
    required this.value,
    this.valueLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 12, color: AppColors.muted),
        ),
        Flexible(
          child: Text(
            value,
            style: valueLarge
                ? GoogleFonts.instrumentSerif(
                    fontSize: 20,
                    color: AppColors.ink,
                    fontWeight: FontWeight.w400,
                  )
                : GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
