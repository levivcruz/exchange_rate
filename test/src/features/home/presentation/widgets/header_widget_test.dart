import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:exchange_rate/src/features/home/presentation/widgets/header_widget.dart';

void main() {
  group('HeaderWidget', () {
    testWidgets('should render with correct title text', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: HeaderWidget())),
      );

      expect(find.text('BRL EXCHANGE RATE'), findsOneWidget);
    });

    testWidgets('should have correct text styling', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: HeaderWidget())),
      );

      final textWidget = tester.widget<Text>(find.text('BRL EXCHANGE RATE'));

      expect(textWidget.textAlign, equals(TextAlign.center));

      expect(textWidget.style, isNotNull);
    });

    testWidgets('should be contained in a Container', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: HeaderWidget())),
      );

      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('should have proper padding structure', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: HeaderWidget())),
      );

      expect(find.byType(Padding), findsAtLeastNWidgets(1));
    });

    testWidgets('should render without errors in different screen sizes', (
      WidgetTester tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(300, 600));
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: HeaderWidget())),
      );
      expect(find.text('BRL EXCHANGE RATE'), findsOneWidget);

      await tester.binding.setSurfaceSize(const Size(800, 600));
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: HeaderWidget())),
      );
      expect(find.text('BRL EXCHANGE RATE'), findsOneWidget);

      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should be properly positioned in layout', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                HeaderWidget(),
                Container(height: 100, color: Colors.red),
              ],
            ),
          ),
        ),
      );

      expect(find.text('BRL EXCHANGE RATE'), findsOneWidget);

      expect(find.byType(Container), findsAtLeastNWidgets(2));
    });

    testWidgets('should handle theme changes', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: Scaffold(body: HeaderWidget()),
        ),
      );
      expect(find.text('BRL EXCHANGE RATE'), findsOneWidget);

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Scaffold(body: HeaderWidget()),
        ),
      );
      expect(find.text('BRL EXCHANGE RATE'), findsOneWidget);
    });
  });
}
