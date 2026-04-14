import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/entities/fund.dart';
import '../../domain/entities/notification_channel.dart';
import '../bloc/funds_bloc.dart';
import '../bloc/funds_state.dart';

/// Modern subscription dialog for fund subscription
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

  /// Show subscription dialog with responsive behavior
  static Future<void> show({
    required BuildContext context,
    required Fund fund,
    required double balance,
    required Function(double, NotificationChannel) onConfirm,
    bool isLoading = false,
  }) {
    // Get the bloc from the parent context
    final fundsBloc = context.read<FundsBloc>();

    if (isDesktop(context)) {
      return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => BlocProvider<FundsBloc>.value(
          value: fundsBloc,
          child: BlocListener<FundsBloc, FundsState>(
            listenWhen: (previous, current) {
              // Only listen when processing state changes
              return previous.isProcessingAction !=
                      current.isProcessingAction ||
                  previous.actionSuccessMessage != current.actionSuccessMessage;
            },
            listener: (listenerContext, state) {
              // Close dialog on successful subscription
              if (!state.isProcessingAction &&
                  state.actionSuccessMessage != null) {
                Navigator.of(dialogContext).pop();
              }
            },
            child: BlocBuilder<FundsBloc, FundsState>(
              builder: (builderContext, state) => Dialog(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: SubscriptionDialog(
                    fund: fund,
                    balance: balance,
                    onConfirm: onConfirm,
                    isLoading: state.isProcessingAction,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        builder: (dialogContext) => BlocProvider<FundsBloc>.value(
          value: fundsBloc,
          child: BlocListener<FundsBloc, FundsState>(
            listenWhen: (previous, current) {
              // Only listen when processing state changes
              return previous.isProcessingAction !=
                      current.isProcessingAction ||
                  previous.actionSuccessMessage != current.actionSuccessMessage;
            },
            listener: (listenerContext, state) {
              // Close dialog on successful subscription
              if (!state.isProcessingAction &&
                  state.actionSuccessMessage != null) {
                Navigator.of(dialogContext).pop();
              }
            },
            child: BlocBuilder<FundsBloc, FundsState>(
              builder: (builderContext, state) => SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(dialogContext).viewInsets.bottom,
                    ),
                    child: SubscriptionDialog(
                      fund: fund,
                      balance: balance,
                      onConfirm: onConfirm,
                      isLoading: state.isProcessingAction,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}

class _SubscriptionDialogState extends State<SubscriptionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  NotificationChannel _selectedChannel = NotificationChannel.email;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  String? _validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingrese un monto';
    }

    final amount = double.tryParse(value);
    if (amount == null) {
      return 'Monto inválido';
    }

    if (amount < widget.fund.minAmount) {
      return 'Monto mínimo: ${formatCop(widget.fund.minAmount)}';
    }

    if (amount > widget.balance) {
      return 'Saldo insuficiente';
    }

    return null;
  }

  void _handleConfirm() {
    if (_formKey.currentState!.validate()) {
      final amount = double.parse(_amountController.text);
      widget.onConfirm(amount, _selectedChannel);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Suscripción', style: AppTypography.headlineMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(
              widget.fund.name,
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surfaceAlt,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Monto mínimo',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        formatCop(widget.fund.minAmount),
                        style: AppTypography.numberMedium.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Su saldo',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        formatCop(widget.balance),
                        style: AppTypography.numberMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Monto a invertir (COP)',
                hintText: '100000',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: _validateAmount,
              enabled: !widget.isLoading,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Canal de notificación:',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              children: NotificationChannel.values.map((channel) {
                return ChoiceChip(
                  label: Text(channel.label),
                  selected: _selectedChannel == channel,
                  onSelected: widget.isLoading
                      ? null
                      : (selected) {
                          if (selected) {
                            setState(() => _selectedChannel = channel);
                          }
                        },
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: widget.isLoading
                      ? null
                      : () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: PrimaryButton(
                    text: 'Confirmar',
                    onPressed: _handleConfirm,
                    isLoading: widget.isLoading,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
