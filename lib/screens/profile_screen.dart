import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/user_provider.dart';
import '../providers/order_provider.dart';
import '../providers/wishlist_provider.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final user = Provider.of<UserProvider>(context);
    final orders = Provider.of<OrderProvider>(context);
    final wishlist = Provider.of<WishlistProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.t('profile')),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Avatar & Info
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: user.profile.avatarUrl,
                            width: 106,
                            height: 106,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Icon(
                              Icons.person,
                              size: 50,
                              color: AppColors.primary,
                            ),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.person,
                              size: 50,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.profile.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.profile.email,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Stats Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                children: [
                  _buildStatCard(
                    context,
                    icon: Icons.shopping_bag,
                    label: l10n.t('myOrders'),
                    value: '${orders.orderCount}',
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 16),
                  _buildStatCard(
                    context,
                    icon: Icons.favorite,
                    label: l10n.t('wishlist'),
                    value: '${wishlist.itemCount}',
                    color: AppColors.secondary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Menu Items
            _buildMenuItem(
              context,
              icon: Icons.person_outline,
              label: l10n.t('editProfile'),
              onTap: () => _showEditProfileDialog(context, user, l10n),
            ),
            _buildMenuItem(
              context,
              icon: Icons.list_alt,
              label: l10n.t('myOrders'),
              trailing: orders.orderCount > 0 ? '${orders.orderCount}' : null,
              onTap: () => Navigator.pushNamed(context, AppRoutes.orderHistory),
            ),
            _buildMenuItem(
              context,
              icon: Icons.favorite_border,
              label: l10n.t('wishlist'),
              trailing: wishlist.itemCount > 0 ? '${wishlist.itemCount}' : null,
              onTap: () => Navigator.pushNamed(context, AppRoutes.wishlist),
            ),
            _buildMenuItem(
              context,
              icon: Icons.settings_outlined,
              label: l10n.t('settings'),
              onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
            ),
            _buildMenuItem(
              context,
              icon: Icons.help_outline,
              label: l10n.t('help'),
              onTap: () {},
            ),
            _buildMenuItem(
              context,
              icon: Icons.info_outline,
              label: l10n.t('about'),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'ShopVibe',
                  applicationVersion: '1.0.0',
                  applicationIcon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.shopping_bag,
                      color: AppColors.primary,
                      size: 32,
                    ),
                  ),
                  children: [
                    const Text('A modern shopping experience built with Flutter.'),
                  ],
                );
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppDimens.radiusMD),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    String? trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppDimens.radiusSM),
        ),
        child: Icon(icon, color: AppColors.primary, size: 22),
      ),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDimens.radiusRound),
              ),
              child: Text(
                trailing,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right, color: Colors.grey.shade400),
        ],
      ),
      onTap: onTap,
    );
  }

  void _showEditProfileDialog(
    BuildContext context,
    UserProvider user,
    AppLocalizations l10n,
  ) {
    final nameCtrl = TextEditingController(text: user.profile.name);
    final emailCtrl = TextEditingController(text: user.profile.email);
    final phoneCtrl = TextEditingController(text: user.profile.phone);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMD),
        ),
        title: Text(l10n.t('editProfile')),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneCtrl,
                decoration: const InputDecoration(labelText: 'Phone'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.t('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              user.updateProfile(
                name: nameCtrl.text,
                email: emailCtrl.text,
                phone: phoneCtrl.text,
              );
              Navigator.pop(ctx);
            },
            child: Text(l10n.t('confirm')),
          ),
        ],
      ),
    );
  }
}
