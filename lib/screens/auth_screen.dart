import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';
import '../utils/constants.dart';
import '../utils/responsive_helper.dart';
import '../utils/routes.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSignUp = false;
  bool _obscurePassword = true;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _animController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  // ── actions ───────────────────────────────────────────────────────

  Future<void> _submitEmail() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    bool success;
    if (_isSignUp) {
      success = await auth.signUpWithEmail(email, password);
    } else {
      success = await auth.signInWithEmail(email, password);
    }

    if (success && mounted) {
      _syncUserAndNavigate(auth);
    }
  }

  Future<void> _submitGoogle() async {
    final auth = context.read<AuthProvider>();
    final success = await auth.signInWithGoogle();
    if (success && mounted) {
      _syncUserAndNavigate(auth);
    }
  }

  void _submitGuest() {
    // Reset profile to clean guest defaults, then go to home.
    context.read<UserProvider>().setFromFirebaseUser(null);
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  void _syncUserAndNavigate(AuthProvider auth) {
    // Sync Firebase user data into the local UserProvider.
    context.read<UserProvider>().setFromFirebaseUser(auth.user);
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  // ── build ─────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final r = ResponsiveHelper(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary,
              Color(0xFF8B5CF6),
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: r.horizontalPadding),
              child: r.constrainedContent(
                child: Column(
                  children: [
                    SizedBox(height: r.h(16)),
                    // ── Logo ──
                    _buildLogo(r),
                    SizedBox(height: r.h(20)),

                    // ── Card ──
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: r.cardPadding,
                          vertical: r.cardPadding),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            _isSignUp ? 'Create Account' : 'Welcome Back',
                            style: GoogleFonts.poppins(
                              fontSize: r.sp(22),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: r.h(4)),
                          Text(
                            _isSignUp
                                ? 'Sign up to get started'
                                : 'Sign in to continue shopping',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: r.sp(13),
                            ),
                          ),
                          SizedBox(height: r.h(16)),

                          // ── Error message ──
                          if (auth.errorMessage != null) ...[
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(r.cardPadding * 0.75),
                              decoration: BoxDecoration(
                                color: AppColors.error.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.error_outline,
                                      color: AppColors.error,
                                      size: r.iconSize(20)),
                                  SizedBox(width: r.w(8)),
                                  Expanded(
                                    child: Text(
                                      auth.errorMessage!,
                                      style: TextStyle(
                                        color: AppColors.error,
                                        fontSize: r.sp(13),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: auth.clearError,
                                    child: Icon(Icons.close,
                                        color: AppColors.error,
                                        size: r.iconSize(18)),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: r.h(16)),
                          ],

                          // ── Email / Password form ──
                          _buildEmailForm(r),
                          SizedBox(height: r.h(16)),

                          // ── Submit button ──
                          SizedBox(
                            width: double.infinity,
                            height: r.buttonHeight,
                            child: ElevatedButton(
                              onPressed: auth.isLoading ? null : _submitEmail,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 0,
                              ),
                              child: auth.isLoading
                                  ? SizedBox(
                                      width: r.iconSize(22),
                                      height: r.iconSize(22),
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      _isSignUp ? 'Sign Up' : 'Sign In',
                                      style: GoogleFonts.poppins(
                                        fontSize: r.sp(16),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(height: r.h(12)),

                          // ── Toggle sign in / sign up ──
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  _isSignUp
                                      ? 'Already have an account? '
                                      : "Don't have an account? ",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: r.sp(13),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() => _isSignUp = !_isSignUp);
                                  auth.clearError();
                                },
                                child: Text(
                                  _isSignUp ? 'Sign In' : 'Sign Up',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: r.sp(13),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: r.h(14)),

                          // ── Divider ──
                          Row(
                            children: [
                              Expanded(
                                  child:
                                      Divider(color: Colors.grey.shade300)),
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: r.w(12)),
                                child: Text(
                                  'OR',
                                  style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: r.sp(12),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Expanded(
                                  child:
                                      Divider(color: Colors.grey.shade300)),
                            ],
                          ),
                          SizedBox(height: r.h(14)),

                          // ── Google button ──
                          _buildSocialButton(
                            r: r,
                            label: 'Continue with Google',
                            leading: Image.network(
                              'https://www.google.com/images/branding/googleg/1x/googleg_standard_color_128dp.png',
                              width: r.iconSize(20),
                              height: r.iconSize(20),
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) =>
                                  Icon(Icons.g_mobiledata,
                                      size: r.iconSize(20)),
                            ),
                            onTap: auth.isLoading ? null : _submitGoogle,
                          ),
                          SizedBox(height: r.h(12)),

                          // ── Guest button ──
                          _buildSocialButton(
                            r: r,
                            label: 'Continue as Guest',
                            leading: Icon(Icons.person_outline,
                                color: Colors.grey.shade600,
                                size: r.iconSize(22)),
                            onTap: auth.isLoading ? null : _submitGuest,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: r.h(24)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── sub-widgets ───────────────────────────────────────────────────

  Widget _buildLogo(ResponsiveHelper r) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(r.cardPadding),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Icon(
            Icons.shopping_bag,
            size: r.iconSize(40),
            color: Colors.white,
          ),
        ),
        SizedBox(height: r.h(10)),
        Text(
          'ShopVibe',
          style: GoogleFonts.poppins(
            fontSize: r.sp(26),
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailForm(ResponsiveHelper r) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Email
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            style: TextStyle(fontSize: r.sp(14)),
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'you@example.com',
              prefixIcon: Icon(Icons.email_outlined, size: r.iconSize(20)),
              filled: true,
              fillColor: Colors.grey.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide:
                    const BorderSide(color: AppColors.primary, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.error),
              ),
              contentPadding: EdgeInsets.symmetric(
                  horizontal: r.cardPadding, vertical: r.h(16)),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value.trim())) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          SizedBox(height: r.h(14)),

          // Password
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _submitEmail(),
            style: TextStyle(fontSize: r.sp(14)),
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: '••••••••',
              prefixIcon: Icon(Icons.lock_outline, size: r.iconSize(20)),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: r.iconSize(20),
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide:
                    const BorderSide(color: AppColors.primary, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.error),
              ),
              contentPadding: EdgeInsets.symmetric(
                  horizontal: r.cardPadding, vertical: r.h(16)),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required ResponsiveHelper r,
    required String label,
    required Widget leading,
    VoidCallback? onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: r.buttonHeight - 4,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey.shade300),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: r.iconSize(24),
              height: r.iconSize(24),
              child: Center(child: leading),
            ),
            SizedBox(width: r.w(10)),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                  fontSize: r.sp(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
