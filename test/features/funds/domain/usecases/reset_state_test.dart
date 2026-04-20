import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:amaris_technical_test/core/error/failures.dart';
import 'package:amaris_technical_test/features/funds/domain/usecases/reset_state.dart';
import '../../../../helpers/test_helpers.mocks.dart';

void main() {
  late ResetState useCase;
  late MockFundsRepository mockRepository;

  setUp(() {
    mockRepository = MockFundsRepository();
    useCase = ResetState(mockRepository);
  });

  test('should forward call to repository and return Right(unit)', () async {
    // Arrange
    when(mockRepository.resetState()).thenAnswer((_) async => const Right(unit));

    // Act
    final result = await useCase();

    // Assert
    expect(result, const Right(unit));
    verify(mockRepository.resetState()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return failure when repository fails', () async {
    // Arrange
    const tFailure = UnexpectedFailure('Reset failed');
    when(
      mockRepository.resetState(),
    ).thenAnswer((_) async => const Left(tFailure));

    // Act
    final result = await useCase();

    // Assert
    expect(result, const Left(tFailure));
  });
}
