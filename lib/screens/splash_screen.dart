import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';
import '../utils/responsive_helper.dart';
import '../utils/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        // Always show the auth screen first.
        Navigator.pushReplacementNamed(context, AppRoutes.auth);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveHelper(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              Color(0xFF8B5CF6),
              AppColors.secondary,
            ],
          ),
        ),
        child: Center(
          child: _AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(r.cardPadding),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Icon(
                          Icons.shopping_bag,
                          size: r.iconSize(72),
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: r.h(24)),
                      Text(
                        'ShopVibe',
                        style: GoogleFonts.poppins(
                          fontSize: r.sp(36),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                      SizedBox(height: r.h(8)),
                      Text(
                        'Shop Smart, Live Better',
                        style: GoogleFonts.poppins(
                          fontSize: r.sp(14),
                          color: Colors.white70,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _AnimatedBuilder extends AnimatedWidget {
  final Widget Function(BuildContext, Widget?) builder;

  const _AnimatedBuilder({
    required Animation<double> animation,
    required this.builder,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    return builder(context, null);
  }
}
