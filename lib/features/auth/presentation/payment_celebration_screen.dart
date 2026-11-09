import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';
import '../../../data/local/database.dart';
import '../../../data/local/preferences_manager.dart';
import '../../../data/remote/midtrans_payment_service.dart';
import '../../../shared/widgets/bento_card.dart';
import 'auth_notifier.dart';

/// Halaman Selebrasi Pembayaran Berhasil (Non-Scrollable 1-Screen Responsive Layout)
class PaymentCelebrationScreen extends ConsumerStatefulWidget {
  final String orderId;

  const PaymentCelebrationScreen({
    super.key,
    required this.orderId,
  });

  static Future<void> show(BuildContext context, {required String orderId}) {
    HapticFeedback.heavyImpact();
    return Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        opaque: true,
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (ctx, anim, secondaryAnim) => FadeTransition(
          opacity: anim,
          child: PaymentCelebrationScreen(orderId: orderId),
        ),
      ),
    );
  }

  @override
  ConsumerState<PaymentCelebrationScreen> createState() => _PaymentCelebrationScreenState();
}

class _PaymentCelebrationScreenState extends ConsumerState<PaymentCelebrationScreen> with TickerProviderStateMixin {
  late AnimationController _animController;
  late AnimationController _exitAnimController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _exitFadeAnimation;
  Timer? _autoRedirectTimer;
  bool _hasNavigated = false;
  bool _isProceeding = false;

