import 'package:flutter/material.dart';

import 'core/models.dart';
import 'core/store.dart';
import 'core/theme.dart';
import 'features/auth/auth_screens.dart';
import 'features/catalog/catalog_screens.dart';
import 'features/checkout/checkout_screens.dart';
import 'features/profile/profile_screens.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class EatkoApp extends StatelessWidget {
  const EatkoApp({
    super.key,
    required this.store,
    this.initialRoute,
    this.autoplaySplash = true,
  });
  final AppStore store;
  final String? initialRoute;
  final bool autoplaySplash;
  @override
  Widget build(BuildContext context) => StoreScope(
    store: store,
    child: MaterialApp(
      title: 'Eatko',
      theme: eatkoTheme(),
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      initialRoute: initialRoute ?? '/01',
      onGenerateRoute: _route,
      onGenerateInitialRoutes: (name) => [_route(RouteSettings(name: name))],
    ),
  );
  Route<void> _route(RouteSettings settings) {
    final child = switch (settings.name) {
      '/01' => SplashScreen(autoAdvance: autoplaySplash),
      '/02' => const OnboardingScreen(index: 0),
      '/03' => const OnboardingScreen(index: 1),
      '/04' => const OnboardingScreen(index: 2),
      '/05' => const AuthScreen(),
      '/06' => const AuthScreen(signup: true),
      '/07' => const RecoveryScreen(),
      '/08' => const RecoveryScreen(phone: true),
      '/09' => const LocationScreen(),
      '/10' => const PhoneScreen(),
      '/11' => const ConfirmationScreen(),
      '/12' => const SuccessScreen(),
      '/13' => const HomeScreen(),
      '/14' => FoodScreen(
        food: settings.arguments is Food
            ? settings.arguments as Food
            : foods.first,
      ),
      '/15' => SearchScreen(favoritesOnly: settings.arguments == 'favorites'),
      '/16' => CartScreen(previous: settings.arguments == 'previous'),
      '/17' => const FilterScreen(),
      '/18' => const AddressScreen(),
      '/19' => const AddressSummaryScreen(),
      '/20' => const PaymentScreen(),
      '/21' => const CardScreen(),
      '/22' => const TrackingScreen(),
      '/23' => const ProfileScreen(),
      '/24' => const ReviewScreen(),
      '/25' => const MenuScreen(),
      _ => const HomeScreen(),
    };
    return MaterialPageRoute<void>(settings: settings, builder: (_) => child);
  }
}
