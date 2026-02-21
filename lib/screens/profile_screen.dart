import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';
import '../providers/order_provider.dart';
import '../providers/wishlist_provider.dart';
import '../utils/constants.dart';
import '../utils/responsive_helper.dart';
import '../utils/routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final user = Provider.of<UserProvider>(context);
    final orders = Provider.of<OrderProvider>(context);
    final wishlist = Provider.of<WishlistProvider>(context);
    final r = ResponsiveHelper(context);

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
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: r.maxFormWidth),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 24),

                  // ── Avatar & Info ──────────────────────────────────
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 55,
                              backgroundColor:
                                  AppColors.primary.withValues(alpha: 0.1),
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: user.profile.avatarUrl,
                                  width: 106,
                                  height: 106,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Icon(
                                    Icons.person,
                                    size: 48,
                                    color: AppColors.primary,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(
                                    Icons.person,
                                    size: 48,
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
                                  border: Border.all(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      width: 3),
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
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                user.profile.name,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: r.sp(22),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (user.profile.isGuest) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                  color:
                                      Colors.orange.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(
                                      AppDimens.radiusRound),
                                ),
                                child: Text(
                                  'Guest',
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: r.sp(11),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.profile.isGuest
                              ? 'Browsing as guest'
                              : user.profile.email,
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: r.sp(14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── Stats Row ──────────────────────────────────────
                  Row(
                    children: [
                      _buildStatCard(
                        context,
                        r: r,
                        icon: Icons.shopping_bag,
                        label: l10n.t('myOrders'),
                        value: '${orders.orderCount}',
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 16),
                      _buildStatCard(
                        context,
                        r: r,
                        icon: Icons.favorite,
                        label: l10n.t('wishlist'),
                        value: '${wishlist.itemCount}',
                        color: AppColors.secondary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // ── Menu Items (inside a card for cleaner look) ────
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius:
                          BorderRadius.circular(AppDimens.radiusMD),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        _buildMenuItem(
                          context,
                          r: r,
                          icon: Icons.person_outline,
                          label: l10n.t('editProfile'),
                          onTap: () => _showEditProfileDialog(
                              context, user, l10n, r),
                        ),
                        _menuDivider(),
                        _buildMenuItem(
                          context,
                          r: r,
                          icon: Icons.list_alt,
                          label: l10n.t('myOrders'),
                          trailing: orders.orderCount > 0
                              ? '${orders.orderCount}'
                              : null,
                          onTap: () => Navigator.pushNamed(
                              context, AppRoutes.orderHistory),
                        ),
                        _menuDivider(),
                        _buildMenuItem(
                          context,
                          r: r,
                          icon: Icons.favorite_border,
                          label: l10n.t('wishlist'),
                          trailing: wishlist.itemCount > 0
                              ? '${wishlist.itemCount}'
                              : null,
                          onTap: () => Navigator.pushNamed(
                              context, AppRoutes.wishlist),
                        ),
                        _menuDivider(),
                        _buildMenuItem(
                          context,
                          r: r,
                          icon: Icons.settings_outlined,
                          label: l10n.t('settings'),
                          onTap: () => Navigator.pushNamed(
                              context, AppRoutes.settings),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Support section ────────────────────────────────
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius:
                          BorderRadius.circular(AppDimens.radiusMD),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        _buildMenuItem(
                          context,
                          r: r,
                          icon: Icons.help_outline,
                          label: l10n.t('help'),
                          onTap: () {},
                        ),
                        _menuDivider(),
                        _buildMenuItem(
                          context,
                          r: r,
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
                                  color: AppColors.primary
                                      .withValues(alpha: 0.1),
                                  borderRadius:
                                      BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.shopping_bag,
                                  color: AppColors.primary,
                                  size: 32,
                                ),
                              ),
                              children: [
                                const Text(
                                    'A modern shopping experience built with Flutter.'),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Sign in/out ────────────────────────────────────
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius:
                          BorderRadius.circular(AppDimens.radiusMD),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: user.profile.isGuest
                        ? _buildMenuItem(
                            context,
                            r: r,
                            icon: Icons.login,
                            label: 'Sign Up / Sign In',
                            iconColor: AppColors.accent,
                            onTap: () =>
                                Navigator.pushNamedAndRemoveUntil(
                              context,
                              AppRoutes.auth,
                              (route) => false,
                            ),
                          )
                        : _buildMenuItem(
                            context,
                            r: r,
                            icon: Icons.logout,
                            label: 'Sign Out',
                            iconColor: AppColors.error,
                            onTap: () => _handleSignOut(context),
                          ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────

  Widget _menuDivider() {
    return Divider(
        height: 1, thickness: 1, color: Colors.grey.shade200, indent: 56);
  }

  Widget _buildStatCard(
    BuildContext context, {
    required ResponsiveHelper r,
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppDimens.radiusMD),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                fontSize: r.sp(22),
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: r.sp(12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required ResponsiveHelper r,
    required IconData icon,
    required String label,
    String? trailing,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    final color = iconColor ?? AppColors.primary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.radiusMD),
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.08),
                borderRadius:
                    BorderRadius.circular(AppDimens.radiusSM),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: r.sp(14),
                ),
              ),
            ),
            if (trailing != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius:
                      BorderRadius.circular(AppDimens.radiusRound),
                ),
                child: Text(
                  trailing,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: r.sp(12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Icon(Icons.chevron_right,
                color: Colors.grey.shade400, size: 22),
          ],
        ),
      ),
    );
  }

  void _handleSignOut(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMD),
        ),
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await Provider.of<AuthProvider>(context, listen: false).signOut();
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.auth,
          (route) => false,
        );
      }
    }
  }

  void _showEditProfileDialog(
    BuildContext context,
    UserProvider user,
    AppLocalizations l10n,
    ResponsiveHelper r,
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
