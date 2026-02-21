import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';
import 'providers/cart_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/order_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';
import 'providers/wishlist_provider.dart';
import 'screens/auth_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/home_screen.dart';
import 'screens/order_confirmation_screen.dart';
import 'screens/order_history_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/search_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/wishlist_screen.dart';
import 'utils/routes.dart';

class ShopVibeApp extends StatelessWidget {
  const ShopVibeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: Consumer2<ThemeProvider, LocaleProvider>(
        builder: (context, themeProvider, localeProvider, child) {
          return MaterialApp(
            title: 'ShopVibe',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.theme.copyWith(
              pageTransitionsTheme: const PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                  TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                  TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
                  TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
                  TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
                },
              ),
            ),
            locale: localeProvider.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            initialRoute: AppRoutes.splash,
            routes: {
              AppRoutes.splash: (_) => const SplashScreen(),
              AppRoutes.auth: (_) => const AuthScreen(),
              AppRoutes.home: (_) => const HomeScreen(),
              AppRoutes.productDetail: (_) => const ProductDetailScreen(),
              AppRoutes.cart: (_) => const CartScreen(),
              AppRoutes.checkout: (_) => const CheckoutScreen(),
              AppRoutes.orderConfirmation: (_) =>
                  const OrderConfirmationScreen(),
              AppRoutes.profile: (_) => const ProfileScreen(),
              AppRoutes.settings: (_) => const SettingsScreen(),
              AppRoutes.wishlist: (_) => const WishlistScreen(),
              AppRoutes.search: (_) => const SearchScreen(),
              AppRoutes.orderHistory: (_) => const OrderHistoryScreen(),
            },
          );
        },
      ),
    );
  }
}
