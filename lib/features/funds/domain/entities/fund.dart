import 'package:equatable/equatable.dart';

/// Fund category types
enum FundCategory { fpv, fic }

/// Fund entity representing an investment fund
class Fund extends Equatable {
  final int id;
  final String name;
  final double minAmount;
  final FundCategory category;

  const Fund({
    required this.id,
    required this.name,
    required this.minAmount,
    required this.category,
  });

  @override
  List<Object?> get props => [id, name, minAmount, category];
}
