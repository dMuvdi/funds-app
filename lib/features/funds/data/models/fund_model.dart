import '../../domain/entities/fund.dart';

/// Fund model with JSON serialization
class FundModel extends Fund {
  const FundModel({
    required super.id,
    required super.name,
    required super.minAmount,
    required super.category,
  });

  factory FundModel.fromJson(Map<String, dynamic> json) => FundModel(
    id: json['id'] as int,
    name: json['name'] as String,
    minAmount: (json['minAmount'] as num).toDouble(),
    category: FundCategory.values.byName(json['category'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'minAmount': minAmount,
    'category': category.name,
  };
}
