import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:exchange_rate/src/features/home/presentation/widgets/main_content_widget.dart';
import 'package:exchange_rate/src/features/home/presentation/widgets/currency_input_field.dart';
import 'package:exchange_rate/src/features/home/presentation/widgets/exchange_result_button.dart';
import 'package:exchange_rate/src/features/home/presentation/widgets/exchange_rate_result_widget.dart';
import 'package:exchange_rate/src/features/home/presentation/widgets/error_state_widget.dart';
import 'package:exchange_rate/src/features/home/presentation/cubits/currency_input_cubit.dart';
import 'package:exchange_rate/src/features/home/presentation/cubits/current_exchange_rate_cubit.dart';
import 'package:exchange_rate/src/features/home/domain/entities/current_exchange_rate_entity.dart';
import 'package:exchange_rate/src/features/home/presentation/blocs/daily_exchange_rate_bloc.dart';

class MockCurrencyInputCubit extends Mock implements CurrencyInputCubit {}

class MockCurrentExchangeRateCubit extends Mock
    implements CurrentExchangeRateCubit {}

class MockDailyExchangeRateBloc extends Mock implements DailyExchangeRateBloc {}

void main() {
  group('MainContentWidget', () {
    late MockCurrencyInputCubit mockCurrencyCubit;
    late MockCurrentExchangeRateCubit mockExchangeCubit;
    late MockDailyExchangeRateBloc mockDailyExchangeBloc;

    setUp(() {
      mockCurrencyCubit = MockCurrencyInputCubit();
      mockExchangeCubit = MockCurrentExchangeRateCubit();
      mockDailyExchangeBloc = MockDailyExchangeRateBloc();

      when(
        () => mockCurrencyCubit.state,
      ).thenReturn(const CurrencyInputUpdated(currency: '', isValid: false));
      when(() => mockCurrencyCubit.stream).thenAnswer(
        (_) => Stream.value(
          const CurrencyInputUpdated(currency: '', isValid: false),
        ),
      );

      when(
        () => mockExchangeCubit.state,
      ).thenReturn(const CurrentExchangeRateInitial());
      when(
        () => mockExchangeCubit.stream,
      ).thenAnswer((_) => Stream.value(const CurrentExchangeRateInitial()));

      when(
        () => mockDailyExchangeBloc.state,
      ).thenReturn(const DailyExchangeRateInitial());
      when(
        () => mockDailyExchangeBloc.stream,
      ).thenAnswer((_) => Stream.value(const DailyExchangeRateInitial()));
    });

    Widget createTestWidget() {
      return MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<CurrencyInputCubit>.value(value: mockCurrencyCubit),
            BlocProvider<CurrentExchangeRateCubit>.value(
              value: mockExchangeCubit,
            ),
            BlocProvider<DailyExchangeRateBloc>.value(
              value: mockDailyExchangeBloc,
            ),
          ],
          child: const Scaffold(body: MainContentWidget()),
        ),
      );
    }

    testWidgets('should render without errors', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.byType(MainContentWidget), findsOneWidget);
    });

    testWidgets('should have basic structure', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(Expanded), findsOneWidget);
    });

    testWidgets('should handle different currency states', (
      WidgetTester tester,
    ) async {
      const testCases = [
        {'currency': 'USD', 'isValid': true},
        {'currency': 'EUR', 'isValid': true},
        {'currency': 'ABC', 'isValid': false},
        {'currency': 'AB', 'isValid': false},
        {'currency': '', 'isValid': false},
      ];

      for (final testCase in testCases) {
        when(() => mockCurrencyCubit.state).thenReturn(
          CurrencyInputUpdated(
            currency: testCase['currency'] as String,
            isValid: testCase['isValid'] as bool,
          ),
        );
        when(() => mockCurrencyCubit.stream).thenAnswer(
          (_) => Stream.value(
            CurrencyInputUpdated(
              currency: testCase['currency'] as String,
              isValid: testCase['isValid'] as bool,
            ),
          ),
        );

        await tester.pumpWidget(createTestWidget());
        expect(find.byType(MainContentWidget), findsOneWidget);
      }
    });

    testWidgets('should handle different exchange rate states', (
      WidgetTester tester,
    ) async {
      const testCases = [
        CurrentExchangeRateInitial(),
        CurrentExchangeRateLoading(),
        CurrentExchangeRateError('Test error'),
      ];

      for (final state in testCases) {
        when(() => mockExchangeCubit.state).thenReturn(state);
        when(
          () => mockExchangeCubit.stream,
        ).thenAnswer((_) => Stream.value(state));

        await tester.pumpWidget(createTestWidget());
        expect(find.byType(MainContentWidget), findsOneWidget);
      }
    });

    testWidgets(
      'should display ErrorStateWidget when CurrentExchangeRateError occurs',
      (WidgetTester tester) async {
        const errorMessage = 'Failed to fetch exchange rate';
        const errorState = CurrentExchangeRateError(errorMessage);

        when(() => mockExchangeCubit.state).thenReturn(errorState);
        when(
          () => mockExchangeCubit.stream,
        ).thenAnswer((_) => Stream.value(errorState));

        when(
          () => mockCurrencyCubit.state,
        ).thenReturn(const CurrencyInputInitial());
        when(
          () => mockCurrencyCubit.stream,
        ).thenAnswer((_) => Stream.value(const CurrencyInputInitial()));

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byType(ErrorStateWidget), findsOneWidget);
        expect(find.text('Error: $errorMessage'), findsOneWidget);
        expect(find.text('Try Again'), findsOneWidget);
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
      },
    );

    testWidgets(
      'should display error message for invalid 3-character currency',
      (WidgetTester tester) async {
        when(() => mockCurrencyCubit.state).thenReturn(
          const CurrencyInputUpdated(currency: 'ABC', isValid: false),
        );
        when(() => mockCurrencyCubit.stream).thenAnswer(
          (_) => Stream.value(
            const CurrencyInputUpdated(currency: 'ABC', isValid: false),
          ),
        );

        await tester.pumpWidget(createTestWidget());

        expect(find.text('Invalid currency code'), findsOneWidget);
        expect(find.byType(Text), findsAtLeastNWidgets(1));
      },
    );

    testWidgets('should handle button press when currency is valid', (
      WidgetTester tester,
    ) async {
      when(
        () => mockCurrencyCubit.state,
      ).thenReturn(const CurrencyInputUpdated(currency: 'USD', isValid: true));
      when(() => mockCurrencyCubit.stream).thenAnswer(
        (_) => Stream.value(
          const CurrencyInputUpdated(currency: 'USD', isValid: true),
        ),
      );

      when(
        () => mockExchangeCubit.state,
      ).thenReturn(const CurrentExchangeRateInitial());
      when(
        () => mockExchangeCubit.stream,
      ).thenAnswer((_) => Stream.value(const CurrentExchangeRateInitial()));

      when(
        () => mockExchangeCubit.getCurrentExchangeRate(
          fromSymbol: any(named: 'fromSymbol'),
          toSymbol: any(named: 'toSymbol'),
        ),
      ).thenAnswer((_) async {});

      await tester.pumpWidget(createTestWidget());

      expect(find.byType(ExchangeResultButton), findsOneWidget);

      await tester.tap(find.byType(ExchangeResultButton));
      await tester.pump();

      verify(
        () => mockExchangeCubit.getCurrentExchangeRate(
          fromSymbol: 'USD',
          toSymbol: 'BRL',
        ),
      ).called(1);
    });

    testWidgets('should handle button press when currency is invalid', (
      WidgetTester tester,
    ) async {
      when(
        () => mockCurrencyCubit.state,
      ).thenReturn(const CurrencyInputUpdated(currency: 'ABC', isValid: false));
      when(() => mockCurrencyCubit.stream).thenAnswer(
        (_) => Stream.value(
          const CurrencyInputUpdated(currency: 'ABC', isValid: false),
        ),
      );

      when(
        () => mockExchangeCubit.state,
      ).thenReturn(const CurrentExchangeRateInitial());
      when(
        () => mockExchangeCubit.stream,
      ).thenAnswer((_) => Stream.value(const CurrentExchangeRateInitial()));

      await tester.pumpWidget(createTestWidget());

      expect(find.byType(ExchangeResultButton), findsOneWidget);

      await tester.tap(find.byType(ExchangeResultButton));
      await tester.pump();

      verifyNever(
        () => mockExchangeCubit.getCurrentExchangeRate(
          fromSymbol: any(named: 'fromSymbol'),
          toSymbol: any(named: 'toSymbol'),
        ),
      );
    });

    testWidgets('should handle unknown exchange rate state', (
      WidgetTester tester,
    ) async {
      when(
        () => mockCurrencyCubit.state,
      ).thenReturn(const CurrencyInputUpdated(currency: 'USD', isValid: true));
      when(() => mockCurrencyCubit.stream).thenAnswer(
        (_) => Stream.value(
          const CurrencyInputUpdated(currency: 'USD', isValid: true),
        ),
      );

      when(
        () => mockExchangeCubit.state,
      ).thenReturn(const CurrentExchangeRateInitial());
      when(
        () => mockExchangeCubit.stream,
      ).thenAnswer((_) => Stream.value(const CurrentExchangeRateInitial()));

      await tester.pumpWidget(createTestWidget());

      expect(find.byType(MainContentWidget), findsOneWidget);

      expect(find.byType(ExchangeRateResultWidget), findsNothing);
      expect(find.byType(ErrorStateWidget), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('should handle CurrencyInputField onChanged callback', (
      WidgetTester tester,
    ) async {
      when(
        () => mockCurrencyCubit.state,
      ).thenReturn(const CurrencyInputUpdated(currency: '', isValid: false));
      when(() => mockCurrencyCubit.stream).thenAnswer(
        (_) => Stream.value(
          const CurrencyInputUpdated(currency: '', isValid: false),
        ),
      );

      when(() => mockCurrencyCubit.updateCurrency(any())).thenReturn(null);

      await tester.pumpWidget(createTestWidget());

      expect(find.byType(CurrencyInputField), findsOneWidget);

      await tester.enterText(find.byType(CurrencyInputField), 'USD');
      await tester.pump();

      verify(() => mockCurrencyCubit.updateCurrency('USD')).called(1);
    });

    testWidgets(
      'should display ExchangeRateResultWidget when exchange rate is loaded',
      (WidgetTester tester) async {
        when(() => mockCurrencyCubit.state).thenReturn(
          const CurrencyInputUpdated(currency: 'USD', isValid: true),
        );
        when(() => mockCurrencyCubit.stream).thenAnswer(
          (_) => Stream.value(
            const CurrencyInputUpdated(currency: 'USD', isValid: true),
          ),
        );

        final mockExchangeRate = const CurrentExchangeRateEntity(
          exchangeRate: 5.25,
          fromSymbol: 'USD',
          toSymbol: 'BRL',
          lastUpdatedAt: '2024-01-01T12:00:00Z',
          success: true,
          rateLimitExceeded: false,
        );

        when(
          () => mockExchangeCubit.state,
        ).thenReturn(CurrentExchangeRateLoaded(mockExchangeRate));
        when(() => mockExchangeCubit.stream).thenAnswer(
          (_) => Stream.value(CurrentExchangeRateLoaded(mockExchangeRate)),
        );

        await tester.pumpWidget(createTestWidget());

        expect(find.byType(ExchangeRateResultWidget), findsOneWidget);

        final exchangeRateWidget = tester.widget<ExchangeRateResultWidget>(
          find.byType(ExchangeRateResultWidget),
        );
        expect(exchangeRateWidget.exchangeRate, mockExchangeRate);
        expect(exchangeRateWidget.selectedCurrency, 'USD');
      },
    );

    testWidgets('should handle empty currency state gracefully', (
      WidgetTester tester,
    ) async {
      when(
        () => mockCurrencyCubit.state,
      ).thenReturn(const CurrencyInputUpdated(currency: '', isValid: false));
      when(() => mockCurrencyCubit.stream).thenAnswer(
        (_) => Stream.value(
          const CurrencyInputUpdated(currency: '', isValid: false),
        ),
      );

      final mockExchangeRate = const CurrentExchangeRateEntity(
        exchangeRate: 5.25,
        fromSymbol: 'USD',
        toSymbol: 'BRL',
        lastUpdatedAt: '2024-01-01T12:00:00Z',
        success: true,
        rateLimitExceeded: false,
      );

      when(
        () => mockExchangeCubit.state,
      ).thenReturn(CurrentExchangeRateLoaded(mockExchangeRate));
      when(() => mockExchangeCubit.stream).thenAnswer(
        (_) => Stream.value(CurrentExchangeRateLoaded(mockExchangeRate)),
      );

      await tester.pumpWidget(createTestWidget());

      expect(find.byType(ExchangeRateResultWidget), findsOneWidget);

      final exchangeRateWidget = tester.widget<ExchangeRateResultWidget>(
        find.byType(ExchangeRateResultWidget),
      );
      expect(exchangeRateWidget.selectedCurrency, '');
    });

    testWidgets('should handle null currency state gracefully', (
      WidgetTester tester,
    ) async {
      when(
        () => mockCurrencyCubit.state,
      ).thenReturn(const CurrencyInputInitial());
      when(
        () => mockCurrencyCubit.stream,
      ).thenAnswer((_) => Stream.value(const CurrencyInputInitial()));

      final mockExchangeRate = const CurrentExchangeRateEntity(
        exchangeRate: 5.25,
        fromSymbol: 'USD',
        toSymbol: 'BRL',
        lastUpdatedAt: '2024-01-01T12:00:00Z',
        success: true,
        rateLimitExceeded: false,
      );

      when(
        () => mockExchangeCubit.state,
      ).thenReturn(CurrentExchangeRateLoaded(mockExchangeRate));
      when(() => mockExchangeCubit.stream).thenAnswer(
        (_) => Stream.value(CurrentExchangeRateLoaded(mockExchangeRate)),
      );

      await tester.pumpWidget(createTestWidget());

      expect(find.byType(ExchangeRateResultWidget), findsOneWidget);

      final exchangeRateWidget = tester.widget<ExchangeRateResultWidget>(
        find.byType(ExchangeRateResultWidget),
      );
      expect(exchangeRateWidget.selectedCurrency, '');
    });
  });
}
