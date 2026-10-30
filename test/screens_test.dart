import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eatko_food_delivery/app.dart';
import 'package:eatko_food_delivery/core/store.dart';

void main() {
  setUpAll(() async {
    final barlow = FontLoader('Barlow')
      ..addFont(rootBundle.load('assets/fonts/Barlow-Regular.ttf'))
      ..addFont(rootBundle.load('assets/fonts/Barlow-SemiBold.ttf'));
    final poppins = FontLoader('Poppins')
      ..addFont(rootBundle.load('assets/fonts/Poppins-Medium.ttf'));
    await barlow.load();
    await poppins.load();
  });
  testWidgets('All 25 Pixso routes render on phone sizes without exceptions', (
    tester,
  ) async {
    final handler = FlutterError.onError;
    FlutterError.onError = (details) {
      FlutterError.dumpErrorToConsole(details);
      handler?.call(details);
    };
    for (final size in [const Size(375, 812), const Size(320, 640)]) {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = size;
      for (var i = 1; i <= 25; i++) {
        final route = '/${i.toString().padLeft(2, '0')}';
        await tester.pumpWidget(
          EatkoApp(store: AppStore(), initialRoute: route),
        );
        await tester.pump(const Duration(milliseconds: 400));
        expect(tester.takeException(), isNull, reason: '$route at $size');
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump(const Duration(seconds: 2));
      }
    }
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  });

  testWidgets('Search filters local foods and handles no results', (
    tester,
  ) async {
    await tester.pumpWidget(EatkoApp(store: AppStore(), initialRoute: '/15'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'prawn');
    await tester.pumpAndSettle();
    expect(find.text('Found 1 items'), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, 'no-such-food');
    await tester.pumpAndSettle();
    expect(find.text('No dishes found'), findsOneWidget);
  });

  testWidgets('Phone form remains scrollable with the software keyboard', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(375, 812);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetViewInsets);
    await tester.pumpWidget(EatkoApp(store: AppStore(), initialRoute: '/10'));
    await tester.pumpAndSettle();
    tester.view.viewInsets = const FakeViewPadding(bottom: 320);
    await tester.showKeyboard(find.byType(TextFormField));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.ensureVisible(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Next').hitTestable(), findsOneWidget);
  });
}
