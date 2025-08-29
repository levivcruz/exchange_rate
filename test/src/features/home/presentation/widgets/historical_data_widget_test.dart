import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:exchange_rate/src/features/home/presentation/widgets/historical_data_widget.dart';
import 'package:exchange_rate/src/features/home/domain/entities/exchange_rate_history_entity.dart';
import 'package:exchange_rate/src/features/home/domain/entities/exchange_rate_data_entity.dart';

void main() {
  group('HistoricalDataWidget', () {
    Widget createTestWidget({required ExchangeRatesEntity exchangeRates}) {
      return MaterialApp(
        home: Scaffold(
          body: HistoricalDataWidget(exchangeRates: exchangeRates),
        ),
      );
    }

    testWidgets('should render without errors', (WidgetTester tester) async {
      final exchangeRates = const ExchangeRatesEntity(
        data: [
          ExchangeRateDataEntity(
            date: '2024-01-01',
            open: 5.0,
            high: 5.2,
            low: 4.8,
            close: 5.1,
          ),
        ],
        from: 'USD',
        to: 'BRL',
        success: true,
      );

      await tester.pumpWidget(createTestWidget(exchangeRates: exchangeRates));

      expect(find.byType(HistoricalDataWidget), findsOneWidget);
    });

    testWidgets(
      'should display "No historical data available" when data is null',
      (WidgetTester tester) async {
        final exchangeRates = const ExchangeRatesEntity(
          data: null,
          from: 'USD',
          to: 'BRL',
          success: true,
        );

        await tester.pumpWidget(createTestWidget(exchangeRates: exchangeRates));

        expect(find.text('No historical data available'), findsOneWidget);
        expect(find.byType(Center), findsOneWidget);
      },
    );

    testWidgets(
      'should display "No historical data available" when data is empty',
      (WidgetTester tester) async {
        final exchangeRates = const ExchangeRatesEntity(
          data: [],
          from: 'USD',
          to: 'BRL',
          success: true,
        );

        await tester.pumpWidget(createTestWidget(exchangeRates: exchangeRates));

        expect(find.text('No historical data available'), findsOneWidget);
        expect(find.byType(Center), findsOneWidget);
      },
    );

    testWidgets('should display historical data when available', (
      WidgetTester tester,
    ) async {
      final exchangeRates = const ExchangeRatesEntity(
        data: [
          ExchangeRateDataEntity(
            date: '2024-01-01',
            open: 5.0,
            high: 5.2,
            low: 4.8,
            close: 5.1,
          ),
        ],
        from: 'USD',
        to: 'BRL',
        success: true,
      );

      await tester.pumpWidget(createTestWidget(exchangeRates: exchangeRates));

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
      expect(find.text('01/01/2024'), findsOneWidget);
    });

    testWidgets('should display multiple historical data items', (
      WidgetTester tester,
    ) async {
      final exchangeRates = const ExchangeRatesEntity(
        data: [
          ExchangeRateDataEntity(
            date: '2024-01-01',
            open: 5.0,
            high: 5.2,
            low: 4.8,
            close: 5.1,
          ),
          ExchangeRateDataEntity(
            date: '2024-01-02',
            open: 5.1,
            high: 5.3,
            low: 4.9,
            close: 5.0,
          ),
        ],
        from: 'USD',
        to: 'BRL',
        success: true,
      );

      await tester.pumpWidget(createTestWidget(exchangeRates: exchangeRates));

      expect(find.byType(Card), findsNWidgets(2));
      expect(find.text('01/01/2024'), findsOneWidget);
      expect(find.text('02/01/2024'), findsOneWidget);
    });

    testWidgets('should display formatted currency values', (
      WidgetTester tester,
    ) async {
      final exchangeRates = const ExchangeRatesEntity(
        data: [
          ExchangeRateDataEntity(
            date: '2024-01-01',
            open: 5.1234,
            high: 5.2345,
            low: 4.8765,
            close: 5.1111,
          ),
        ],
        from: 'USD',
        to: 'BRL',
        success: true,
      );

      await tester.pumpWidget(createTestWidget(exchangeRates: exchangeRates));

      expect(find.text('OPEN:'), findsOneWidget);
      expect(find.text('CLOSE:'), findsOneWidget);
      expect(find.text('HIGH:'), findsOneWidget);
      expect(find.text('LOW:'), findsOneWidget);
    });

    testWidgets(
      'should display percentage difference when open and close are available',
      (WidgetTester tester) async {
        final exchangeRates = const ExchangeRatesEntity(
          data: [
            ExchangeRateDataEntity(
              date: '2024-01-01',
              open: 5.0,
              high: 5.2,
              low: 4.8,
              close: 5.1,
            ),
          ],
          from: 'USD',
          to: 'BRL',
          success: true,
        );

        await tester.pumpWidget(createTestWidget(exchangeRates: exchangeRates));

        expect(find.text('CLOSE DIFF (%):'), findsOneWidget);

        expect(find.byType(Icon), findsOneWidget);
      },
    );

    testWidgets(
      'should display positive percentage with green color and up arrow',
      (WidgetTester tester) async {
        final exchangeRates = const ExchangeRatesEntity(
          data: [
            ExchangeRateDataEntity(
              date: '2024-01-01',
              open: 5.0,
              high: 5.2,
              low: 4.8,
              close: 5.1,
            ),
          ],
          from: 'USD',
          to: 'BRL',
          success: true,
        );

        await tester.pumpWidget(createTestWidget(exchangeRates: exchangeRates));

        final icon = tester.widget<Icon>(find.byType(Icon));
        expect(icon.icon, Icons.keyboard_arrow_up);
      },
    );

    testWidgets(
      'should display negative percentage with red color and down arrow',
      (WidgetTester tester) async {
        final exchangeRates = const ExchangeRatesEntity(
          data: [
            ExchangeRateDataEntity(
              date: '2024-01-01',
              open: 5.0,
              high: 5.2,
              low: 4.8,
              close: 4.9,
            ),
          ],
          from: 'USD',
          to: 'BRL',
          success: true,
        );

        await tester.pumpWidget(createTestWidget(exchangeRates: exchangeRates));

        final icon = tester.widget<Icon>(find.byType(Icon));
        expect(icon.icon, Icons.keyboard_arrow_down);
      },
    );

    testWidgets('should not display percentage when open is zero', (
      WidgetTester tester,
    ) async {
      final exchangeRates = const ExchangeRatesEntity(
        data: [
          ExchangeRateDataEntity(
            date: '2024-01-01',
            open: 0.0,
            high: 5.2,
            low: 4.8,
            close: 5.1,
          ),
        ],
        from: 'USD',
        to: 'BRL',
        success: true,
      );

      await tester.pumpWidget(createTestWidget(exchangeRates: exchangeRates));

      expect(find.text('CLOSE DIFF (%):'), findsNothing);
    });

    testWidgets('should handle null values gracefully', (
      WidgetTester tester,
    ) async {
      final exchangeRates = const ExchangeRatesEntity(
        data: [
          ExchangeRateDataEntity(
            date: null,
            open: null,
            high: null,
            low: null,
            close: null,
          ),
        ],
        from: 'USD',
        to: 'BRL',
        success: true,
      );

      await tester.pumpWidget(createTestWidget(exchangeRates: exchangeRates));

      expect(find.text('N/A'), findsOneWidget);
      expect(find.byType(HistoricalDataWidget), findsOneWidget);
    });

    testWidgets('should display date as N/A when date is null', (
      WidgetTester tester,
    ) async {
      final exchangeRates = const ExchangeRatesEntity(
        data: [
          ExchangeRateDataEntity(
            date: null,
            open: 5.0,
            high: 5.2,
            low: 4.8,
            close: 5.1,
          ),
        ],
        from: 'USD',
        to: 'BRL',
        success: true,
      );

      await tester.pumpWidget(createTestWidget(exchangeRates: exchangeRates));

      expect(find.text('N/A'), findsOneWidget);
    });

    testWidgets('should have proper card styling', (WidgetTester tester) async {
      final exchangeRates = const ExchangeRatesEntity(
        data: [
          ExchangeRateDataEntity(
            date: '2024-01-01',
            open: 5.0,
            high: 5.2,
            low: 4.8,
            close: 5.1,
          ),
        ],
        from: 'USD',
        to: 'BRL',
        success: true,
      );

      await tester.pumpWidget(createTestWidget(exchangeRates: exchangeRates));

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, 2);
      expect(card.margin, const EdgeInsets.only(bottom: 12));
    });

    testWidgets('should have proper padding in cards', (
      WidgetTester tester,
    ) async {
      final exchangeRates = const ExchangeRatesEntity(
        data: [
          ExchangeRateDataEntity(
            date: '2024-01-01',
            open: 5.0,
            high: 5.2,
            low: 4.8,
            close: 5.1,
          ),
        ],
        from: 'USD',
        to: 'BRL',
        success: true,
      );

      await tester.pumpWidget(createTestWidget(exchangeRates: exchangeRates));

      expect(find.byType(Padding), findsAtLeastNWidgets(1));
    });

    testWidgets('should have proper row structure', (
      WidgetTester tester,
    ) async {
      final exchangeRates = const ExchangeRatesEntity(
        data: [
          ExchangeRateDataEntity(
            date: '2024-01-01',
            open: 5.0,
            high: 5.2,
            low: 4.8,
            close: 5.1,
          ),
        ],
        from: 'USD',
        to: 'BRL',
        success: true,
      );

      await tester.pumpWidget(createTestWidget(exchangeRates: exchangeRates));

      expect(find.byType(Row), findsAtLeastNWidgets(1));
      expect(find.byType(Column), findsAtLeastNWidgets(1));
    });

    testWidgets('should handle very large numbers', (
      WidgetTester tester,
    ) async {
      final exchangeRates = const ExchangeRatesEntity(
        data: [
          ExchangeRateDataEntity(
            date: '2024-01-01',
            open: 999999.9999,
            high: 1000000.0000,
            low: 999999.0000,
            close: 999999.5000,
          ),
        ],
        from: 'USD',
        to: 'BRL',
        success: true,
      );

      await tester.pumpWidget(createTestWidget(exchangeRates: exchangeRates));

      expect(find.byType(HistoricalDataWidget), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('should handle very small numbers', (
      WidgetTester tester,
    ) async {
      final exchangeRates = const ExchangeRatesEntity(
        data: [
          ExchangeRateDataEntity(
            date: '2024-01-01',
            open: 0.0001,
            high: 0.0002,
            low: 0.0001,
            close: 0.0001,
          ),
        ],
        from: 'USD',
        to: 'BRL',
        success: true,
      );

      await tester.pumpWidget(createTestWidget(exchangeRates: exchangeRates));

      expect(find.byType(HistoricalDataWidget), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('should maintain layout structure in different screen sizes', (
      WidgetTester tester,
    ) async {
      final exchangeRates = const ExchangeRatesEntity(
        data: [
          ExchangeRateDataEntity(
            date: '2024-01-01',
            open: 5.0,
            high: 5.2,
            low: 4.8,
            close: 5.1,
          ),
        ],
        from: 'USD',
        to: 'BRL',
        success: true,
      );

      await tester.binding.setSurfaceSize(const Size(300, 600));
      await tester.pumpWidget(createTestWidget(exchangeRates: exchangeRates));
      expect(find.byType(HistoricalDataWidget), findsOneWidget);

      await tester.binding.setSurfaceSize(const Size(800, 600));
      await tester.pumpWidget(createTestWidget(exchangeRates: exchangeRates));
      expect(find.byType(HistoricalDataWidget), findsOneWidget);

      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should handle mixed data scenarios', (
      WidgetTester tester,
    ) async {
      final exchangeRates = const ExchangeRatesEntity(
        data: [
          ExchangeRateDataEntity(
            date: '2024-01-01',
            open: 5.0,
            high: 5.2,
            low: 4.8,
            close: 5.1,
          ),
          ExchangeRateDataEntity(
            date: null,
            open: null,
            high: null,
            low: null,
            close: null,
          ),
          ExchangeRateDataEntity(
            date: '2024-01-03',
            open: 0.0,
            high: 5.2,
            low: 4.8,
            close: 5.1,
          ),
        ],
        from: 'USD',
        to: 'BRL',
        success: true,
      );

      await tester.pumpWidget(createTestWidget(exchangeRates: exchangeRates));

      expect(find.byType(Card), findsNWidgets(3));
      expect(find.text('01/01/2024'), findsOneWidget);
      expect(find.text('N/A'), findsOneWidget);
      expect(find.text('03/01/2024'), findsOneWidget);
    });

    testWidgets('should have proper text overflow handling', (
      WidgetTester tester,
    ) async {
      final exchangeRates = const ExchangeRatesEntity(
        data: [
          ExchangeRateDataEntity(
            date: '2024-01-01',
            open: 5.0,
            high: 5.2,
            low: 4.8,
            close: 5.1,
          ),
        ],
        from: 'USD',
        to: 'BRL',
        success: true,
      );

      await tester.pumpWidget(createTestWidget(exchangeRates: exchangeRates));

      final texts = find.byType(Text);
      expect(texts, findsAtLeastNWidgets(1));
    });

    testWidgets('should have proper flex distribution', (
      WidgetTester tester,
    ) async {
      final exchangeRates = const ExchangeRatesEntity(
        data: [
          ExchangeRateDataEntity(
            date: '2024-01-01',
            open: 5.0,
            high: 5.2,
            low: 4.8,
            close: 5.1,
          ),
        ],
        from: 'USD',
        to: 'BRL',
        success: true,
      );

      await tester.pumpWidget(createTestWidget(exchangeRates: exchangeRates));

      final expandedWidgets = find.byType(Expanded);
      expect(expandedWidgets, findsAtLeastNWidgets(2));
    });
  });
}
