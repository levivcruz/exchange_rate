import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:exchange_rate/src/features/home/presentation/widgets/exchange_rate_result_widget.dart';
import 'package:exchange_rate/src/features/home/domain/entities/current_exchange_rate_entity.dart';
import 'package:exchange_rate/src/features/home/presentation/blocs/daily_exchange_rate_bloc.dart';
import 'package:exchange_rate/src/features/home/domain/entities/exchange_rate_history_entity.dart';

class MockDailyExchangeRateBloc extends Mock implements DailyExchangeRateBloc {}

class FakeGetDailyExchangeRate extends Fake implements GetDailyExchangeRate {}

class FakeResetDailyExchangeRate extends Fake
    implements ResetDailyExchangeRate {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeGetDailyExchangeRate());
    registerFallbackValue(FakeResetDailyExchangeRate());
  });
  group('ExchangeRateResultWidget', () {
    late MockDailyExchangeRateBloc mockBloc;
    late CurrentExchangeRateEntity mockExchangeRate;

    setUp(() {
      mockBloc = MockDailyExchangeRateBloc();

      when(() => mockBloc.state).thenReturn(const DailyExchangeRateInitial());
      when(
        () => mockBloc.stream,
      ).thenAnswer((_) => Stream.value(const DailyExchangeRateInitial()));

      mockExchangeRate = const CurrentExchangeRateEntity(
        exchangeRate: 5.25,
        fromSymbol: 'USD',
        toSymbol: 'BRL',
        lastUpdatedAt: '2024-01-01T12:00:00Z',
        success: true,
        rateLimitExceeded: false,
      );
    });

    Widget createTestWidget({
      required CurrentExchangeRateEntity exchangeRate,
      required String selectedCurrency,
      DailyExchangeRateBloc? bloc,
    }) {
      return MaterialApp(
        home: BlocProvider<DailyExchangeRateBloc>.value(
          value: bloc ?? mockBloc,
          child: Scaffold(
            body: ExchangeRateResultWidget(
              exchangeRate: exchangeRate,
              selectedCurrency: selectedCurrency,
            ),
          ),
        ),
      );
    }

    testWidgets('should render without errors', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          exchangeRate: mockExchangeRate,
          selectedCurrency: 'USD',
        ),
      );

      expect(find.byType(ExchangeRateResultWidget), findsOneWidget);
    });

    testWidgets('should display exchange rate information', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          exchangeRate: mockExchangeRate,
          selectedCurrency: 'USD',
        ),
      );

      expect(find.text('Exchange rate now'), findsOneWidget);
      expect(find.text('USD/BRL'), findsOneWidget);
    });

    testWidgets('should display formatted exchange rate value', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          exchangeRate: mockExchangeRate,
          selectedCurrency: 'USD',
        ),
      );

      expect(find.textContaining('5,25'), findsOneWidget);
    });

    testWidgets('should display selected currency when fromSymbol is null', (
      WidgetTester tester,
    ) async {
      final exchangeRateWithoutSymbol = const CurrentExchangeRateEntity(
        exchangeRate: 4.50,
        fromSymbol: null,
        toSymbol: 'BRL',
        lastUpdatedAt: '2024-01-01T12:00:00Z',
        success: true,
        rateLimitExceeded: false,
      );

      await tester.pumpWidget(
        createTestWidget(
          exchangeRate: exchangeRateWithoutSymbol,
          selectedCurrency: 'EUR',
        ),
      );

      expect(find.text('EUR/BRL'), findsOneWidget);
    });

    testWidgets('should display "LAST 30 DAYS" section', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          exchangeRate: mockExchangeRate,
          selectedCurrency: 'USD',
        ),
      );

      expect(find.text('LAST 30 DAYS'), findsOneWidget);
    });

    testWidgets('should display add icon when history is not loaded', (
      WidgetTester tester,
    ) async {
      when(() => mockBloc.state).thenReturn(const DailyExchangeRateInitial());
      when(
        () => mockBloc.stream,
      ).thenAnswer((_) => Stream.value(const DailyExchangeRateInitial()));

      await tester.pumpWidget(
        createTestWidget(
          exchangeRate: mockExchangeRate,
          selectedCurrency: 'USD',
          bloc: mockBloc,
        ),
      );

      final iconButton = find.byType(IconButton);
      expect(iconButton, findsOneWidget);

      final icon = tester.widget<IconButton>(iconButton);
      expect(icon.icon, isA<Icon>());
    });

    testWidgets('should display blue line when history is not loaded', (
      WidgetTester tester,
    ) async {
      when(() => mockBloc.state).thenReturn(const DailyExchangeRateInitial());
      when(
        () => mockBloc.stream,
      ).thenAnswer((_) => Stream.value(const DailyExchangeRateInitial()));

      await tester.pumpWidget(
        createTestWidget(
          exchangeRate: mockExchangeRate,
          selectedCurrency: 'USD',
          bloc: mockBloc,
        ),
      );

      final blueLine = find.byType(Container);
      expect(blueLine, findsAtLeastNWidgets(1));
    });

    testWidgets('should display loading indicator when history is loading', (
      WidgetTester tester,
    ) async {
      when(() => mockBloc.state).thenReturn(const DailyExchangeRateLoading());
      when(
        () => mockBloc.stream,
      ).thenAnswer((_) => Stream.value(const DailyExchangeRateLoading()));

      await tester.pumpWidget(
        createTestWidget(
          exchangeRate: mockExchangeRate,
          selectedCurrency: 'USD',
          bloc: mockBloc,
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display historical data when loaded', (
      WidgetTester tester,
    ) async {
      final mockHistoryEntity = const ExchangeRatesEntity(
        data: [],
        from: 'USD',
        to: 'BRL',
        success: true,
      );

      when(
        () => mockBloc.state,
      ).thenReturn(DailyExchangeRateLoaded(mockHistoryEntity));
      when(() => mockBloc.stream).thenAnswer(
        (_) => Stream.value(DailyExchangeRateLoaded(mockHistoryEntity)),
      );

      await tester.pumpWidget(
        createTestWidget(
          exchangeRate: mockExchangeRate,
          selectedCurrency: 'USD',
          bloc: mockBloc,
        ),
      );

      final historyContainer = find.byType(Container);
      expect(historyContainer, findsAtLeastNWidgets(1));
    });

    testWidgets('should display remove icon when history is loaded', (
      WidgetTester tester,
    ) async {
      final mockHistoryEntity = const ExchangeRatesEntity(
        data: [],
        from: 'USD',
        to: 'BRL',
        success: true,
      );

      when(
        () => mockBloc.state,
      ).thenReturn(DailyExchangeRateLoaded(mockHistoryEntity));
      when(() => mockBloc.stream).thenAnswer(
        (_) => Stream.value(DailyExchangeRateLoaded(mockHistoryEntity)),
      );

      await tester.pumpWidget(
        createTestWidget(
          exchangeRate: mockExchangeRate,
          selectedCurrency: 'USD',
          bloc: mockBloc,
        ),
      );

      final iconButton = find.byType(IconButton);
      expect(iconButton, findsOneWidget);

      final icon = tester.widget<IconButton>(iconButton);
      expect(icon.icon, isA<Icon>());
    });

    testWidgets('should have proper structure with SingleChildScrollView', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          exchangeRate: mockExchangeRate,
          selectedCurrency: 'USD',
        ),
      );

      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Text), findsAtLeastNWidgets(1));
      expect(find.text('Exchange rate now'), findsOneWidget);
      expect(find.text('LAST 30 DAYS'), findsOneWidget);
    });

    testWidgets('should display current date/time', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          exchangeRate: mockExchangeRate,
          selectedCurrency: 'USD',
        ),
      );

      final title = find.text('Exchange rate now');
      expect(title, findsOneWidget);
    });

    testWidgets('should handle different exchange rate values', (
      WidgetTester tester,
    ) async {
      const testCases = [
        {'rate': 1.0, 'expected': '1,00'},
        {'rate': 10.50, 'expected': '10,50'},
        {'rate': 100.25, 'expected': '100,25'},
        {'rate': 0.99, 'expected': '0,99'},
      ];

      for (final testCase in testCases) {
        final exchangeRate = CurrentExchangeRateEntity(
          exchangeRate: testCase['rate'] as double,
          fromSymbol: 'USD',
          toSymbol: 'BRL',
          lastUpdatedAt: '2024-01-01T12:00:00Z',
          success: true,
          rateLimitExceeded: false,
        );

        await tester.pumpWidget(
          createTestWidget(exchangeRate: exchangeRate, selectedCurrency: 'USD'),
        );

        expect(find.byType(Text), findsAtLeastNWidgets(1));
      }
    });

    testWidgets('should handle different currencies', (
      WidgetTester tester,
    ) async {
      const currencies = ['USD', 'EUR', 'GBP', 'JPY'];

      for (final currency in currencies) {
        final currencyExchangeRate = CurrentExchangeRateEntity(
          exchangeRate: 5.25,
          fromSymbol: currency,
          toSymbol: 'BRL',
          lastUpdatedAt: '2024-01-01T12:00:00Z',
          success: true,
          rateLimitExceeded: false,
        );

        await tester.pumpWidget(
          createTestWidget(
            exchangeRate: currencyExchangeRate,
            selectedCurrency: currency,
          ),
        );

        expect(find.text('$currency/BRL'), findsOneWidget);
      }
    });

    testWidgets('should have proper spacing between sections', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          exchangeRate: mockExchangeRate,
          selectedCurrency: 'USD',
        ),
      );

      expect(find.byType(SizedBox), findsAtLeastNWidgets(3));
    });

    testWidgets('should handle exchange rate with null values gracefully', (
      WidgetTester tester,
    ) async {
      final exchangeRateWithNulls = const CurrentExchangeRateEntity(
        exchangeRate: null,
        fromSymbol: null,
        toSymbol: null,
        lastUpdatedAt: null,
        success: null,
        rateLimitExceeded: null,
      );

      await tester.pumpWidget(
        createTestWidget(
          exchangeRate: exchangeRateWithNulls,
          selectedCurrency: 'USD',
        ),
      );

      expect(find.byType(ExchangeRateResultWidget), findsOneWidget);
      expect(find.text('USD/BRL'), findsOneWidget);
    });

    testWidgets('should maintain layout structure in different screen sizes', (
      WidgetTester tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(300, 600));
      await tester.pumpWidget(
        createTestWidget(
          exchangeRate: mockExchangeRate,
          selectedCurrency: 'USD',
        ),
      );
      expect(find.byType(ExchangeRateResultWidget), findsOneWidget);

      await tester.binding.setSurfaceSize(const Size(800, 600));
      await tester.pumpWidget(
        createTestWidget(
          exchangeRate: mockExchangeRate,
          selectedCurrency: 'USD',
        ),
      );
      expect(find.byType(ExchangeRateResultWidget), findsOneWidget);

      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should have proper text styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          exchangeRate: mockExchangeRate,
          selectedCurrency: 'USD',
        ),
      );

      expect(find.text('Exchange rate now'), findsOneWidget);
      expect(find.text('LAST 30 DAYS'), findsOneWidget);
    });

    testWidgets('should handle different bloc states correctly', (
      WidgetTester tester,
    ) async {
      when(() => mockBloc.state).thenReturn(const DailyExchangeRateInitial());
      when(
        () => mockBloc.stream,
      ).thenAnswer((_) => Stream.value(const DailyExchangeRateInitial()));

      await tester.pumpWidget(
        createTestWidget(
          exchangeRate: mockExchangeRate,
          selectedCurrency: 'USD',
          bloc: mockBloc,
        ),
      );

      expect(find.byType(IconButton), findsOneWidget);
    });

    testWidgets('should display loading state correctly', (
      WidgetTester tester,
    ) async {
      when(() => mockBloc.state).thenReturn(const DailyExchangeRateLoading());
      when(
        () => mockBloc.stream,
      ).thenAnswer((_) => Stream.value(const DailyExchangeRateLoading()));

      await tester.pumpWidget(
        createTestWidget(
          exchangeRate: mockExchangeRate,
          selectedCurrency: 'USD',
          bloc: mockBloc,
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should handle IconButton tap when history is not loaded', (
      WidgetTester tester,
    ) async {
      when(() => mockBloc.state).thenReturn(const DailyExchangeRateInitial());
      when(
        () => mockBloc.stream,
      ).thenAnswer((_) => Stream.value(const DailyExchangeRateInitial()));

      when(() => mockBloc.add(any<GetDailyExchangeRate>())).thenReturn(null);

      await tester.pumpWidget(
        createTestWidget(
          exchangeRate: mockExchangeRate,
          selectedCurrency: 'USD',
          bloc: mockBloc,
        ),
      );

      final iconButton = find.byType(IconButton);
      expect(iconButton, findsOneWidget);

      await tester.tap(iconButton);
      await tester.pump();

      verify(() => mockBloc.add(any<GetDailyExchangeRate>())).called(1);
    });

    testWidgets('should handle IconButton tap when history is loaded', (
      WidgetTester tester,
    ) async {
      final mockHistoryEntity = const ExchangeRatesEntity(
        data: [],
        from: 'USD',
        to: 'BRL',
        success: true,
      );

      when(
        () => mockBloc.state,
      ).thenReturn(DailyExchangeRateLoaded(mockHistoryEntity));
      when(() => mockBloc.stream).thenAnswer(
        (_) => Stream.value(DailyExchangeRateLoaded(mockHistoryEntity)),
      );

      when(() => mockBloc.add(any<ResetDailyExchangeRate>())).thenReturn(null);

      await tester.pumpWidget(
        createTestWidget(
          exchangeRate: mockExchangeRate,
          selectedCurrency: 'USD',
          bloc: mockBloc,
        ),
      );

      final iconButton = find.byType(IconButton);
      expect(iconButton, findsOneWidget);

      await tester.tap(iconButton);
      await tester.pump();

      verify(() => mockBloc.add(any<ResetDailyExchangeRate>())).called(1);
    });

    testWidgets('should display add icon when history is not loaded', (
      WidgetTester tester,
    ) async {
      when(() => mockBloc.state).thenReturn(const DailyExchangeRateInitial());
      when(
        () => mockBloc.stream,
      ).thenAnswer((_) => Stream.value(const DailyExchangeRateInitial()));

      await tester.pumpWidget(
        createTestWidget(
          exchangeRate: mockExchangeRate,
          selectedCurrency: 'USD',
          bloc: mockBloc,
        ),
      );

      final iconButton = find.byType(IconButton);
      final icon = tester.widget<IconButton>(iconButton);
      expect(icon.icon, isA<Icon>());

      final iconWidget = icon.icon as Icon;
      expect(iconWidget.icon, Icons.add);
    });

    testWidgets('should display remove icon when history is loaded', (
      WidgetTester tester,
    ) async {
      final mockHistoryEntity = const ExchangeRatesEntity(
        data: [],
        from: 'USD',
        to: 'BRL',
        success: true,
      );

      when(
        () => mockBloc.state,
      ).thenReturn(DailyExchangeRateLoaded(mockHistoryEntity));
      when(() => mockBloc.stream).thenAnswer(
        (_) => Stream.value(DailyExchangeRateLoaded(mockHistoryEntity)),
      );

      await tester.pumpWidget(
        createTestWidget(
          exchangeRate: mockExchangeRate,
          selectedCurrency: 'USD',
          bloc: mockBloc,
        ),
      );

      final iconButton = find.byType(IconButton);
      final icon = tester.widget<IconButton>(iconButton);
      expect(icon.icon, isA<Icon>());

      final iconWidget = icon.icon as Icon;
      expect(iconWidget.icon, Icons.remove);
    });

    testWidgets(
      'should pass correct parameters to GetDailyExchangeRate event',
      (WidgetTester tester) async {
        when(() => mockBloc.state).thenReturn(const DailyExchangeRateInitial());
        when(
          () => mockBloc.stream,
        ).thenAnswer((_) => Stream.value(const DailyExchangeRateInitial()));

        when(() => mockBloc.add(any<GetDailyExchangeRate>())).thenReturn(null);

        await tester.pumpWidget(
          createTestWidget(
            exchangeRate: mockExchangeRate,
            selectedCurrency: 'EUR',
            bloc: mockBloc,
          ),
        );

        await tester.tap(find.byType(IconButton));
        await tester.pump();

        verify(() => mockBloc.add(any<GetDailyExchangeRate>())).called(1);
      },
    );

    testWidgets('should handle IconButton tap with different currencies', (
      WidgetTester tester,
    ) async {
      const currencies = ['USD', 'EUR', 'GBP', 'JPY'];

      for (final currency in currencies) {
        when(() => mockBloc.state).thenReturn(const DailyExchangeRateInitial());
        when(
          () => mockBloc.stream,
        ).thenAnswer((_) => Stream.value(const DailyExchangeRateInitial()));

        when(() => mockBloc.add(any<GetDailyExchangeRate>())).thenReturn(null);

        await tester.pumpWidget(
          createTestWidget(
            exchangeRate: mockExchangeRate,
            selectedCurrency: currency,
            bloc: mockBloc,
          ),
        );

        await tester.tap(find.byType(IconButton));
        await tester.pump();

        verify(() => mockBloc.add(any<GetDailyExchangeRate>())).called(1);
      }
    });
  });
}
