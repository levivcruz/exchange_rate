import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:exchange_rate/src/features/home/presentation/widgets/exchange_result_button.dart';

void main() {
  group('ExchangeResultButton', () {
    Widget createTestWidget({
      VoidCallback? onPressed,
      bool isLoading = false,
      String text = 'exchange result',
    }) {
      return MaterialApp(
        home: Scaffold(
          body: ExchangeResultButton(
            onPressed: onPressed,
            isLoading: isLoading,
            text: text,
          ),
        ),
      );
    }

    testWidgets('should render without errors', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(onPressed: () {}));

      expect(find.byType(ExchangeResultButton), findsOneWidget);
    });

    testWidgets('should display button with default text', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget(onPressed: () {}));

      expect(find.text('EXCHANGE RESULT'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should display custom text when provided', (
      WidgetTester tester,
    ) async {
      const customText = 'Get Rate';

      await tester.pumpWidget(
        createTestWidget(onPressed: () {}, text: customText),
      );

      expect(find.text(customText.toUpperCase()), findsOneWidget);
    });

    testWidgets('should display loading indicator when isLoading is true', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(onPressed: () {}, isLoading: true),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(Text), findsNothing);
    });

    testWidgets('should display text when isLoading is false', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(onPressed: () {}, isLoading: false),
      );

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('should call onPressed when button is tapped and not loading', (
      WidgetTester tester,
    ) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        createTestWidget(onPressed: () => wasPressed = true, isLoading: false),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(wasPressed, isTrue);
    });

    testWidgets('should not call onPressed when button is loading', (
      WidgetTester tester,
    ) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        createTestWidget(onPressed: () => wasPressed = true, isLoading: true),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(wasPressed, isFalse);
    });

    testWidgets('should not call onPressed when onPressed is null', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(onPressed: null, isLoading: false),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('should have loading indicator with correct properties', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(onPressed: () {}, isLoading: true),
      );

      final loadingIndicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );

      expect(loadingIndicator.strokeWidth, 2);
      expect(loadingIndicator.valueColor, isA<AlwaysStoppedAnimation<Color>>());
    });

    testWidgets('should have loading indicator with correct size', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(onPressed: () {}, isLoading: true),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));

      expect(sizedBox.width, isNotNull);
      expect(sizedBox.height, isNotNull);
    });

    testWidgets('should handle text with different lengths', (
      WidgetTester tester,
    ) async {
      const shortText = 'Go';
      const longText = 'Get Current Exchange Rate Now';

      await tester.pumpWidget(
        createTestWidget(onPressed: () {}, text: shortText),
      );
      expect(find.text(shortText.toUpperCase()), findsOneWidget);

      await tester.pumpWidget(
        createTestWidget(onPressed: () {}, text: longText),
      );
      expect(find.text(longText.toUpperCase()), findsOneWidget);
    });

    testWidgets('should maintain structure in different states', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(onPressed: () {}, isLoading: true),
      );
      expect(find.byType(ExchangeResultButton), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpWidget(
        createTestWidget(onPressed: () {}, isLoading: false),
      );
      expect(find.byType(ExchangeResultButton), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('should handle rapid state changes', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(onPressed: () {}, isLoading: false),
      );

      await tester.pumpWidget(
        createTestWidget(onPressed: () {}, isLoading: true),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpWidget(
        createTestWidget(onPressed: () {}, isLoading: false),
      );
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('should have proper text styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(onPressed: () {}, isLoading: false),
      );

      final text = tester.widget<Text>(find.byType(Text));
      expect(text.textAlign, TextAlign.center);
      expect(text.style, isNotNull);
    });

    testWidgets('should handle empty text gracefully', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget(onPressed: () {}, text: ''));

      expect(find.text(''), findsOneWidget);
      expect(find.byType(ExchangeResultButton), findsOneWidget);
    });
  });
}
