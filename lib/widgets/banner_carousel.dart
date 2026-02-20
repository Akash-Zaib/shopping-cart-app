import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../utils/constants.dart';
import '../l10n/app_localizations.dart';

class BannerCarousel extends StatefulWidget {
  const BannerCarousel({super.key});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  final _controller = PageController();

  final List<_BannerData> _banners = [
    _BannerData(
      gradient: [AppColors.primary, const Color(0xFF8B5CF6)],
      icon: Icons.local_offer,
      titleKey: 'flashSale',
      subtitleKey: 'discoverMore',
      discount: '50%',
    ),
    _BannerData(
      gradient: [AppColors.secondary, const Color(0xFFFF8A65)],
      icon: Icons.new_releases,
      titleKey: 'newArrivals',
      subtitleKey: 'shopNow',
      discount: '30%',
    ),
    _BannerData(
      gradient: [AppColors.accent, const Color(0xFF26C6DA)],
      icon: Icons.star,
      titleKey: 'bestSellers',
      subtitleKey: 'discoverMore',
      discount: '20%',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _controller,
            itemCount: _banners.length,
            itemBuilder: (context, index) {
              final banner = _banners[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: banner.gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(AppDimens.radiusLG),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              l10n.t(banner.titleKey),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${l10n.t('upTo')} ${banner.discount} ${l10n.t('off')}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(AppDimens.radiusRound),
                              ),
                              child: Text(
                                l10n.t('shopNow'),
                                style: TextStyle(
                                  color: banner.gradient[0],
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        banner.icon,
                        size: 80,
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        SmoothPageIndicator(
          controller: _controller,
          count: _banners.length,
          effect: WormEffect(
            dotHeight: 8,
            dotWidth: 8,
            activeDotColor: AppColors.primary,
            dotColor: Colors.grey.shade300,
          ),
        ),
      ],
    );
  }
}

class _BannerData {
  final List<Color> gradient;
  final IconData icon;
  final String titleKey;
  final String subtitleKey;
  final String discount;

  _BannerData({
    required this.gradient,
    required this.icon,
    required this.titleKey,
    required this.subtitleKey,
    required this.discount,
  });
}
