import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/dummy_products.dart';
import '../l10n/app_localizations.dart';
import '../models/product.dart';
import '../providers/locale_provider.dart';
import '../utils/constants.dart';
import '../utils/responsive_helper.dart';
import '../utils/routes.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/category_chip.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'All';
  int _currentIndex = 0;

  List<Product> get _filteredProducts {
    if (_selectedCategory == 'All') return dummyProducts;
    return dummyProducts.where((p) => p.category == _selectedCategory).toList();
  }

  void _onNavTap(int index) {
    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushNamed(context, AppRoutes.search);
        break;
      case 2:
        Navigator.pushNamed(context, AppRoutes.wishlist);
        break;
      case 3:
        Navigator.pushNamed(context, AppRoutes.profile);
        break;
    }
    if (index == 0) {
      setState(() => _currentIndex = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveHelper(context);

    // On desktop / tablet, use a NavigationRail instead of BottomNavigationBar.
    if (r.isDesktop || r.isTablet) {
      return _buildDesktopLayout(context, r);
    }
    return _buildMobileLayout(context, r);
  }

  // ── Desktop / Tablet layout with NavigationRail ────────────────────

  Widget _buildDesktopLayout(BuildContext context, ResponsiveHelper r) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            NavigationRail(
              selectedIndex: _currentIndex,
              onDestinationSelected: _onNavTap,
              labelType: NavigationRailLabelType.all,
              backgroundColor: Theme.of(context).cardColor,
              selectedIconTheme:
                  const IconThemeData(color: AppColors.primary),
              selectedLabelTextStyle: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: r.sp(11),
              ),
              unselectedLabelTextStyle: TextStyle(
                color: Colors.grey.shade500,
                fontSize: r.sp(11),
              ),
              destinations: [
                NavigationRailDestination(
                  icon: const Icon(Icons.home_outlined),
                  selectedIcon: const Icon(Icons.home),
                  label: Text(l10n.t('home')),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.search),
                  selectedIcon: const Icon(Icons.search),
                  label: Text(l10n.t('search')),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.favorite_border),
                  selectedIcon: const Icon(Icons.favorite),
                  label: Text(l10n.t('wishlist')),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.person_outline),
                  selectedIcon: const Icon(Icons.person),
                  label: Text(l10n.t('profile')),
                ),
              ],
            ),
            const VerticalDivider(width: 1, thickness: 1),
            Expanded(child: _buildScrollBody(context, r)),
          ],
        ),
      ),
    );
  }

  // ── Mobile layout with BottomNavigationBar ─────────────────────────

  Widget _buildMobileLayout(BuildContext context, ResponsiveHelper r) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(child: _buildScrollBody(context, r)),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: l10n.t('home'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search),
            activeIcon: const Icon(Icons.search),
            label: l10n.t('search'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite_border),
            activeIcon: const Icon(Icons.favorite),
            label: l10n.t('wishlist'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: l10n.t('profile'),
          ),
        ],
      ),
    );
  }

  // ── Shared scrollable body ─────────────────────────────────────────

  Widget _buildScrollBody(BuildContext context, ResponsiveHelper r) {
    final l10n = AppLocalizations.of(context);
    final locale = Provider.of<LocaleProvider>(context);
    final crossAxisCount = r.gridCrossAxisCount;
    final aspectRatio = r.gridChildAspectRatio;

    return CustomScrollView(
      slivers: [
        // App Bar
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                r.horizontalPadding, r.h(16), r.horizontalPadding - 8, r.h(8)),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.t('discoverMore'),
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: r.sp(13),
                        ),
                      ),
                      SizedBox(height: r.h(2)),
                      Text(
                        'ShopVibe ${locale.region.flag}',
                        style: TextStyle(
                          fontSize: r.sp(24),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const CartIconBadge(),
              ],
            ),
          ),
        ),

        // Search Bar
        SliverToBoxAdapter(
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, AppRoutes.search),
            child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: r.horizontalPadding, vertical: r.h(8)),
              padding: EdgeInsets.symmetric(
                  horizontal: r.cardPadding, vertical: r.h(14)),
              decoration: BoxDecoration(
                color: Theme.of(context).inputDecorationTheme.fillColor,
                borderRadius: BorderRadius.circular(AppDimens.radiusMD),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.search,
                      color: Colors.grey.shade400,
                      size: r.iconSize(24)),
                  const SizedBox(width: 12),
                  Text(
                    l10n.t('searchProducts'),
                    style: TextStyle(
                        color: Colors.grey.shade400, fontSize: r.sp(15)),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Banner
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(top: r.h(8)),
            child: const BannerCarousel(),
          ),
        ),

        // Categories
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                r.horizontalPadding, r.h(20), r.horizontalPadding, r.h(4)),
            child: Text(
              l10n.t('categories'),
              style: TextStyle(
                fontSize: r.sp(18),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 52,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding:
                  EdgeInsets.symmetric(horizontal: r.horizontalPadding),
              children: [
                CategoryChip(
                  label: l10n.t('allProducts'),
                  icon: Icons.apps,
                  isSelected: _selectedCategory == 'All',
                  onTap: () => setState(() => _selectedCategory = 'All'),
                ),
                const SizedBox(width: 8),
                ...categories.map((cat) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: CategoryChip(
                      label: cat,
                      icon: CategoryChip.getCategoryIcon(cat),
                      isSelected: _selectedCategory == cat,
                      onTap: () =>
                          setState(() => _selectedCategory = cat),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),

        // Featured label
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                r.horizontalPadding, r.h(20), r.horizontalPadding, r.h(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedCategory == 'All'
                      ? l10n.t('featured')
                      : _selectedCategory,
                  style: TextStyle(
                    fontSize: r.sp(18),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${_filteredProducts.length} ${l10n.t('items')}',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: r.sp(13),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Product Grid
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: r.horizontalPadding),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: aspectRatio,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final product = _filteredProducts[index];
                return ProductCard(
                  product: product,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.productDetail,
                      arguments: product,
                    );
                  },
                );
              },
              childCount: _filteredProducts.length,
            ),
          ),
        ),

        SliverPadding(padding: EdgeInsets.only(bottom: r.h(24))),
      ],
    );
  }
}
