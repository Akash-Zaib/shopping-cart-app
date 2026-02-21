import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../utils/constants.dart';
import '../utils/responsive_helper.dart';
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
    final r = ResponsiveHelper(context);

    return Column(
      children: [
        SizedBox(
          height: r.bannerHeight,
          child: PageView.builder(
            controller: _controller,
            itemCount: _banners.length,
            itemBuilder: (context, index) {
              final banner = _banners[index];
              return Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: r.horizontalPadding),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: banner.gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius:
                        BorderRadius.circular(AppDimens.radiusLG),
                  ),
                  padding: EdgeInsets.all(r.cardPadding),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              l10n.t(banner.titleKey),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: r.sp(18),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: r.h(4)),
                            Text(
                              '${l10n.t('upTo')} ${banner.discount} ${l10n.t('off')}',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: r.sp(13),
                              ),
                            ),
                            SizedBox(height: r.h(8)),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: r.w(14),
                                vertical: r.h(6),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                    AppDimens.radiusRound),
                              ),
                              child: Text(
                                l10n.t('shopNow'),
                                style: TextStyle(
                                  color: banner.gradient[0],
                                  fontWeight: FontWeight.w600,
                                  fontSize: r.sp(13),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        banner.icon,
                        size: r.iconSize(60),
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: r.h(12)),
        SmoothPageIndicator(
          controller: _controller,
          count: _banners.length,
          effect: WormEffect(
            dotHeight: r.w(8).clamp(6.0, 10.0),
            dotWidth: r.w(8).clamp(6.0, 10.0),
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
