import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/dummy_regions.dart';
import '../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.t('settings'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Language Section
          _buildSectionTitle(l10n.t('language')),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(AppDimens.radiusMD),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: AppLocalizations.supportedLocales.map((locale) {
                final langCode = locale.languageCode;
                final isSelected =
                    localeProvider.locale.languageCode == langCode;
                return ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimens.radiusMD),
                  ),
                  leading: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        langCode.toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: isSelected ? AppColors.primary : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    AppLocalizations.languageNames[langCode] ?? langCode,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: AppColors.primary)
                      : null,
                  onTap: () {
                    localeProvider.setLocale(Locale(langCode));
                  },
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 28),

          // Region Section
          _buildSectionTitle(l10n.t('region')),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(AppDimens.radiusMD),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: dummyRegions.map((region) {
                final isSelected = localeProvider.region.code == region.code;
                return ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimens.radiusMD),
                  ),
                  leading: Text(region.flag, style: const TextStyle(fontSize: 24)),
                  title: Text(
                    region.name,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(
                    '${region.currencyCode} (${region.currencySymbol})',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: AppColors.primary)
                      : null,
                  onTap: () {
                    localeProvider.setRegion(region);
                  },
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 28),

          // Theme Toggle
          _buildSectionTitle(l10n.t('darkMode')),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(AppDimens.radiusMD),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Row(
                children: [
                  Icon(
                    themeProvider.isDarkMode
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    l10n.t('darkMode'),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              value: themeProvider.isDarkMode,
              activeColor: AppColors.primary,
              onChanged: (_) => themeProvider.toggleTheme(),
            ),
          ),
          const SizedBox(height: 12),

          // Notifications Toggle (dummy)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(AppDimens.radiusMD),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Row(
                children: [
                  const Icon(Icons.notifications_outlined, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Text(
                    l10n.t('notifications'),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              value: true,
              activeColor: AppColors.primary,
              onChanged: (_) {},
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
