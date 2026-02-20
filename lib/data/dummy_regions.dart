class Region {
  final String code;
  final String name;
  final String flag;
  final String currencyCode;
  final String currencySymbol;

  const Region({
    required this.code,
    required this.name,
    required this.flag,
    required this.currencyCode,
    required this.currencySymbol,
  });
}

const List<Region> dummyRegions = [
  Region(code: 'PK', name: 'Pakistan', flag: '🇵🇰', currencyCode: 'PKR', currencySymbol: 'Rs'),
  Region(code: 'US', name: 'United States', flag: '🇺🇸', currencyCode: 'USD', currencySymbol: '\$'),
  Region(code: 'GB', name: 'United Kingdom', flag: '🇬🇧', currencyCode: 'GBP', currencySymbol: '£'),
  Region(code: 'EU', name: 'European Union', flag: '🇪🇺', currencyCode: 'EUR', currencySymbol: '€'),
  Region(code: 'SA', name: 'Saudi Arabia', flag: '🇸🇦', currencyCode: 'SAR', currencySymbol: '﷼'),
  Region(code: 'AE', name: 'United Arab Emirates', flag: '🇦🇪', currencyCode: 'AED', currencySymbol: 'د.إ'),
  Region(code: 'CN', name: 'China', flag: '🇨🇳', currencyCode: 'CNY', currencySymbol: '¥'),
  Region(code: 'DE', name: 'Germany', flag: '🇩🇪', currencyCode: 'EUR', currencySymbol: '€'),
  Region(code: 'FR', name: 'France', flag: '🇫🇷', currencyCode: 'EUR', currencySymbol: '€'),
  Region(code: 'ES', name: 'Spain', flag: '🇪🇸', currencyCode: 'EUR', currencySymbol: '€'),
  Region(code: 'TR', name: 'Turkey', flag: '🇹🇷', currencyCode: 'TRY', currencySymbol: '₺'),
  Region(code: 'IR', name: 'Iran', flag: '🇮🇷', currencyCode: 'IRR', currencySymbol: '﷼'),
];
