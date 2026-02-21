import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/dummy_regions.dart';
import '../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/constants.dart';
import '../utils/responsive_helper.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final r = ResponsiveHelper(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.t('settings'))),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(r.horizontalPadding),
        child: r.constrainedContent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Language Section
              _buildSectionTitle(l10n.t('language'), r),
              SizedBox(height: r.h(8)),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(AppDimens.radiusMD),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children:
                      AppLocalizations.supportedLocales.map((locale) {
                    final langCode = locale.languageCode;
                    final isSelected =
                        localeProvider.locale.languageCode == langCode;
                    return ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimens.radiusMD),
                      ),
                      leading: Container(
                        width: r.w(36),
                        height: r.w(36),
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
                              fontSize: r.sp(12),
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        AppLocalizations.languageNames[langCode] ??
                            langCode,
                        style: TextStyle(
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                          fontSize: r.sp(14),
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(Icons.check_circle,
                              color: AppColors.primary,
                              size: r.iconSize(22))
                          : null,
                      onTap: () {
                        localeProvider.setLocale(Locale(langCode));
                      },
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: r.h(28)),

              // Region Section
              _buildSectionTitle(l10n.t('region'), r),
              SizedBox(height: r.h(8)),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(AppDimens.radiusMD),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: dummyRegions.map((region) {
                    final isSelected =
                        localeProvider.region.code == region.code;
                    return ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimens.radiusMD),
                      ),
                      leading: Text(region.flag,
                          style: TextStyle(fontSize: r.sp(24))),
                      title: Text(
                        region.name,
                        style: TextStyle(
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                          fontSize: r.sp(14),
                        ),
                      ),
                      subtitle: Text(
                        '${region.currencyCode} (${region.currencySymbol})',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: r.sp(12),
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(Icons.check_circle,
                              color: AppColors.primary,
                              size: r.iconSize(22))
                          : null,
                      onTap: () {
                        localeProvider.setRegion(region);
                      },
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: r.h(28)),

              // Theme Toggle
              _buildSectionTitle(l10n.t('darkMode'), r),
              SizedBox(height: r.h(8)),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: r.cardPadding, vertical: r.h(4)),
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
                        size: r.iconSize(24),
                      ),
                      SizedBox(width: r.w(12)),
                      Text(
                        l10n.t('darkMode'),
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: r.sp(14)),
                      ),
                    ],
                  ),
                  value: themeProvider.isDarkMode,
                  activeColor: AppColors.primary,
                  onChanged: (_) => themeProvider.toggleTheme(),
                ),
              ),
              SizedBox(height: r.h(12)),

              // Notifications Toggle (dummy)
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: r.cardPadding, vertical: r.h(4)),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(AppDimens.radiusMD),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Row(
                    children: [
                      Icon(Icons.notifications_outlined,
                          color: AppColors.primary, size: r.iconSize(24)),
                      SizedBox(width: r.w(12)),
                      Text(
                        l10n.t('notifications'),
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: r.sp(14)),
                      ),
                    ],
                  ),
                  value: true,
                  activeColor: AppColors.primary,
                  onChanged: (_) {},
                ),
              ),
              SizedBox(height: r.h(32)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, ResponsiveHelper r) {
    return Text(
      title,
      style: TextStyle(
        fontSize: r.sp(18),
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