  @override
  void initState() {
    super.initState();

    // 1. Controller untuk animasi masuk & partikel confetti
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    // 2. Controller untuk animasi keluar (fade-out saat berpindah)
    _exitAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.45, curve: Curves.elasticOut),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.15, 0.6, curve: Curves.easeIn),
    );

    _exitFadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _exitAnimController, curve: Curves.easeInOut),
    );

    _animController.forward();
    HapticFeedback.heavyImpact();

    // Segera sinkronkan status akses dari server di background dengan retry
    _syncLatestStatus();

    // Otomatis berpindah setelah 4.5 detik selebrasi jika pengguna tidak menekan tombol
    _autoRedirectTimer = Timer(const Duration(milliseconds: 4500), () {
      if (mounted && !_hasNavigated && !_isProceeding) {
        _proceedToApp();
      }
    });
  }

  Future<void> _syncLatestStatus() async {
    for (int i = 0; i < 3; i++) {
      if (!mounted || _isProceeding) return;
      try {
        final level = await ref.read(authNotifierProvider.notifier).refreshAccessLevel();
        if (level.isPremium || level.isAdmin) return;
      } catch (_) {}
      await Future.delayed(const Duration(milliseconds: 1500));
    }
  }

  Future<void> _proceedToApp() async {
    if (_hasNavigated || _isProceeding || !mounted) return;
    _autoRedirectTimer?.cancel();
    setState(() => _isProceeding = true);
    HapticFeedback.mediumImpact();

    // 1. Pastikan status akun aktif (retry hingga 3 kali jika server masih memproses webhook)
    for (int i = 0; i < 3; i++) {
      if (!mounted) return;
      try {
        final level = await ref.read(authNotifierProvider.notifier).refreshAccessLevel();
        if (level.isPremium || level.isAdmin) break;

        // Fallback pengecekan via Midtrans Core API jika orderId tersedia
        if (widget.orderId.isNotEmpty) {
          final paymentService = ref.read(midtransPaymentServiceProvider);
          final status = await paymentService.checkCoreApiStatus(widget.orderId);
          if (status.isSuccess) {
            await ref.read(authNotifierProvider.notifier).refreshAccessLevel();
            break;
          }
        }
      } catch (_) {}
      await Future.delayed(const Duration(milliseconds: 1200));
    }

    _hasNavigated = true;

    // 2. Jalankan animasi transisi keluar (fade-out bersih)
    await _exitAnimController.forward();
    if (!mounted) return;

    final userId = await AppPreferences.getUserId();
    final activeWeddingId = await AppPreferences.getActiveWeddingId();
    var userProfileId = await AppPreferences.getUserProfileId(userId);
    if ((userProfileId == null || userProfileId.isEmpty) && activeWeddingId != null && activeWeddingId.isNotEmpty) {
      userProfileId = activeWeddingId;
      await AppPreferences.setUserProfileId(userId, userProfileId);
    }

    final db = AppDatabase();
    String destination = '/setup';
    try {
      if (userProfileId != null && userProfileId.isNotEmpty) {
        final profile = await db.getProfileById(userProfileId);
        if (profile != null) {
          await AppPreferences.setActiveProfileId(userProfileId);
          destination = '/wedding/$userProfileId';
        }
      } else {
        final allProfiles = await db.getAllProfiles();
        if (allProfiles.isNotEmpty) {
          final firstId = allProfiles.first.id;
          await AppPreferences.setActiveProfileId(firstId);
          await AppPreferences.setUserProfileId(userId, firstId);
          destination = '/wedding/$firstId';
        }
      }
    } catch (_) {}

    if (!mounted) return;
    try {
      if (Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).popUntil((route) => route.isFirst);
      }
    } catch (_) {}

    if (mounted) {
      context.go(destination);
    }
  }

  @override
  void dispose() {
    _autoRedirectTimer?.cancel();
    _animController.dispose();
    _exitAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && !_isProceeding) {
          _proceedToApp();
        }
      },
      child: AnimatedBuilder(
        animation: _exitFadeAnimation,
        builder: (context, child) => Opacity(
          opacity: _exitFadeAnimation.value,
          child: child,
        ),
        child: Scaffold(
          backgroundColor: theme.colorScheme.surface,
          body: Stack(
            children: [
              // 1. Confetti Particle Background (Auto Fade-Out saat selesai jatuh)
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _animController,
                  builder: (context, _) => CustomPaint(
                    painter: _ConfettiPainter(progress: _animController.value),
                  ),
                ),
              ),

              // 2. Main Content (1-Screen Responsive Layout tanpa scroll)
              SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isSmallScreen = constraints.maxHeight < 680;
                    final iconSize = isSmallScreen ? 72.0 : 88.0;
                    final innerIconSize = isSmallScreen ? 42.0 : 50.0;
                    final cardPadding = isSmallScreen ? 14.0 : 18.0;
                    final spacing = isSmallScreen ? 12.0 : 20.0;

                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 18.0 : 24.0,
                        vertical: isSmallScreen ? 12.0 : 18.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Spacer(),

                          // Hero Badge Icon with Scale Animation
                          ScaleTransition(
                            scale: _scaleAnimation,
                            child: Center(
                              child: Container(
                                width: iconSize,
                                height: iconSize,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.amber.shade400,
                                      Colors.amber.shade700,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.amber.withValues(alpha: 0.35),
                                      blurRadius: 24,
                                      spreadRadius: 3,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Icon(
                                    PhosphorIconsFill.sealCheck,
                                    size: innerIconSize,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: spacing),

                          // Title & Congratulatory Text
                          FadeTransition(
                            opacity: _fadeAnimation,
                            child: Column(
                              children: [
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    'Pembayaran Berhasil! 🎉',
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: -0.5,
                                      fontSize: isSmallScreen ? 22 : 26,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Selamat! Akunmu sudah aktif. Kamu dan pasangan kini bisa menggunakan seluruh fitur Nikahin tanpa batas.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 12 : 13,
                                    color: theme.colorScheme.onSurfaceVariant,
                                    height: 1.35,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: spacing),

                          // Digital VIP Pass Card
                          FadeTransition(
                            opacity: _fadeAnimation,
                            child: BentoCard(
                              padding: EdgeInsets.all(cardPadding),
                              gradient: LinearGradient(
                                colors: [
                                  theme.colorScheme.primaryContainer.withValues(alpha: 0.6),
                                  theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.8),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.primary,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(PhosphorIconsFill.crown, size: 13, color: Colors.white),
                                            SizedBox(width: 4),
                                            Text(
                                              'VIP LIFETIME PASS',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                                        decoration: BoxDecoration(
                                          color: Colors.green.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: const Text(
                                          'STATUS: AKTIF',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(height: isSmallScreen ? 16 : 22),
                                  _buildInfoRow('Order ID', widget.orderId.isNotEmpty ? widget.orderId : 'NIKAHIN-CORE-VIP'),
                                  const SizedBox(height: 6),
                                  _buildInfoRow('Masa Berlaku', 'Seumur Hidup (Selamanya)'),
                                  const SizedBox(height: 6),
                                  _buildInfoRow('Sinkronisasi', 'Antar-perangkat otomatis'),
                                ],
                              ),
                            ),
                          ),

                          const Spacer(),

                          // Primary CTA Button
                          FadeTransition(
                            opacity: _fadeAnimation,
                            child: FilledButton.icon(
                              onPressed: _isProceeding ? null : _proceedToApp,
                              style: FilledButton.styleFrom(
                                backgroundColor: theme.colorScheme.primary,
                                foregroundColor: Colors.white,
                                minimumSize: Size.fromHeight(isSmallScreen ? 48 : 54),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 3,
                                shadowColor: theme.colorScheme.primary.withValues(alpha: 0.4),
                              ),
                              icon: _isProceeding
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : const Icon(PhosphorIconsFill.heart, size: 19),
                              label: Text(
                                _isProceeding
                                    ? 'Menyiapkan akun...'
                                    : 'Mulai Rencanakan Pernikahan',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 13.5 : 14.5,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Text(
              value,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}

/// Custom Confetti Particle Painter with Natural Fade-Out
class _ConfettiPainter extends CustomPainter {
  final double progress;
  static final List<_ConfettiParticle> _particles = List.generate(
    60,
    (index) => _ConfettiParticle(Random(index)),
  );

  _ConfettiPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Jika sudah 100%, jangan render apa-apa (0 beban GPU, bebas freeze)
    if (progress >= 1.0) return;

    // 2. Hitung kurva transparansi (Masuk cepat -> Melayang -> Fade-Out lembut hingga hilang 0.0)
    double fadeFactor;
    if (progress < 0.15) {
      fadeFactor = progress / 0.15;
    } else if (progress > 0.55) {
      fadeFactor = ((1.0 - progress) / 0.45).clamp(0.0, 1.0);
    } else {
      fadeFactor = 1.0;
    }

    for (final p in _particles) {
      final x = p.startX * size.width + p.driftX * progress * 90;
      final y = (p.startY + progress * p.speed * 1.4) * size.height;
      final opacity = (fadeFactor * 0.95).clamp(0.0, 1.0);
      if (opacity <= 0.01) continue;

      final paint = Paint()
        ..color = p.color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(progress * p.rotationSpeed);
      if (p.isCircle) {
        canvas.drawCircle(Offset.zero, p.size, paint);
      } else {
        canvas.drawRect(
          Rect.fromCenter(center: Offset.zero, width: p.size * 1.6, height: p.size),
          paint,
        );
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => oldDelegate.progress != progress;
}

class _ConfettiParticle {
  final double startX;
  final double startY;
  final double driftX;
  final double speed;
  final double rotationSpeed;
  final double size;
  final bool isCircle;
  final Color color;

  _ConfettiParticle(Random random)
      : startX = random.nextDouble(),
        startY = random.nextDouble() * -0.4,
        driftX = (random.nextDouble() - 0.5) * 2,
        speed = 0.9 + random.nextDouble() * 0.8,
        rotationSpeed = (random.nextDouble() - 0.5) * 12,
        size = 4 + random.nextDouble() * 6,
        isCircle = random.nextBool(),
        color = _colors[random.nextInt(_colors.length)];

  static final List<Color> _colors = [
    Colors.amber,
    Colors.pinkAccent,
    Colors.purpleAccent,
    Colors.lightBlueAccent,
    Colors.tealAccent,
    Colors.deepOrangeAccent,
    Colors.greenAccent,
  ];
}
