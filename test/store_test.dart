import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eatko_food_delivery/core/models.dart';
import 'package:eatko_food_delivery/core/store.dart';

void main() {
  test(
    'Cart merges same sizes, separates portions and removes zero quantities',
    () {
      final s = AppStore();
      expect(s.total, 2948);
      s.add(foods.first, 'M', 2);
      expect(s.cart.first.quantity, 3);
      s.add(foods.first, 'L', 1);
      expect(s.cart.length, 4);
      expect(s.cart.last.unitPrice, 1099);
      s.change(s.cart.last, -1);
      expect(s.cart.length, 3);
      expect(s.total, 4746);
    },
  );
  test('Checkout snapshots total and clears the cart and delivery fee', () {
    final s = AppStore();
    s.checkout();
    expect(s.lastTotal, 2948);
    expect(s.hasOrder, isTrue);
    expect(s.count, 0);
    expect(s.total, 0);
  });
  test('Favorites, address and cart survive a local reload', () async {
    SharedPreferences.setMockInitialValues({});
    final s = await AppStore.load();
    s.favorite('rice');
    s.city = 'Tokyo';
    s.add(foods.first, 'S', 2);
    s.update();
    final restored = await AppStore.load();
    expect(restored.city, 'Tokyo');
    expect(restored.favorites, contains('rice'));
    expect(restored.cart.last.size, 'S');
    expect(restored.cart.last.quantity, 2);
  });
}
