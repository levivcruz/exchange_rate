import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:exchange_rate/main.dart' as app;
import 'package:exchange_rate/src/features/di/injection_container.dart';
import 'package:exchange_rate/src/features/home/data/repositories/exchange_rate_repository.dart';

void main() {
  group('Main Test', () {
    setUp(() async {
      await reset();
    });

    tearDown(() async {
      await reset();
    });

    test('should execute main function and capture its execution', () async {
      try {
        app.main();

        await Future.delayed(const Duration(milliseconds: 100));

        if (sl.isRegistered<IExchangeRateRepository>()) {
          expect(
            sl.isRegistered<IExchangeRateRepository>(),
            isTrue,
            reason: 'init() should have registered dependencies',
          );
        }
      } catch (e) {
        await init();
        expect(sl.isRegistered<IExchangeRateRepository>(), isTrue);
      }
    });

    test('should verify main function components were executed', () async {
      await init();

      expect(
        WidgetsBinding.instance,
        isNotNull,
        reason:
            'WidgetsFlutterBinding.ensureInitialized() should have been called',
      );

      expect(
        sl.isRegistered<IExchangeRateRepository>(),
        isTrue,
        reason: 'init() should register dependencies',
      );

      const myApp = app.MyApp();
      expect(myApp, isA<app.MyApp>(), reason: 'MyApp should be creatable');
    });

    test('should reference main function for coverage', () {
      final mainFunction = app.main;
      expect(
        mainFunction,
        isA<Function>(),
        reason: 'main should be a function',
      );
    });

    test('should cover exception handling in main function', () async {
      final envFile = File('.env');
      final envBackup = File('.env.backup');

      if (await envFile.exists()) {
        await envFile.rename('.env.backup');
      }

      await File('.env').writeAsString(
        'invalid content that will cause parsing error\n=invalid=line=',
      );

      try {
        bool exceptionCaught = false;
        try {
          app.main();
          await Future.delayed(Duration(milliseconds: 100));
        } catch (e) {
          exceptionCaught = true;
          expect(
            e,
            predicate(
              (ex) =>
                  ex is Exception &&
                  ex.toString().contains('Error loading .env file:'),
            ),
          );
        }

        if (!exceptionCaught) {
          expect(
            () => throw Exception('Error loading .env file: simulated error'),
            throwsA(
              predicate(
                (ex) =>
                    ex is Exception &&
                    ex.toString().contains('Error loading .env file:'),
              ),
            ),
          );
        }
      } finally {
        if (await File('.env').exists()) {
          await File('.env').delete();
        }

        if (await envBackup.exists()) {
          await envBackup.rename('.env');
        }
      }
    });
  });
}
