import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../data/local/database.dart';
import '../../../data/local/preferences_manager.dart';

/// Luxury Animated Splash Screen untuk Nikahin App (Warm Champagne & Sacred Melati Edition)
///
/// Memadukan palet resmi Sacred Melati Cream, Warm Champagne Blush, dan Deep Wine Luxury
/// dengan animasi bertingkat dan bootstrap navigator asinkron yang mulus.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _mainController;
  late final AnimationController _pulseController;
  late final AnimationController _exitController;

  late final Animation<double> _scaleAnimation;
  late final Animation<double> _logoFadeAnimation;
  late final Animation<double> _titleFadeAnimation;
  late final Animation<double> _taglineFadeAnimation;
  late final Animation<double> _subFadeAnimation;
  late final Animation<double> _footerFadeAnimation;
  late final Animation<double> _pulseAnimation;
  late final Animation<double> _exitFadeAnimation;
  late final Animation<double> _exitScaleAnimation;

  String? _targetRoute;
  String _appVersion = '';

  @override
  void initState() {
    super.initState();

    // Mengambil versi aplikasi secara dinamis dari package_info_plus (tanpa hardcode)
    PackageInfo.fromPlatform().then((info) {
      if (mounted) {
        setState(() {
          _appVersion = info.version;
        });
      }
    }).catchError((e) {
      debugPrint('[SplashScreen] Gagal mengambil PackageInfo: $e');
    });

    // 1. Controller untuk animasi kemunculan elemen (staggered entrance)
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    // 2. Controller untuk animasi breathing aura keemasan
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    // 3. Controller untuk transisi keluar halus dan tenang
    _exitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Entrance Animations: Diatur bertahap dan tenang
    _scaleAnimation = Tween<double>(begin: 0.72, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOutBack),
      ),
    );

    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.40, curve: Curves.easeOut),
      ),
    );

    _titleFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.20, 0.55, curve: Curves.easeOutCubic),
      ),
    );

    _taglineFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.35, 0.68, curve: Curves.easeOutCubic),
      ),
    );

    _subFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.48, 0.78, curve: Curves.easeOutCubic),
      ),
    );

    // Footer & Titik Loading muncul lebih awal agar terlihat jelas dan tenang
    _footerFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.55, 0.85, curve: Curves.easeOutCubic),
      ),
    );

    // Subtle Breathing Aura Pulse
    _pulseAnimation = Tween<double>(begin: 0.88, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Exit Fade & Gentle Scale Push (Kamera melayang perlahan mendekat saat transisi keluar)
    _exitFadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _exitController, curve: Curves.easeInOutCubic),
    );

    _exitScaleAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _exitController, curve: Curves.easeInOutCubic),
    );

    // Mulai animasi
    _mainController.forward();

    // Jalankan bootstrap logic secara paralel dengan durasi tampilan yang tenang dan elegan
    _bootstrapApp();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  /// Memproses verifikasi status sesi & alur rute pengguna di background
  Future<void> _bootstrapApp() async {
    final startTime = DateTime.now();

    try {
      final route = await _resolveTargetRoute();
      _targetRoute = route;
    } catch (e) {
      debugPrint('[SplashScreen] Bootstrap error: $e, fallback to /welcome');
      _targetRoute = '/welcome';
    }

    // Pastikan durasi tampilan splash cukup dan tenang (~2.8 detik)
    // memberi jeda 1.4+ detik setelah seluruh elemen & loading dots tampil penuh
    final elapsed = DateTime.now().difference(startTime);
    final remainingDelay = const Duration(milliseconds: 2800) - elapsed;
    if (remainingDelay > Duration.zero) {
      await Future.delayed(remainingDelay);
    }

    if (!mounted) return;

    // Transisi keluar halus
    await _exitController.forward();

    if (!mounted) return;
    context.go(_targetRoute ?? '/welcome');
  }

  /// Logika resolusi rute awal aplikasi Nikahin
  Future<String> _resolveTargetRoute() async {
    final hasSeenWelcome = await AppPreferences.hasSeenWelcome();
    if (!hasSeenWelcome) {
      return '/welcome';
    }

    final isDemo = await AppPreferences.isDemoMode();
    if (isDemo) {
      final activeId = await AppPreferences.getActiveProfileId();
      return '/wedding/$activeId';
    }

    final email = await AppPreferences.getUserEmail();
    if (email == null || email.isEmpty) {
      return '/login';
    }

    final accessLevel = await AppPreferences.getAccessLevel();
    final partnerOfUid = await AppPreferences.getPartnerOfUid();
    if (accessLevel == 'NONE' && (partnerOfUid == null || partnerOfUid.isEmpty)) {
      return '/pending-verification';
    }

    final userId = await AppPreferences.getUserId();
    final userProfileId = await AppPreferences.getUserProfileId(userId);

    if (userProfileId == null || userProfileId.isEmpty) {
      return '/setup';
    }

    final db = AppDatabase();
    try {
      final profile = await db.getProfileById(userProfileId);
      if (profile == null) {
        return '/setup';
      }
      await AppPreferences.setActiveProfileId(userProfileId);
      return '/wedding/$userProfileId';
    } finally {
      await db.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    // System UI status bar & navigation bar selaras dengan tema terang
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFFFFFDF9),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: AnimatedBuilder(
          animation: Listenable.merge([_mainController, _pulseController, _exitController]),
          builder: (context, _) {
            return Opacity(
              opacity: _exitFadeAnimation.value,
              child: Transform.scale(
                scale: _exitScaleAnimation.value,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFFDF9), // Sacred Melati Cream
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFFFFDF9), // Pure Melati Cream
                      Color(0xFFFDF7F0), // Warm Champagne Tint
                      Color(0xFFF7ECE0), // Subtle Golden Warmth vignette
                    ],
                    stops: [0.0, 0.55, 1.0],
                  ),
                ),
                child: SafeArea(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // 1. Atmospheric Golden Aura (Pulsing Center Glow)
                      Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Container(
                          width: 250,
                          height: 250,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                const Color(0xFFD4AF37).withValues(alpha: 0.16),
                                const Color(0xFFF7D9BC).withValues(alpha: 0.08),
                                Colors.transparent,
                              ],
                              stops: const [0.0, 0.55, 1.0],
                            ),
                          ),
                        ),
                      ),

                      // 2. Hero Center Content
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Brand Master Symbol with Warm Champagne & Sacred Melati Plate
                          Transform.scale(
                            scale: _scaleAnimation.value,
                            child: Opacity(
                              opacity: _logoFadeAnimation.value,
                              child: Container(
                                width: 118,
                                height: 118,
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFDF2E9), // Warm Champagne / Blush
                                  borderRadius: BorderRadius.circular(30),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFFFFFBF5), // Sacred Melati Cream
                                      Color(0xFFFDF2E9), // Warm Champagne Tint
                                    ],
                                  ),
                                  border: Border.all(
                                    color: const Color(0xFFD4AF37).withValues(alpha: 0.38),
                                    width: 1.4,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFD4AF37).withValues(alpha: 0.22),
                                      blurRadius: 24,
                                      offset: const Offset(0, 6),
                                    ),
                                    BoxShadow(
                                      color: const Color(0xFF4A1328).withValues(alpha: 0.06),
                                      blurRadius: 16,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Image.asset(
                                  'assets/logo/png/nikahin-symbol-master-512.png',
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, _, _) => Image.asset(
                                    'assets/logo/png/nikahin-symbol-master.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Brand Wordmark "Nikahin" (Deep Wine Luxury)
                          Opacity(
                            opacity: _titleFadeAnimation.value,
                            child: Transform.translate(
                              offset: Offset(0, 12 * (1 - _titleFadeAnimation.value)),
                              child: const Text(
                                'Nikahin',
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF4A1328), // Deep Wine Primary
                                  letterSpacing: -0.6,
                                  height: 1.1,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Brand Tagline "WEDDING PLANNER" (Royal Gold)
                          Opacity(
                            opacity: _taglineFadeAnimation.value,
                            child: Transform.translate(
                              offset: Offset(0, 8 * (1 - _taglineFadeAnimation.value)),
                              child: const Text(
                                'WEDDING PLANNER',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF9E781E), // Rich Gold accessible on cream
                                  letterSpacing: 4.8,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Romantic Subtitle (Clean Editorial Typography, No Pill Badge)
                          Opacity(
                            opacity: _subFadeAnimation.value,
                            child: Transform.translate(
                              offset: Offset(0, 6 * (1 - _subFadeAnimation.value)),
                              child: const Text(
                                '"Rencanakan Momen Bahagiamu"',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF7A2B47), // Muted Sacred Wine
                                  letterSpacing: 0.5,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // 3. Footer Indicator & Version Badge
                      Positioned(
                        bottom: 28,
                        left: 20,
                        right: 20,
                        child: Opacity(
                          opacity: _footerFadeAnimation.value,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Pulsing Golden Dots
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(3, (index) {
                                  return _buildPulsingDot(index);
                                }),
                              ),
                              const SizedBox(height: 14),

                              // Version Label (Dinamis dari package_info_plus, tidak pernah di-hardcode)
                              if (_appVersion.isNotEmpty)
                                Text(
                                  'Versi $_appVersion',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF4A1328).withValues(alpha: 0.50),
                                    letterSpacing: 0.8,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
          },
        ),
      ),
    );
  }

  /// Indikator titik loading pulsing keemasan
  Widget _buildPulsingDot(int index) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, _) {
        final delayFactor = (index * 0.3) % 1.0;
        final animValue = (_pulseController.value + delayFactor) % 1.0;
        final opacity = 0.35 + (0.65 * animValue);
        final size = 5.0 + (2.5 * animValue);

        return Container(
          width: size,
          height: size,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFB88A22).withValues(alpha: opacity),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFD4AF37).withValues(alpha: opacity * 0.45),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
        );
      },
    );
  }
}
