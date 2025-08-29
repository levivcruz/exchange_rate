import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:exchange_rate/src/features/home/presentation/widgets/error_state_widget.dart';
import 'package:exchange_rate/src/features/home/presentation/cubits/current_exchange_rate_cubit.dart';

class MockCurrentExchangeRateCubit extends Mock
    implements CurrentExchangeRateCubit {
  @override
  void reset() {}
}

void main() {
  group('ErrorStateWidget', () {
    late MockCurrentExchangeRateCubit mockCubit;

    setUp(() {
      mockCubit = MockCurrentExchangeRateCubit();

      when(
        () => mockCubit.state,
      ).thenReturn(const CurrentExchangeRateInitial());
      when(
        () => mockCubit.stream,
      ).thenAnswer((_) => Stream.value(const CurrentExchangeRateInitial()));
    });

    Widget createTestWidget({
      required String message,
      required CurrentExchangeRateCubit cubit,
    }) {
      return MaterialApp(
        home: BlocProvider<CurrentExchangeRateCubit>.value(
          value: cubit,
          child: Scaffold(body: ErrorStateWidget(message: message)),
        ),
      );
    }

    testWidgets('should render without errors', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(message: 'Test error message', cubit: mockCubit),
      );

      expect(find.byType(ErrorStateWidget), findsOneWidget);
    });

    testWidgets('should display the error message correctly', (
      WidgetTester tester,
    ) async {
      const errorMessage = 'Network connection failed';

      await tester.pumpWidget(
        createTestWidget(message: errorMessage, cubit: mockCubit),
      );

      expect(find.text('Error: $errorMessage'), findsOneWidget);
    });

    testWidgets('should have correct structure with Padding and Column', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(message: 'Test error', cubit: mockCubit),
      );

      final errorStateWidget = find.byType(ErrorStateWidget);
      final columnInErrorState = find.descendant(
        of: errorStateWidget,
        matching: find.byType(Column),
      );

      expect(columnInErrorState, findsOneWidget);
      expect(find.byType(Icon), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should display error icon with correct properties', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(message: 'Test error', cubit: mockCubit),
      );

      final iconFinder = find.byType(Icon);
      expect(iconFinder, findsOneWidget);

      final icon = tester.widget<Icon>(iconFinder);
      expect(icon.icon, Icons.error_outline);
    });

    testWidgets('should display "Try Again" button', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(message: 'Test error', cubit: mockCubit),
      );

      expect(find.text('Try Again'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should handle button tap without errors', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(message: 'Test error', cubit: mockCubit),
      );

      await tester.tap(find.text('Try Again'));
      await tester.pump();

      expect(find.byType(ErrorStateWidget), findsOneWidget);
    });

    testWidgets('should handle different error messages', (
      WidgetTester tester,
    ) async {
      const messages = [
        'Network error',
        'Server timeout',
        'Invalid currency code',
        'API rate limit exceeded',
      ];

      for (final message in messages) {
        await tester.pumpWidget(
          createTestWidget(message: message, cubit: mockCubit),
        );

        expect(find.text('Error: $message'), findsOneWidget);
      }
    });

    testWidgets('should have proper spacing between elements', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(message: 'Test error', cubit: mockCubit),
      );

      expect(find.byType(SizedBox), findsAtLeastNWidgets(2));
    });

    testWidgets('should have proper layout structure', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(message: 'Test error', cubit: mockCubit),
      );

      final errorStateWidget = find.byType(ErrorStateWidget);
      final columnInErrorState = find.descendant(
        of: errorStateWidget,
        matching: find.byType(Column),
      );

      expect(columnInErrorState, findsOneWidget);
      expect(find.byType(Icon), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(Text), findsAtLeastNWidgets(1));
    });

    testWidgets('should handle empty error message', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget(message: '', cubit: mockCubit));

      expect(find.text('Error: '), findsOneWidget);
    });

    testWidgets('should handle very long error message', (
      WidgetTester tester,
    ) async {
      const longMessage =
          'This is a very long error message that should be handled properly by the widget without causing any layout issues or overflow problems';

      await tester.pumpWidget(
        createTestWidget(message: longMessage, cubit: mockCubit),
      );

      expect(find.text('Error: $longMessage'), findsOneWidget);

      expect(find.byType(ErrorStateWidget), findsOneWidget);
    });

    testWidgets(
      'should maintain proper layout structure in different screen sizes',
      (WidgetTester tester) async {
        const message = 'Test error message';

        await tester.binding.setSurfaceSize(const Size(300, 600));
        await tester.pumpWidget(
          createTestWidget(message: message, cubit: mockCubit),
        );
        expect(find.text('Error: $message'), findsOneWidget);

        await tester.binding.setSurfaceSize(const Size(800, 600));
        await tester.pumpWidget(
          createTestWidget(message: message, cubit: mockCubit),
        );
        expect(find.text('Error: $message'), findsOneWidget);

        await tester.binding.setSurfaceSize(null);
      },
    );
  });
}
