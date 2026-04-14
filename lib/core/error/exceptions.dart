/// Insufficient balance exception
class InsufficientBalanceException implements Exception {
  final String fundName;
  const InsufficientBalanceException(this.fundName);
}

/// Amount below minimum exception
class BelowMinimumException implements Exception {
  final String fundName;
  final double minAmount;
  const BelowMinimumException(this.fundName, this.minAmount);
}

/// Subscription not found exception
class SubscriptionNotFoundException implements Exception {
  final String id;
  const SubscriptionNotFoundException(this.id);
}
