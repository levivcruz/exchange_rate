import 'package:flutter_test/flutter_test.dart';

import 'package:exchange_rate/src/features/home/presentation/cubits/currency_input_cubit.dart';
import 'package:exchange_rate/src/core/shared/validators/currency_validator.dart';

void main() {
  group('CurrencyInputCubit', () {
    late CurrencyInputCubit cubit;

    setUp(() {
      cubit = CurrencyInputCubit();
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state should be CurrencyInputInitial', () {
      expect(cubit.state, const CurrencyInputInitial());
    });

    group('updateCurrency', () {
      test('should emit CurrencyInputInitial when currency is empty', () {
        expectLater(cubit.stream, emits(const CurrencyInputInitial()));

        cubit.updateCurrency('');
      });

      test(
        'should emit CurrencyInputInitial when currency is only whitespace',
        () {
          expectLater(cubit.stream, emits(const CurrencyInputInitial()));

          cubit.updateCurrency('   ');
        },
      );

      test(
        'should emit CurrencyInputUpdated with valid currency when input is valid',
        () {
          const validCurrency = 'USD';

          final expectedState = CurrencyInputUpdated(
            currency: validCurrency,
            isValid: true,
          );

          expectLater(cubit.stream, emits(expectedState));

          cubit.updateCurrency(validCurrency);
        },
      );

      test(
        'should emit CurrencyInputUpdated with invalid currency when input is invalid',
        () {
          const invalidCurrency = 'XXX';

          final expectedState = CurrencyInputUpdated(
            currency: invalidCurrency,
            isValid: false,
          );

          expectLater(cubit.stream, emits(expectedState));

          cubit.updateCurrency(invalidCurrency);
        },
      );

      test('should convert currency to uppercase', () {
        const inputCurrency = 'usd';
        const expectedCurrency = 'USD';

        final expectedState = CurrencyInputUpdated(
          currency: expectedCurrency,
          isValid: true,
        );

        expectLater(cubit.stream, emits(expectedState));

        cubit.updateCurrency(inputCurrency);
      });

      test('should trim whitespace from currency', () {
        const inputCurrency = '  USD  ';
        const expectedCurrency = 'USD';

        final expectedState = CurrencyInputUpdated(
          currency: expectedCurrency,
          isValid: true,
        );

        expectLater(cubit.stream, emits(expectedState));

        cubit.updateCurrency(inputCurrency);
      });

      test('should handle mixed case and whitespace', () {
        const inputCurrency = '  usd  ';
        const expectedCurrency = 'USD';

        final expectedState = CurrencyInputUpdated(
          currency: expectedCurrency,
          isValid: true,
        );

        expectLater(cubit.stream, emits(expectedState));

        cubit.updateCurrency(inputCurrency);
      });
    });

    group('clearCurrency', () {
      test(
        'should emit CurrencyInputInitial when clear is called from initial state',
        () {
          expectLater(cubit.stream, emits(const CurrencyInputInitial()));

          cubit.clearCurrency();
        },
      );

      test(
        'should emit CurrencyInputInitial when clear is called from updated state',
        () {
          cubit.emit(
            const CurrencyInputUpdated(currency: 'USD', isValid: true),
          );

          expectLater(cubit.stream, emits(const CurrencyInputInitial()));

          cubit.clearCurrency();
        },
      );
    });

    group('getErrorMessage', () {
      test('should return null when currency is valid', () {
        cubit.emit(const CurrencyInputUpdated(currency: 'USD', isValid: true));

        final errorMessage = cubit.getErrorMessage();

        expect(errorMessage, isNull);
      });

      test('should return error message when currency is invalid', () {
        cubit.emit(const CurrencyInputUpdated(currency: 'XXX', isValid: false));

        final errorMessage = cubit.getErrorMessage();

        expect(errorMessage, isNotNull);
        expect(errorMessage, contains('Currency code not recognized'));
      });

      test('should return null when in initial state', () {
        final errorMessage = cubit.getErrorMessage();

        expect(errorMessage, isNull);
      });
    });

    group('getSuggestions', () {
      test('should return empty list when currency is valid', () {
        cubit.emit(const CurrencyInputUpdated(currency: 'USD', isValid: true));

        final suggestions = cubit.getSuggestions();

        expect(suggestions, isEmpty);
      });

      test('should return suggestions when currency is invalid', () {
        cubit.emit(const CurrencyInputUpdated(currency: 'US', isValid: false));

        final suggestions = cubit.getSuggestions();

        expect(suggestions, isNotEmpty);

        expect(suggestions.length, greaterThan(0));
        expect(suggestions, contains('USD'));
      });

      test('should return empty list when in initial state', () {
        final suggestions = cubit.getSuggestions();

        expect(suggestions, isEmpty);
      });
    });

    group('State equality', () {
      test('CurrencyInputInitial should be equal to itself', () {
        const state1 = CurrencyInputInitial();
        const state2 = CurrencyInputInitial();
        expect(state1, equals(state2));
      });

      test(
        'CurrencyInputUpdated should be equal when currency and isValid are equal',
        () {
          const state1 = CurrencyInputUpdated(currency: 'USD', isValid: true);
          const state2 = CurrencyInputUpdated(currency: 'USD', isValid: true);
          expect(state1, equals(state2));
        },
      );

      test(
        'CurrencyInputUpdated should not be equal when currency differs',
        () {
          const state1 = CurrencyInputUpdated(currency: 'USD', isValid: true);
          const state2 = CurrencyInputUpdated(currency: 'EUR', isValid: true);
          expect(state1, isNot(equals(state2)));
        },
      );

      test('CurrencyInputUpdated should not be equal when isValid differs', () {
        const state1 = CurrencyInputUpdated(currency: 'USD', isValid: true);
        const state2 = CurrencyInputUpdated(currency: 'USD', isValid: false);
        expect(state1, isNot(equals(state2)));
      });
    });

    group('Integration with CurrencyValidator', () {
      test('should validate USD as valid currency', () {
        final expectedState = CurrencyInputUpdated(
          currency: 'USD',
          isValid: CurrencyValidator.isValid('USD'),
        );

        expectLater(cubit.stream, emits(expectedState));

        cubit.updateCurrency('USD');
      });

      test('should validate EUR as valid currency', () {
        final expectedState = CurrencyInputUpdated(
          currency: 'EUR',
          isValid: CurrencyValidator.isValid('EUR'),
        );

        expectLater(cubit.stream, emits(expectedState));

        cubit.updateCurrency('EUR');
      });

      test('should validate BRL as valid currency', () {
        final expectedState = CurrencyInputUpdated(
          currency: 'BRL',
          isValid: CurrencyValidator.isValid('BRL'),
        );

        expectLater(cubit.stream, emits(expectedState));

        cubit.updateCurrency('BRL');
      });

      test('should validate invalid currency codes', () {
        final expectedState = CurrencyInputUpdated(
          currency: 'XXX',
          isValid: false,
        );

        expectLater(cubit.stream, emits(expectedState));

        cubit.updateCurrency('XXX');
      });
    });
  });
}
