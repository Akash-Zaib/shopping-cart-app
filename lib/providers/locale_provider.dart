import 'package:flutter/material.dart';
import '../data/dummy_regions.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('en');
  Region _region = dummyRegions[0]; // Pakistan (PKR)

  Locale get locale => _locale;
  Region get region => _region;
  String get currencySymbol => _region.currencySymbol;

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }

  void setRegion(Region region) {
    _region = region;
    notifyListeners();
  }

  String formatPrice(double price) {
    // Prices stored in PKR (base). Conversion rates from PKR to other currencies.
    const rates = {
      'PKR': 1.0,
      'USD': 0.0036,
      'GBP': 0.0028,
      'EUR': 0.0033,
      'SAR': 0.0134,
      'AED': 0.0132,
      'CNY': 0.026,
      'TRY': 0.116,
      'IRR': 150.0,
    };

    final rate = rates[_region.currencyCode] ?? 1.0;
    final converted = price * rate;

    if (_region.currencyCode == 'IRR') {
      return '${_region.currencySymbol}${converted.round()}';
    }
    if (_region.currencyCode == 'PKR') {
      return 'Rs ${converted.round()}';
    }
    return '${_region.currencySymbol}${converted.toStringAsFixed(2)}';
  }
}
