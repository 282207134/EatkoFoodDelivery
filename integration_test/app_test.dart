import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:eatko_food_delivery/app.dart';
import 'package:eatko_food_delivery/core/store.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Capture every Pixso route and verify a complete demo checkout', (
    tester,
  ) async {
    final store = AppStore();
    await tester.pumpWidget(
      EatkoApp(store: store, initialRoute: '/13', autoplaySplash: false),
    );
    await tester.pumpAndSettle();
    await binding.convertFlutterSurfaceToImage();
    await tester.pumpAndSettle();
    for (var i = 1; i <= 25; i++) {
      navigatorKey.currentState!.pushNamedAndRemoveUntil(
        '/${i.toString().padLeft(2, '0')}',
        (_) => false,
      );
      await tester.pumpAndSettle();
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 500)),
      );
      await tester.pumpAndSettle();
      await binding.takeScreenshot('screen_${i.toString().padLeft(2, '0')}');
      expect(tester.takeException(), isNull, reason: 'Screen $i');
    }
    navigatorKey.currentState!.pushNamedAndRemoveUntil('/14', (_) => false);
    await tester.pumpAndSettle();
    final before = store.count;
    await tester.tap(find.byTooltip('Increase quantity'));
    await tester.tap(find.text('Add to cart'));
    await tester.pumpAndSettle();
    expect(store.count, before + 2);
    ScaffoldMessenger.of(navigatorKey.currentContext!).clearSnackBars();
    await tester.pumpAndSettle();
    navigatorKey.currentState!.pushNamed('/16');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Checkout'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(2), '123');
    await tester.enterText(fields.at(3), '12/30');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Pay \$'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();
    expect(find.text('Track order'), findsOneWidget);
    expect(store.hasOrder, isTrue);
    expect(store.cart, isEmpty);
    await tester.tap(find.text('Review your delivery →'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextField),
      'Delicious food, arrived on time!',
    );
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Review'));
    await tester.pumpAndSettle();
    expect(find.text('Thank you!'), findsOneWidget);
    expect(store.review, 'Delicious food, arrived on time!');
  });
}
