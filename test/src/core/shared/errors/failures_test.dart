import 'package:flutter_test/flutter_test.dart';
import 'package:equatable/equatable.dart';

import 'package:exchange_rate/src/core/shared/errors/failures.dart';

void main() {
  group('Failure', () {
    group('Failure base class', () {
      test('should be abstract and extend Equatable', () {
        expect(Failure, isA<Type>());

        const failure = ServerFailure(message: 'Test error');
        expect(failure, isA<Equatable>());
      });

      test(
        'should have const constructor with required message and optional code',
        () {
          const failure = ServerFailure(message: 'Test error');
          expect(failure.message, equals('Test error'));
          expect(failure.code, isNull);

          const failureWithCode = ServerFailure(
            message: 'Test error',
            code: 'TEST_001',
          );
          expect(failureWithCode.message, equals('Test error'));
          expect(failureWithCode.code, equals('TEST_001'));
        },
      );

      test('should have props containing message and code', () {
        const failure = ServerFailure(message: 'Test error', code: 'TEST_001');

        expect(failure.props, contains('Test error'));
        expect(failure.props, contains('TEST_001'));
        expect(failure.props.length, equals(2));
      });

      test('should have props with null code when code is not provided', () {
        const failure = ServerFailure(message: 'Test error');

        expect(failure.props, contains('Test error'));
        expect(failure.props, contains(null));
        expect(failure.props.length, equals(2));
      });
    });

    group('ServerFailure', () {
      test('should create ServerFailure with required message', () {
        const failure = ServerFailure(message: 'Server error occurred');

        expect(failure, isA<ServerFailure>());
        expect(failure, isA<Failure>());
        expect(failure.message, equals('Server error occurred'));
        expect(failure.code, isNull);
      });

      test('should create ServerFailure with message and code', () {
        const failure = ServerFailure(
          message: 'Server error occurred',
          code: 'SERVER_500',
        );

        expect(failure, isA<ServerFailure>());
        expect(failure, isA<Failure>());
        expect(failure.message, equals('Server error occurred'));
        expect(failure.code, equals('SERVER_500'));
      });

      test('should have const constructor', () {
        const failure = ServerFailure(message: 'Test');
        expect(failure, isA<ServerFailure>());
      });

      test('should extend Failure', () {
        const failure = ServerFailure(message: 'Test');
        expect(failure, isA<Failure>());
      });

      test('should extend Equatable', () {
        const failure = ServerFailure(message: 'Test');
        expect(failure, isA<Equatable>());
      });

      test('props should contain message and code', () {
        const failure = ServerFailure(
          message: 'Server error',
          code: 'SERVER_001',
        );

        expect(failure.props, contains('Server error'));
        expect(failure.props, contains('SERVER_001'));
        expect(failure.props.length, equals(2));
      });

      test('should be equal when message and code are equal', () {
        const failure1 = ServerFailure(
          message: 'Server error',
          code: 'SERVER_001',
        );
        const failure2 = ServerFailure(
          message: 'Server error',
          code: 'SERVER_001',
        );

        expect(failure1, equals(failure2));
        expect(failure1.hashCode, equals(failure2.hashCode));
      });

      test('should not be equal when message differs', () {
        const failure1 = ServerFailure(
          message: 'Server error',
          code: 'SERVER_001',
        );
        const failure2 = ServerFailure(
          message: 'Different error',
          code: 'SERVER_001',
        );

        expect(failure1, isNot(equals(failure2)));
        expect(failure1.hashCode, isNot(equals(failure2.hashCode)));
      });

      test('should not be equal when code differs', () {
        const failure1 = ServerFailure(
          message: 'Server error',
          code: 'SERVER_001',
        );
        const failure2 = ServerFailure(
          message: 'Server error',
          code: 'SERVER_002',
        );

        expect(failure1, isNot(equals(failure2)));
        expect(failure1.hashCode, isNot(equals(failure2.hashCode)));
      });

      test('should handle empty message', () {
        const failure = ServerFailure(message: '');

        expect(failure.message, equals(''));
        expect(failure.code, isNull);
        expect(failure.props, contains(''));
        expect(failure.props, contains(null));
      });

      test('should handle empty code', () {
        const failure = ServerFailure(message: 'Error', code: '');

        expect(failure.message, equals('Error'));
        expect(failure.code, equals(''));
        expect(failure.props, contains('Error'));
        expect(failure.props, contains(''));
      });
    });

    group('NetworkFailure', () {
      test('should create NetworkFailure with required message', () {
        const failure = NetworkFailure(message: 'Network error occurred');

        expect(failure, isA<NetworkFailure>());
        expect(failure, isA<Failure>());
        expect(failure.message, equals('Network error occurred'));
        expect(failure.code, isNull);
      });

      test('should create NetworkFailure with message and code', () {
        const failure = NetworkFailure(
          message: 'Network error occurred',
          code: 'NETWORK_001',
        );

        expect(failure, isA<NetworkFailure>());
        expect(failure, isA<Failure>());
        expect(failure.message, equals('Network error occurred'));
        expect(failure.code, equals('NETWORK_001'));
      });

      test('should have const constructor', () {
        const failure = NetworkFailure(message: 'Test');
        expect(failure, isA<NetworkFailure>());
      });

      test('should extend Failure', () {
        const failure = NetworkFailure(message: 'Test');
        expect(failure, isA<Failure>());
      });

      test('should extend Equatable', () {
        const failure = NetworkFailure(message: 'Test');
        expect(failure, isA<Equatable>());
      });

      test('props should contain message and code', () {
        const failure = NetworkFailure(
          message: 'Network error',
          code: 'NETWORK_001',
        );

        expect(failure.props, contains('Network error'));
        expect(failure.props, contains('NETWORK_001'));
        expect(failure.props.length, equals(2));
      });

      test('should be equal when message and code are equal', () {
        const failure1 = NetworkFailure(
          message: 'Network error',
          code: 'NETWORK_001',
        );
        const failure2 = NetworkFailure(
          message: 'Network error',
          code: 'NETWORK_001',
        );

        expect(failure1, equals(failure2));
        expect(failure1.hashCode, equals(failure2.hashCode));
      });

      test('should not be equal when message differs', () {
        const failure1 = NetworkFailure(
          message: 'Network error',
          code: 'NETWORK_001',
        );
        const failure2 = NetworkFailure(
          message: 'Different error',
          code: 'NETWORK_001',
        );

        expect(failure1, isNot(equals(failure2)));
        expect(failure1.hashCode, isNot(equals(failure2.hashCode)));
      });

      test('should not be equal when code differs', () {
        const failure1 = NetworkFailure(
          message: 'Network error',
          code: 'NETWORK_001',
        );
        const failure2 = NetworkFailure(
          message: 'Network error',
          code: 'NETWORK_002',
        );

        expect(failure1, isNot(equals(failure2)));
        expect(failure1.hashCode, isNot(equals(failure2.hashCode)));
      });
    });

    group('InvalidInputFailure', () {
      test('should create InvalidInputFailure with required message', () {
        const failure = InvalidInputFailure(
          message: 'Invalid input error occurred',
        );

        expect(failure, isA<InvalidInputFailure>());
        expect(failure, isA<Failure>());
        expect(failure.message, equals('Invalid input error occurred'));
        expect(failure.code, isNull);
      });

      test('should create InvalidInputFailure with message and code', () {
        const failure = InvalidInputFailure(
          message: 'Invalid input error occurred',
          code: 'INPUT_001',
        );

        expect(failure, isA<InvalidInputFailure>());
        expect(failure, isA<Failure>());
        expect(failure.message, equals('Invalid input error occurred'));
        expect(failure.code, equals('INPUT_001'));
      });

      test('should have const constructor', () {
        const failure = InvalidInputFailure(message: 'Test');
        expect(failure, isA<InvalidInputFailure>());
      });

      test('should extend Failure', () {
        const failure = InvalidInputFailure(message: 'Test');
        expect(failure, isA<Failure>());
      });

      test('should extend Equatable', () {
        const failure = InvalidInputFailure(message: 'Test');
        expect(failure, isA<Equatable>());
      });

      test('props should contain message and code', () {
        const failure = InvalidInputFailure(
          message: 'Invalid input error',
          code: 'INPUT_001',
        );

        expect(failure.props, contains('Invalid input error'));
        expect(failure.props, contains('INPUT_001'));
        expect(failure.props.length, equals(2));
      });

      test('should be equal when message and code are equal', () {
        const failure1 = InvalidInputFailure(
          message: 'Invalid input error',
          code: 'INPUT_001',
        );
        const failure2 = InvalidInputFailure(
          message: 'Invalid input error',
          code: 'INPUT_001',
        );

        expect(failure1, equals(failure2));
        expect(failure1.hashCode, equals(failure2.hashCode));
      });

      test('should not be equal when message differs', () {
        const failure1 = InvalidInputFailure(
          message: 'Invalid input error',
          code: 'INPUT_001',
        );
        const failure2 = InvalidInputFailure(
          message: 'Different error',
          code: 'INPUT_001',
        );

        expect(failure1, isNot(equals(failure2)));
        expect(failure1.hashCode, isNot(equals(failure2.hashCode)));
      });

      test('should not be equal when code differs', () {
        const failure1 = InvalidInputFailure(
          message: 'Invalid input error',
          code: 'INPUT_001',
        );
        const failure2 = InvalidInputFailure(
          message: 'Invalid input error',
          code: 'INPUT_002',
        );

        expect(failure1, isNot(equals(failure2)));
        expect(failure1.hashCode, isNot(equals(failure2.hashCode)));
      });
    });

    group('Failure comparison across types', () {
      test(
        'different failure types should not be equal even with same message and code',
        () {
          const serverFailure = ServerFailure(
            message: 'Error occurred',
            code: 'ERROR_001',
          );
          const networkFailure = NetworkFailure(
            message: 'Error occurred',
            code: 'ERROR_001',
          );
          const invalidInputFailure = InvalidInputFailure(
            message: 'Error occurred',
            code: 'ERROR_001',
          );

          expect(serverFailure, isNot(equals(networkFailure)));
          expect(serverFailure, isNot(equals(invalidInputFailure)));
          expect(networkFailure, isNot(equals(invalidInputFailure)));

          expect(
            serverFailure.hashCode,
            isNot(equals(networkFailure.hashCode)),
          );
          expect(
            serverFailure.hashCode,
            isNot(equals(invalidInputFailure.hashCode)),
          );
        },
      );

      test('failures with null code should be equal when message is same', () {
        const serverFailure1 = ServerFailure(message: 'Error occurred');
        const serverFailure2 = ServerFailure(message: 'Error occurred');

        expect(serverFailure1, equals(serverFailure2));
        expect(serverFailure1.hashCode, equals(serverFailure2.hashCode));
      });

      test(
        'failures with null code should not be equal when message differs',
        () {
          const serverFailure1 = ServerFailure(message: 'Error occurred');
          const serverFailure2 = ServerFailure(message: 'Different error');

          expect(serverFailure1, isNot(equals(serverFailure2)));
          expect(
            serverFailure1.hashCode,
            isNot(equals(serverFailure2.hashCode)),
          );
        },
      );
    });

    group('Failure immutability', () {
      test('all failure types should be immutable', () {
        const serverFailure = ServerFailure(
          message: 'Server error',
          code: 'SERVER_001',
        );
        const networkFailure = NetworkFailure(
          message: 'Network error',
          code: 'NETWORK_001',
        );

        const invalidInputFailure = InvalidInputFailure(
          message: 'Input error',
          code: 'INPUT_001',
        );

        expect(serverFailure.message, equals('Server error'));
        expect(serverFailure.code, equals('SERVER_001'));
        expect(networkFailure.message, equals('Network error'));
        expect(networkFailure.code, equals('NETWORK_001'));
        expect(invalidInputFailure.message, equals('Input error'));
        expect(invalidInputFailure.code, equals('INPUT_001'));

        const serverFailure2 = ServerFailure(
          message: 'Server error',
          code: 'SERVER_001',
        );
        const networkFailure2 = NetworkFailure(
          message: 'Network error',
          code: 'NETWORK_001',
        );

        const invalidInputFailure2 = InvalidInputFailure(
          message: 'Input error',
          code: 'INPUT_001',
        );

        expect(serverFailure, equals(serverFailure2));
        expect(networkFailure, equals(networkFailure2));
        expect(invalidInputFailure, equals(invalidInputFailure2));
      });
    });

    group('Edge cases', () {
      test('should handle very long messages', () {
        final longMessage = 'A' * 1000;

        final failure = ServerFailure(message: longMessage, code: 'LONG_MSG');

        expect(failure.message, equals(longMessage));
        expect(failure.code, equals('LONG_MSG'));
        expect(failure.props.length, equals(2));
        expect(failure.props, contains(longMessage));
        expect(failure.props, contains('LONG_MSG'));
      });

      test('should handle very long codes', () {
        final longCode = 'CODE_${'A' * 100}';

        final failure = ServerFailure(message: 'Error message', code: longCode);

        expect(failure.message, equals('Error message'));
        expect(failure.code, equals(longCode));
        expect(failure.props.length, equals(2));
        expect(failure.props, contains('Error message'));
        expect(failure.props, contains(longCode));
      });

      test('should handle unicode characters in message and code', () {
        final unicodeMessage = 'Erro com caracteres especiais: €¥£\$¢₿';
        final unicodeCode = 'UNICODE_€¥£\$¢₿';

        final failure = ServerFailure(
          message: unicodeMessage,
          code: unicodeCode,
        );

        expect(failure.message, equals(unicodeMessage));
        expect(failure.code, equals(unicodeCode));
        expect(failure.props, contains(unicodeMessage));
        expect(failure.props, contains(unicodeCode));
      });

      test('should handle numbers in message and code', () {
        const failure = ServerFailure(
          message: 'Error 123 occurred',
          code: 'ERROR_456',
        );

        expect(failure.message, equals('Error 123 occurred'));
        expect(failure.code, equals('ERROR_456'));
        expect(failure.props, contains('Error 123 occurred'));
        expect(failure.props, contains('ERROR_456'));
      });

      test('should handle special characters in message and code', () {
        const failure = ServerFailure(
          message: 'Error with special chars: !@#\$%^&*()',
          code: 'SPECIAL_CHARS_!@#\$%^&*()',
        );

        expect(
          failure.message,
          equals('Error with special chars: !@#\$%^&*()'),
        );
        expect(failure.code, equals('SPECIAL_CHARS_!@#\$%^&*()'));
        expect(
          failure.props,
          contains('Error with special chars: !@#\$%^&*()'),
        );
        expect(failure.props, contains('SPECIAL_CHARS_!@#\$%^&*()'));
      });
    });
  });
}
