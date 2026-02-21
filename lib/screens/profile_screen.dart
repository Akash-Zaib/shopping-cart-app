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
        child: r.constrainedContent(
          child: Column(
            children: [
              SizedBox(height: r.h(20)),

              // Avatar & Info
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: r.avatarRadius,
                          backgroundColor:
                              AppColors.primary.withValues(alpha: 0.1),
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: user.profile.avatarUrl,
                              width: r.avatarRadius * 2 - 4,
                              height: r.avatarRadius * 2 - 4,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Icon(
                                Icons.person,
                                size: r.iconSize(50),
                                color: AppColors.primary,
                              ),
                              errorWidget: (context, url, error) => Icon(
                                Icons.person,
                                size: r.iconSize(50),
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(r.w(6)),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Colors.white, width: 2),
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: r.iconSize(16),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: r.h(16)),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          user.profile.name,
                          style: TextStyle(
                            fontSize: r.sp(22),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (user.profile.isGuest) ...[
                          SizedBox(width: r.w(8)),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: r.w(8), vertical: r.h(2)),
                            decoration: BoxDecoration(
                              color: Colors.orange.withValues(alpha: 0.15),
                              borderRadius:
                                  BorderRadius.circular(AppDimens.radiusRound),
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
                    SizedBox(height: r.h(4)),
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
              SizedBox(height: r.h(24)),

              // Stats Row
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: r.horizontalPadding * 2),
                child: Row(
                  children: [
                    _buildStatCard(
                      context,
                      r: r,
                      icon: Icons.shopping_bag,
                      label: l10n.t('myOrders'),
                      value: '${orders.orderCount}',
                      color: AppColors.primary,
                    ),
                    SizedBox(width: r.w(16)),
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
              ),
              SizedBox(height: r.h(28)),

              // Menu Items
              _buildMenuItem(
                context,
                r: r,
                icon: Icons.person_outline,
                label: l10n.t('editProfile'),
                onTap: () => _showEditProfileDialog(context, user, l10n, r),
              ),
              _buildMenuItem(
                context,
                r: r,
                icon: Icons.list_alt,
                label: l10n.t('myOrders'),
                trailing:
                    orders.orderCount > 0 ? '${orders.orderCount}' : null,
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.orderHistory),
              ),
              _buildMenuItem(
                context,
                r: r,
                icon: Icons.favorite_border,
                label: l10n.t('wishlist'),
                trailing:
                    wishlist.itemCount > 0 ? '${wishlist.itemCount}' : null,
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.wishlist),
              ),
              _buildMenuItem(
                context,
                r: r,
                icon: Icons.settings_outlined,
                label: l10n.t('settings'),
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.settings),
              ),
              _buildMenuItem(
                context,
                r: r,
                icon: Icons.help_outline,
                label: l10n.t('help'),
                onTap: () {},
              ),
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
                      padding: EdgeInsets.all(r.w(8)),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.shopping_bag,
                        color: AppColors.primary,
                        size: r.iconSize(32),
                      ),
                    ),
                    children: [
                      const Text(
                          'A modern shopping experience built with Flutter.'),
                    ],
                  );
                },
              ),
              const Divider(indent: 24, endIndent: 24),
              if (user.profile.isGuest)
                _buildMenuItem(
                  context,
                  r: r,
                  icon: Icons.login,
                  label: 'Sign Up / Sign In',
                  onTap: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.auth,
                    (route) => false,
                  ),
                )
              else
                _buildMenuItem(
                  context,
                  r: r,
                  icon: Icons.logout,
                  label: 'Sign Out',
                  onTap: () => _handleSignOut(context),
                ),
              SizedBox(height: r.h(32)),
            ],
          ),
        ),
      ),
    );
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
        padding: EdgeInsets.all(r.cardPadding),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppDimens.radiusMD),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: r.iconSize(28)),
            SizedBox(height: r.h(8)),
            Text(
              value,
              style: TextStyle(
                fontSize: r.sp(22),
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: r.h(4)),
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
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
          horizontal: r.horizontalPadding, vertical: r.h(2)),
      leading: Container(
        padding: EdgeInsets.all(r.w(8)),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppDimens.radiusSM),
        ),
        child: Icon(icon, color: AppColors.primary, size: r.iconSize(22)),
      ),
      title: Text(label,
          style: TextStyle(
              fontWeight: FontWeight.w500, fontSize: r.sp(14))),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null)
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: r.w(8), vertical: r.h(2)),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDimens.radiusRound),
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
          SizedBox(width: r.w(8)),
          Icon(Icons.chevron_right, color: Colors.grey.shade400),
        ],
      ),
      onTap: onTap,
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
              SizedBox(height: r.h(12)),
              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              SizedBox(height: r.h(12)),
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
