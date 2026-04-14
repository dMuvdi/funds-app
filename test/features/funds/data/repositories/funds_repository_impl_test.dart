import 'package:flutter_test/flutter_test.dart';
import 'package:amaris_technical_test/core/error/exceptions.dart';
import 'package:amaris_technical_test/features/funds/data/datasources/funds_local_datasource.dart';
import 'package:amaris_technical_test/features/funds/data/models/fund_model.dart';
import 'package:amaris_technical_test/features/funds/data/models/subscription_model.dart';
import 'package:amaris_technical_test/features/funds/data/repositories/funds_repository_impl.dart';
import 'package:amaris_technical_test/features/funds/domain/entities/fund.dart';
import 'package:amaris_technical_test/features/funds/domain/entities/notification_channel.dart';

void main() {
  late FundsRepositoryImpl repository;
  late FakeFundsLocalDataSource dataSource;

  setUp(() {
    dataSource = FakeFundsLocalDataSource();
    repository = FundsRepositoryImpl(dataSource);
  });

  group('subscribe', () {
    const tFund = FundModel(
      id: 1,
      name: 'Test Fund',
      minAmount: 100000,
      category: FundCategory.fpv,
    );

    test('returns Right<Subscription> on success', () async {
      dataSource.shouldThrowInsufficientBalance = false;
      dataSource.shouldThrowBelowMinimum = false;

      final result = await repository.subscribe(
        fund: tFund,
        amount: 150000,
        channel: NotificationChannel.email,
      );

      expect(result.isRight(), true);
    });

    test(
      'returns Left<InsufficientBalanceFailure> when balance insufficient',
      () async {
        dataSource.shouldThrowInsufficientBalance = true;

        final result = await repository.subscribe(
          fund: tFund,
          amount: 150000,
          channel: NotificationChannel.email,
        );

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(
            failure.runtimeType.toString(),
            'InsufficientBalanceFailure',
          ),
          (_) => fail('Should return failure'),
        );
      },
    );

    test(
      'returns Left<BelowMinimumFailure> when amount below minimum',
      () async {
        dataSource.shouldThrowBelowMinimum = true;

        final result = await repository.subscribe(
          fund: tFund,
          amount: 50000,
          channel: NotificationChannel.email,
        );

        expect(result.isLeft(), true);
        result.fold(
          (failure) =>
              expect(failure.runtimeType.toString(), 'BelowMinimumFailure'),
          (_) => fail('Should return failure'),
        );
      },
    );
  });
}

/// Fake datasource for testing
class FakeFundsLocalDataSource extends FundsLocalDataSource {
  bool shouldThrowInsufficientBalance = false;
  bool shouldThrowBelowMinimum = false;
  bool shouldThrowNotFound = false;

  @override
  Future<SubscriptionModel> subscribe({
    required FundModel fund,
    required double amount,
    required NotificationChannel channel,
  }) async {
    if (shouldThrowInsufficientBalance) {
      throw InsufficientBalanceException(fund.name);
    }
    if (shouldThrowBelowMinimum) {
      throw BelowMinimumException(fund.name, fund.minAmount);
    }
    return super.subscribe(fund: fund, amount: amount, channel: channel);
  }

  @override
  Future<void> cancel(String subscriptionId) async {
    if (shouldThrowNotFound) {
      throw SubscriptionNotFoundException(subscriptionId);
    }
    return super.cancel(subscriptionId);
  }
}
