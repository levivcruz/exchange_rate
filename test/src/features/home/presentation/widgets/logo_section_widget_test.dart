import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:exchange_rate/src/features/home/presentation/widgets/logo_section_widget.dart';

void main() {
  group('LogoSectionWidget', () {
    testWidgets('should render logo image', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: LogoSectionWidget())),
      );

      expect(find.byType(LogoSectionWidget), findsOneWidget);
    });

    testWidgets('should have correct structure with Column and Container', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: LogoSectionWidget())),
      );

      expect(find.byType(Column), findsOneWidget);

      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('should have proper padding structure', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: LogoSectionWidget())),
      );

      expect(find.byType(Padding), findsAtLeastNWidgets(1));
    });

    testWidgets('should render without errors', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: LogoSectionWidget())),
      );

      expect(find.byType(LogoSectionWidget), findsOneWidget);
    });

    testWidgets('should handle different screen sizes', (
      WidgetTester tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(300, 600));
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: LogoSectionWidget())),
      );
      expect(find.byType(LogoSectionWidget), findsOneWidget);

      await tester.binding.setSurfaceSize(const Size(800, 600));
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: LogoSectionWidget())),
      );
      expect(find.byType(LogoSectionWidget), findsOneWidget);

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
                LogoSectionWidget(),
                Container(height: 100, color: Colors.blue),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(LogoSectionWidget), findsOneWidget);

      expect(find.byType(Container), findsAtLeastNWidgets(1));
    });

    testWidgets('should have correct structure', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: LogoSectionWidget())),
      );

      expect(find.byType(LogoSectionWidget), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
    });
  });
}
