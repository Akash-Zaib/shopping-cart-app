import 'package:flutter/material.dart';
import 'constants.dart';

/// Centralized responsive-scaling utility.
///
/// Instantiate with the current [BuildContext] and use the provided getters /
/// methods to obtain sizes that scale proportionally to the device screen.
///
/// Design baseline: 375 x 812 (iPhone 13 mini / SE-3).
class ResponsiveHelper {
  static const double _designWidth = 375.0;
  static const double _designHeight = 812.0;

  final BuildContext context;
  late final Size _screen;
  late final Orientation _orientation;

  ResponsiveHelper(this.context) {
    final mq = MediaQuery.of(context);
    _screen = mq.size;
    _orientation = mq.orientation;
  }

  // ── Raw screen info ─────────────────────────────────────────────────

  double get screenWidth => _screen.width;
  double get screenHeight => _screen.height;
  Orientation get orientation => _orientation;
  bool get isLandscape => _orientation == Orientation.landscape;

  // ── Device-type booleans ────────────────────────────────────────────

  bool get isMobile => _screen.width < AppDimens.mobileBreakpoint;
  bool get isTablet =>
      _screen.width >= AppDimens.mobileBreakpoint &&
      _screen.width < AppDimens.tabletBreakpoint;
  bool get isDesktop => _screen.width >= AppDimens.tabletBreakpoint;

  // ── Scale factors ───────────────────────────────────────────────────

  /// Width scale relative to the design baseline.
  double get widthFactor => _screen.width / _designWidth;

  /// Height scale relative to the design baseline.
  double get heightFactor => _screen.height / _designHeight;

  /// Conservative text-scale factor (clamped 0.85 – 1.3).
  double get textScale => (widthFactor).clamp(0.85, 1.3);

  // ── Proportional helpers ────────────────────────────────────────────

  /// Scale an arbitrary [value] by the width factor.
  double w(double value) => value * widthFactor;

  /// Scale an arbitrary [value] by the height factor.
  double h(double value) => value * heightFactor;

  /// Scale a font [size] using the text-scale factor.
  double sp(double size) => size * textScale;

  // ── Common dynamic values ───────────────────────────────────────────

  /// Horizontal body padding (16-40 depending on screen width).
  double get horizontalPadding {
    if (isDesktop) return 40.0;
    if (isTablet) return 32.0;
    return w(16).clamp(10.0, 24.0);
  }

  /// Standard button height.
  double get buttonHeight => h(52).clamp(44.0, 64.0);

  /// Standard text-field / input height.
  double get inputHeight => h(52).clamp(42.0, 60.0);

  /// Dynamic icon size from a [base] design value.
  double iconSize(double base) => (base * widthFactor).clamp(base * 0.85, base * 1.4);

  /// Dynamic image height from a [base] design value.
  double imageHeight(double base) => (base * heightFactor).clamp(base * 0.8, base * 1.5);

  /// Card / section internal padding.
  double get cardPadding {
    if (isDesktop) return 28.0;
    if (isTablet) return 24.0;
    return w(16).clamp(12.0, 20.0);
  }

  /// Maximum content width for single-column screens (auth, cart, checkout…).
  double get maxContentWidth {
    if (isDesktop) return 600.0;
    if (isTablet) return 540.0;
    return double.infinity; // no constraint on phone
  }

  /// Product-grid cross-axis count considering orientation.
  int get gridCrossAxisCount {
    if (isDesktop) return isLandscape ? 5 : 4;
    if (isTablet) return isLandscape ? 4 : 3;
    return isLandscape ? 3 : 2;
  }

  /// Product-grid child aspect ratio considering orientation.
  double get gridChildAspectRatio {
    if (isDesktop) return 0.72;
    if (isTablet) return 0.70;
    return isLandscape ? 0.72 : 0.58;
  }

  /// SliverAppBar expanded-height for product detail.
  double get productImageHeight {
    if (isLandscape) return _screen.height * 0.55;
    return _screen.height * 0.45;
  }

  /// Banner carousel height.
  double get bannerHeight {
    if (isDesktop) return 200.0;
    if (isTablet) return 180.0;
    return h(160).clamp(130.0, 200.0);
  }

  /// Profile avatar radius.
  double get avatarRadius {
    if (isDesktop) return 65.0;
    if (isTablet) return 60.0;
    return w(55).clamp(45.0, 65.0);
  }

  // ── Convenience widget wrapper ──────────────────────────────────────

  /// Wraps [child] in a centered, width-constrained box suitable for
  /// single-column layouts on wide screens.
  Widget constrainedContent({required Widget child}) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxContentWidth),
        child: child,
      ),
    );
  }
}
