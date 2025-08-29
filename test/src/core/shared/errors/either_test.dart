import 'package:flutter_test/flutter_test.dart';
import 'package:equatable/equatable.dart';

import 'package:exchange_rate/src/core/shared/errors/either.dart';

void main() {
  group('Either', () {
    group('Either base class', () {
      test('should be abstract and extend Equatable', () {
        expect(Either, isA<Type>());

        const left = Left<String, int>('error');
        expect(left, isA<Equatable>());
      });

      test('should have const constructor', () {
        const left = Left<String, int>('error');
        const right = Right<String, int>(42);

        expect(left, isA<Either<String, int>>());
        expect(right, isA<Either<String, int>>());
      });
    });

    group('Left', () {
      test('should create Left with value', () {
        const left = Left<String, int>('error message');

        expect(left, isA<Left<String, int>>());
        expect(left, isA<Either<String, int>>());
        expect(left.value, equals('error message'));
      });

      test('should have correct isLeft and isRight values', () {
        const left = Left<String, int>('error');

        expect(left.isLeft, isTrue);
        expect(left.isRight, isFalse);
      });

      test('should return left value', () {
        const left = Left<String, int>('error message');

        expect(left.left, equals('error message'));
      });

      test('should throw when accessing right value', () {
        const left = Left<String, int>('error');

        expect(() => left.right, throwsA(isA<TypeError>()));
      });

      test('should execute ifLeft function in fold', () {
        const left = Left<String, int>('error');

        final result = left.fold(
          (leftValue) => 'Left: $leftValue',
          (rightValue) => 'Right: $rightValue',
        );

        expect(result, equals('Left: error'));
      });

      test('should have props containing value', () {
        const left = Left<String, int>('test value');

        expect(left.props, contains('test value'));
        expect(left.props.length, equals(1));
      });

      test('should be equal when values are equal', () {
        const left1 = Left<String, int>('error');
        const left2 = Left<String, int>('error');

        expect(left1, equals(left2));
        expect(left1.hashCode, equals(left2.hashCode));
      });

      test('should not be equal when values differ', () {
        const left1 = Left<String, int>('error1');
        const left2 = Left<String, int>('error2');

        expect(left1, isNot(equals(left2)));
        expect(left1.hashCode, isNot(equals(left2.hashCode)));
      });
    });

    group('Right', () {
      test('should create Right with value', () {
        const right = Right<String, int>(42);

        expect(right, isA<Right<String, int>>());
        expect(right, isA<Either<String, int>>());
        expect(right.value, equals(42));
      });

      test('should have correct isLeft and isRight values', () {
        const right = Right<String, int>(42);

        expect(right.isLeft, isFalse);
        expect(right.isRight, isTrue);
      });

      test('should return right value', () {
        const right = Right<String, int>(42);

        expect(right.right, equals(42));
      });

      test('should throw when accessing left value', () {
        const right = Right<String, int>(42);

        expect(() => right.left, throwsA(isA<TypeError>()));
      });

      test('should execute ifRight function in fold', () {
        const right = Right<String, int>(42);

        final result = right.fold(
          (leftValue) => 'Left: $leftValue',
          (rightValue) => 'Right: $rightValue',
        );

        expect(result, equals('Right: 42'));
      });

      test('should have props containing value', () {
        const right = Right<String, int>(100);

        expect(right.props, contains(100));
        expect(right.props.length, equals(1));
      });

      test('should be equal when values are equal', () {
        const right1 = Right<String, int>(42);
        const right2 = Right<String, int>(42);

        expect(right1, equals(right2));
        expect(right1.hashCode, equals(right2.hashCode));
      });

      test('should not be equal when values differ', () {
        const right1 = Right<String, int>(42);
        const right2 = Right<String, int>(100);

        expect(right1, isNot(equals(right2)));
        expect(right1.hashCode, isNot(equals(right2.hashCode)));
      });
    });

    group('Either comparison', () {
      test('Left and Right should not be equal even with same value', () {
        const left = Left<String, int>('42');
        const right = Right<String, int>(42);

        expect(left, isNot(equals(right)));
        expect(left.hashCode, isNot(equals(right.hashCode)));
      });

      test('different generic types should not be equal', () {
        const left1 = Left<String, int>('error');
        const left2 = Left<String, int>('different error');

        expect(left1, isNot(equals(left2)));
        expect(left1.hashCode, isNot(equals(left2.hashCode)));
      });
    });

    group('Edge cases', () {
      test('should handle null values', () {
        const left = Left<String?, int?>(null);
        const right = Right<String?, int?>(null);

        expect(left.value, isNull);
        expect(right.value, isNull);
        expect(left.isLeft, isTrue);
        expect(right.isRight, isTrue);
      });

      test('should handle empty strings', () {
        const left = Left<String, int>('');
        const right = Right<String, int>(0);

        expect(left.value, equals(''));
        expect(right.value, equals(0));
      });

      test('should handle zero values', () {
        const left = Left<int, String>(0);
        const right = Right<int, String>('zero');

        expect(left.value, equals(0));
        expect(right.value, equals('zero'));
      });
    });
  });
}
