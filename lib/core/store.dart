import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models.dart';

class AppStore extends ChangeNotifier {
  AppStore([this._prefs]);
  final SharedPreferences? _prefs;
  final List<CartLine> cart = [
    CartLine('salad', 'M', 1),
    CartLine('chicken', 'M', 1),
    CartLine('rice', 'M', 1),
  ];
  final Set<String> favorites = {'salad', 'baked'};
  final Set<String> viewed = {};
  String name = 'Chris Evans', email = 'chrisevans5478@gmail.com';
  String phone = '+1-202-555-0176', city = 'Bristol';
  String street = '9 Dunstan Road, Bristol, TA8 1ER';
  String addressType = 'Home', payment = 'Credit Card';
  bool saveAddress = true, hasOrder = false, rememberPayment = false;
  int lastTotal = 0, rating = 2;
  String review = '';

  static Future<AppStore> load() async {
    final prefs = await SharedPreferences.getInstance();
    final s = AppStore(prefs);
    final raw = prefs.getString('eatko');
    if (raw != null) {
      try {
        final j = jsonDecode(raw) as Map<String, dynamic>;
        s.name = j['name'] as String? ?? s.name;
        s.email = j['email'] as String? ?? s.email;
        s.phone = j['phone'] as String? ?? s.phone;
        s.city = j['city'] as String? ?? s.city;
        s.street = j['street'] as String? ?? s.street;
        s.hasOrder = j['hasOrder'] == true;
        s.lastTotal = j['lastTotal'] as int? ?? 0;
        s.review = j['review'] as String? ?? '';
        s.addressType = j['addressType'] as String? ?? 'Home';
        s.rating = j['rating'] as int? ?? 2;
        s.rememberPayment = j['rememberPayment'] == true;
        s.payment = j['payment'] as String? ?? 'Credit Card';
        s.viewed.addAll((j['viewed'] as List? ?? []).cast<String>());
        s.favorites
          ..clear()
          ..addAll((j['favorites'] as List).cast<String>());
        s.cart.clear();
        for (final line in j['cart'] as List) {
          if (foods.any((f) => f.id == line['food'])) {
            s.cart.add(CartLine(line['food'], line['size'], line['quantity']));
          }
        }
      } catch (_) {
        return AppStore(prefs);
      }
    }
    return s;
  }

  int get count => cart.fold(0, (v, e) => v + e.quantity);
  int get subtotal => cart.fold(0, (v, e) => v + e.unitPrice * e.quantity);
  int get delivery => cart.isEmpty ? 0 : 200;
  int get total => subtotal + delivery;
  void update() {
    notifyListeners();
    _prefs?.setString(
      'eatko',
      jsonEncode({
        'name': name,
        'email': email,
        'phone': saveAddress ? phone : null,
        'city': saveAddress ? city : null,
        'street': saveAddress ? street : null,
        'addressType': addressType,
        'rating': rating,
        'viewed': viewed.toList(),
        'rememberPayment': rememberPayment,
        'payment': rememberPayment ? payment : 'Credit Card',
        'favorites': favorites.toList(),
        'cart': cart.map((e) => e.toJson()).toList(),
        'hasOrder': hasOrder,
        'lastTotal': lastTotal,
        'review': review,
      }),
    );
  }

  void favorite(String id) {
    favorites.contains(id) ? favorites.remove(id) : favorites.add(id);
    update();
  }

  void add(Food food, String size, int quantity) {
    final index = cart.indexWhere((l) => l.key == '${food.id}:$size');
    if (index < 0) {
      cart.add(CartLine(food.id, size, quantity));
    } else {
      cart[index].quantity += quantity;
    }
    update();
  }

  void change(CartLine line, int delta) {
    line.quantity += delta;
    if (line.quantity <= 0) cart.remove(line);
    update();
  }

  void checkout() {
    lastTotal = total;
    hasOrder = true;
    cart.clear();
    update();
  }
}

class StoreScope extends InheritedNotifier<AppStore> {
  const StoreScope({super.key, required AppStore store, required super.child})
    : super(notifier: store);
  static AppStore of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<StoreScope>()!.notifier!;
}
