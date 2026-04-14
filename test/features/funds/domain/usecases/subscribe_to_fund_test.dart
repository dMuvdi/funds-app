import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:amaris_technical_test/core/error/failures.dart';
import 'package:amaris_technical_test/features/funds/domain/entities/fund.dart';
import 'package:amaris_technical_test/features/funds/domain/entities/notification_channel.dart';
import 'package:amaris_technical_test/features/funds/domain/entities/subscription.dart';
import 'package:amaris_technical_test/features/funds/domain/usecases/subscribe_to_fund.dart';
import '../../../../helpers/test_helpers.mocks.dart';

void main() {
  late SubscribeToFund useCase;
  late MockFundsRepository mockRepository;

  setUp(() {
    mockRepository = MockFundsRepository();
    useCase = SubscribeToFund(mockRepository);
  });

  const tFund = Fund(
    id: 1,
    name: 'Test Fund',
    minAmount: 100000,
    category: FundCategory.fpv,
  );
  const tAmount = 150000.0;
  const tChannel = NotificationChannel.email;

  final tSubscription = Subscription(
    id: 'sub_123',
    fund: tFund,
    amount: tAmount,
    channel: tChannel,
    createdAt: DateTime(2026, 4, 13),
  );

  test('should forward call to repository and return result', () async {
    // Arrange
    when(
      mockRepository.subscribe(
        fund: anyNamed('fund'),
        amount: anyNamed('amount'),
        channel: anyNamed('channel'),
      ),
    ).thenAnswer((_) async => Right(tSubscription));

    // Act
    final result = await useCase(
      fund: tFund,
      amount: tAmount,
      channel: tChannel,
    );

    // Assert
    expect(result, Right(tSubscription));
    verify(
      mockRepository.subscribe(fund: tFund, amount: tAmount, channel: tChannel),
    ).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return failure when repository fails', () async {
    // Arrange
    const tFailure = InsufficientBalanceFailure('Test Fund');
    when(
      mockRepository.subscribe(
        fund: anyNamed('fund'),
        amount: anyNamed('amount'),
        channel: anyNamed('channel'),
      ),
    ).thenAnswer((_) async => const Left(tFailure));

    // Act
    final result = await useCase(
      fund: tFund,
      amount: tAmount,
      channel: tChannel,
    );

    // Assert
    expect(result, const Left(tFailure));
  });
}
