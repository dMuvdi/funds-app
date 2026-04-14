import 'package:flutter_test/flutter_test.dart';
import 'package:amaris_technical_test/core/utils/currency_formatter.dart';

void main() {
  group('formatCop', () {
    test('formats 500000 correctly', () {
      expect(formatCop(500000), r'$ 500.000 COP');
    });

    test('formats 0 correctly', () {
      expect(formatCop(0), r'$ 0 COP');
    });

    test('formats large numbers correctly', () {
      expect(formatCop(1000000), r'$ 1.000.000 COP');
    });

    test('formats small numbers correctly', () {
      expect(formatCop(50000), r'$ 50.000 COP');
    });
  });
}
