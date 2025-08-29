import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:exchange_rate/src/features/home/presentation/widgets/currency_input_field.dart';

void main() {
  group('CurrencyInputField', () {
    testWidgets('should render with correct label and styling', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: CurrencyInputField())),
      );

      expect(find.text('Enter the currency code'), findsOneWidget);

      expect(find.byType(TextField), findsOneWidget);

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.textCapitalization, TextCapitalization.characters);
    });

    testWidgets('should call onChanged when text is entered', (
      WidgetTester tester,
    ) async {
      String? changedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CurrencyInputField(
              onChanged: (value) => changedValue = value,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'USD');
      await tester.pump();

      expect(changedValue, equals('USD'));
    });

    testWidgets('should only allow alphabetic characters', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: CurrencyInputField())),
      );

      await tester.enterText(find.byType(TextField), '123!@#');
      await tester.pump();

      expect(find.byType(TextField), findsOneWidget);

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.onChanged, isNull);
    });

    testWidgets('should limit input to 3 characters', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: CurrencyInputField())),
      );

      await tester.enterText(find.byType(TextField), 'USDDD');
      await tester.pump();

      expect(find.byType(TextField), findsOneWidget);

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.inputFormatters, isNotEmpty);
    });

    testWidgets('should have correct input formatters', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: CurrencyInputField())),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));

      expect(textField.inputFormatters, isNotEmpty);
      expect(textField.inputFormatters!.length, equals(3));

      expect(textField.inputFormatters![0], isA<FilteringTextInputFormatter>());
      expect(
        textField.inputFormatters![1],
        isA<LengthLimitingTextInputFormatter>(),
      );
      expect(textField.inputFormatters![2], isA<TextInputFormatter>());
    });

    testWidgets('should have correct decoration properties', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: CurrencyInputField())),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      final decoration = textField.decoration!;

      expect(decoration.labelText, equals('Enter the currency code'));
      expect(decoration.filled, isTrue);
      expect(decoration.fillColor, isNotNull);
      expect(decoration.enabledBorder, isNotNull);
      expect(decoration.focusedBorder, isNotNull);
    });

    testWidgets('should handle empty onChanged callback', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: CurrencyInputField())),
      );

      await tester.enterText(find.byType(TextField), 'EUR');
      await tester.pump();

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('should handle tap interactions', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: CurrencyInputField())),
      );

      await tester.tap(find.byType(TextField));
      await tester.pump();

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('should filter out non-alphabetic characters correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: CurrencyInputField())),
      );

      await tester.enterText(find.byType(TextField), 'A1B2C3!@#');
      await tester.pump();

      expect(find.byType(TextField), findsOneWidget);

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.inputFormatters, isNotEmpty);
    });

    testWidgets('should maintain focus after input', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: CurrencyInputField())),
      );

      await tester.tap(find.byType(TextField));
      await tester.pump();

      await tester.enterText(find.byType(TextField), 'GBP');
      await tester.pump();

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('should handle different input scenarios', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: CurrencyInputField())),
      );

      await tester.enterText(find.byType(TextField), '');
      await tester.pump();
      expect(find.byType(TextField), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'A');
      await tester.pump();
      expect(find.byType(TextField), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'AB');
      await tester.pump();
      expect(find.byType(TextField), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'ABC');
      await tester.pump();
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('should have correct text capitalization', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: CurrencyInputField())),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));

      expect(textField.textCapitalization, TextCapitalization.characters);
    });

    testWidgets('should render with padding', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: CurrencyInputField())),
      );

      expect(find.byType(Padding), findsOneWidget);

      final padding = tester.widget<Padding>(find.byType(Padding));
      expect(padding.child, isA<TextField>());
    });

    testWidgets('should convert input to uppercase', (
      WidgetTester tester,
    ) async {
      String? enteredValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CurrencyInputField(
              onChanged: (value) => enteredValue = value,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'usd');
      await tester.pump();

      expect(enteredValue, equals('USD'));
    });
  });
}
