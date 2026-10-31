import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../shared/utils/validation_utils.dart';
import '../../shared/widgets/google_logo.dart';
import '../../shared/widgets/wedding_doodle_background.dart';
import 'presentation/auth_notifier.dart';

/// Helper to generate the concave card path with rounded corners
/// and an elegant downward dip at the top edge.
Path _getConcaveCardPath(
  Size size,
  double dipDepth,
  double cornerRadius,
  double bottomRadius,
) {
  final path = Path();
  final w = size.width;
  final h = size.height;
  final cr = cornerRadius;
  final br = bottomRadius;

  // 1. Mulai dari sisi kiri tepat di bawah sudut kiri atas
  path.moveTo(0, cr);
  // Sudut cembung kiri atas
  path.quadraticBezierTo(0, 0, cr, 0);

  // 2. Lengkungan cekung di bagian atas (dips downward towards center)
  path.cubicTo(
    w * 0.28, dipDepth,
    w * 0.72, dipDepth,
    w - cr, 0,
  );

  // 3. Sudut cembung kanan atas
  path.quadraticBezierTo(w, 0, w, cr);

  // 4. Sisi kanan turun ke sudut kanan bawah
  path.lineTo(w, h - br);
  path.quadraticBezierTo(w, h, w - br, h);

  // 5. Sisi bawah menuju sudut kiri bawah
  path.lineTo(br, h);
  path.quadraticBezierTo(0, h, 0, h - br);

  // 6. Tutup path kembali ke (0, cr)
  path.close();
  return path;
}

/// Custom clipper yang memotong kontainer dengan lengkungan cekung di bagian atas.
class ConcaveTopCardClipper extends CustomClipper<Path> {
  final double dipDepth;
  final double cornerRadius;
  final double bottomRadius;

  const ConcaveTopCardClipper({
    this.dipDepth = 18.0,
    this.cornerRadius = 28.0,
    this.bottomRadius = 28.0,
  });

  @override
  Path getClip(Size size) {
    return _getConcaveCardPath(size, dipDepth, cornerRadius, bottomRadius);
  }

  @override
  bool shouldReclip(covariant ConcaveTopCardClipper oldClipper) =>
      oldClipper.dipDepth != dipDepth ||
      oldClipper.cornerRadius != cornerRadius ||
      oldClipper.bottomRadius != bottomRadius;
}

/// Shadow painter yang menggambar bayangan halus persis mengikuti bentuk kartu cekung.
class ConcaveCardShadowPainter extends CustomPainter {
  final double dipDepth;
  final double cornerRadius;
  final double bottomRadius;
  final Color shadowColor;
  final double blurRadius;
  final Offset offset;

  const ConcaveCardShadowPainter({
    this.dipDepth = 18.0,
    this.cornerRadius = 28.0,
    this.bottomRadius = 28.0,
    required this.shadowColor,
    this.blurRadius = 18.0,
    this.offset = const Offset(0, 8),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = _getConcaveCardPath(size, dipDepth, cornerRadius, bottomRadius);
    final paint = Paint()
      ..color = shadowColor
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurRadius);
    canvas.drawPath(path.shift(offset), paint);
  }

  @override
  bool shouldRepaint(covariant ConcaveCardShadowPainter oldDelegate) =>
      oldDelegate.shadowColor != shadowColor ||
      oldDelegate.dipDepth != dipDepth ||
      oldDelegate.cornerRadius != cornerRadius ||
      oldDelegate.bottomRadius != bottomRadius ||
      oldDelegate.blurRadius != blurRadius ||
      oldDelegate.offset != offset;
}

/// Border painter yang memberikan outline halus mengikuti kontur kartu cekung.
class ConcaveCardBorderPainter extends CustomPainter {
  final double dipDepth;
  final double cornerRadius;
  final double bottomRadius;
  final Color borderColor;
  final double strokeWidth;

  const ConcaveCardBorderPainter({
    this.dipDepth = 18.0,
    this.cornerRadius = 28.0,
    this.bottomRadius = 28.0,
    required this.borderColor,
    this.strokeWidth = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = _getConcaveCardPath(size, dipDepth, cornerRadius, bottomRadius);
    final paint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant ConcaveCardBorderPainter oldDelegate) =>
      oldDelegate.borderColor != borderColor ||
      oldDelegate.dipDepth != dipDepth ||
      oldDelegate.strokeWidth != strokeWidth;
}

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isRegisterMode = false;
  bool _passwordVisible = false;
  bool _rememberMe = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Otomatis bersihkan sesi aktif lama saat membuka layar login
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authNotifierProvider.notifier).signOut();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleEmailAuth() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final authNotifier = ref.read(authNotifierProvider.notifier);

      final success = _isRegisterMode
          ? await authNotifier.signUpWithEmail(email: email, password: password)
          : await authNotifier.signInWithEmail(email: email, password: password);

      if (success && mounted) {
        final authState = ref.read(authNotifierProvider);
        if (authState.isPendingVerification) {
          context.go('/pending-verification');
        } else {
          context.go('/');
        }
      } else if (mounted) {
        setState(() {
          _errorMessage = ref.read(authNotifierProvider).errorMessage ?? 'Gagal memproses akun. Silakan coba lagi.';
        });
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final success = await ref.read(authNotifierProvider.notifier).signInWithGoogle();
      if (success && mounted) {
        final authState = ref.read(authNotifierProvider);
        if (authState.isPendingVerification) {
          context.go('/pending-verification');
        } else {
          context.go('/');
        }
      } else if (!success && mounted) {
        final err = ref.read(authNotifierProvider).errorMessage;
        if (err != null && err.isNotEmpty) {
          setState(() {
            _errorMessage = err;
          });
        }
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleDemoMode() async {
    setState(() => _isLoading = true);
    try {
      await ref.read(authNotifierProvider.notifier).enterDemoMode();
      if (mounted) context.go('/wedding/profile_rivaldi_alya');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showForgotPasswordDialog() {
    final emailResetCtrl = TextEditingController(text: _emailController.text.trim());
    String? resetError;
    bool isSending = false;

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Row(
                children: [
                  Icon(Icons.lock_reset_rounded, color: Color(0xFFE11D48)),
                  SizedBox(width: 8),
                  Text('Lupa Kata Sandi?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Masukkan alamat email akunmu. Kami akan mengirimkan tautan untuk mengatur ulang kata sandi.',
                    style: TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: emailResetCtrl,
                    keyboardType: TextInputType.emailAddress,
                    enabled: !isSending,
                    inputFormatters: [LengthLimitingTextInputFormatter(60)],
                    maxLength: 60,
                    buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                    decoration: InputDecoration(
                      labelText: 'Email Terdaftar',
                      hintText: 'nama@example.com',
                      prefixIcon: const Icon(Icons.email_outlined),
                      errorText: resetError,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isSending ? null : () => Navigator.of(dialogCtx).pop(),
                  child: const Text('Batal'),
                ),
                FilledButton(
                  onPressed: isSending
                      ? null
                      : () async {
                          final email = emailResetCtrl.text.trim();
                          final emailErr = ValidationUtils.validateEmail(email, isRequired: true);
                          if (emailErr != null) {
                            setDialogState(() => resetError = emailErr);
                            return;
                          }

                          setDialogState(() {
                            isSending = true;
                            resetError = null;
                          });

                          final error = await ref.read(authNotifierProvider.notifier).sendPasswordResetEmail(email);

                          if (dialogCtx.mounted) {
                            if (error == null) {
                              Navigator.of(dialogCtx).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      const Icon(Icons.mark_email_read_rounded, color: Colors.white, size: 20),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Tautan pengaturan ulang kata sandi sudah dikirim ke $email. Silakan periksa kotak masuk atau folder spam.',
                                          style: const TextStyle(fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.green.shade700,
                                  duration: const Duration(seconds: 4),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                              );
                            } else {
                              setDialogState(() {
                                isSending = false;
                                resetError = error;
                              });
                            }
                          }
                        },
                  child: isSending
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Kirim Tautan Reset'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textDark = theme.colorScheme.onSurface;
    final primaryColor = theme.colorScheme.primary;

    // Field & card background colors
    final cardBgColor = isDark ? const Color(0xFF1E1E24) : Colors.white;
    final fieldBgColor = isDark ? const Color(0xFF26262E) : const Color(0xFFF7F5F0);
    final fieldBorderColor = isDark ? Colors.white.withValues(alpha: 0.1) : const Color(0xFFE8E5DD);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: WeddingDoodleBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 1. Official Header Brand Lockup (Logo + Wordmark centered)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Image.asset(
                        isDark
                            ? 'assets/logo/png/nikahin-lockup-header-dark.png'
                            : 'assets/logo/png/nikahin-lockup-header-light.png',
                        height: 38,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 2. Concave Curved Card (ClipPath + custom shadow & border)
                    CustomPaint(
                      painter: ConcaveCardShadowPainter(
                        dipDepth: 18.0,
                        cornerRadius: 28.0,
                        bottomRadius: 28.0,
                        shadowColor: isDark
                            ? Colors.black.withValues(alpha: 0.45)
                            : const Color(0xFF2C1810).withValues(alpha: 0.08),
                        blurRadius: 20.0,
                        offset: const Offset(0, 8),
                      ),
                      foregroundPainter: ConcaveCardBorderPainter(
                        dipDepth: 18.0,
                        cornerRadius: 28.0,
                        bottomRadius: 28.0,
                        borderColor: isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : const Color(0xFF2C1810).withValues(alpha: 0.06),
                        strokeWidth: 1.0,
                      ),
                      child: ClipPath(
                        clipper: const ConcaveTopCardClipper(
                          dipDepth: 18.0,
                          cornerRadius: 28.0,
                          bottomRadius: 28.0,
                        ),
                        child: Container(
                          color: cardBgColor,
                          padding: const EdgeInsets.fromLTRB(26, 36, 26, 28),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Title (Editorial Serif)
                                Text(
                                  _isRegisterMode ? 'Mulai Rencana Bahagiamu' : 'Selamat Datang Kembali!',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: textDark,
                                    height: 1.25,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _isRegisterMode
                                      ? 'Daftarkan akunmu dan kelola setiap momen spesial'
                                      : 'Masuk untuk melanjutkan persiapan hari bahagiamu',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: textDark.withValues(alpha: 0.65),
                                    height: 1.4,
                                  ),
                                ),

                                // Error Banner
                                if (_errorMessage != null) ...[
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.errorContainer.withValues(alpha: 0.65),
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: theme.colorScheme.error.withValues(alpha: 0.25),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.error_outline_rounded, color: theme.colorScheme.error, size: 18),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            _errorMessage!,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: theme.colorScheme.onErrorContainer,
                                              height: 1.3,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 22),

                                // Email Field
                                Text(
                                  'Email',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: textDark.withValues(alpha: 0.85),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  inputFormatters: [LengthLimitingTextInputFormatter(60)],
                                  maxLength: 60,
                                  buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                                  style: TextStyle(fontSize: 14, color: textDark),
                                  decoration: InputDecoration(
                                    hintText: 'nama@example.com',
                                    hintStyle: TextStyle(
                                      color: textDark.withValues(alpha: 0.35),
                                      fontSize: 13.5,
                                    ),
                                    filled: true,
                                    fillColor: fieldBgColor,
                                    prefixIcon: Icon(Icons.mail_outline_rounded, size: 20, color: textDark.withValues(alpha: 0.45)),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(color: fieldBorderColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(color: fieldBorderColor),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(color: primaryColor, width: 1.5),
                                    ),
                                  ),
                                  validator: (val) => ValidationUtils.validateEmail(val, isRequired: true),
                                ),
                                const SizedBox(height: 14),

                                // Password Field
                                Text(
                                  'Kata Sandi',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: textDark.withValues(alpha: 0.85),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: !_passwordVisible,
                                  textInputAction: TextInputAction.done,
                                  inputFormatters: [LengthLimitingTextInputFormatter(32)],
                                  maxLength: 32,
                                  buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                                  style: TextStyle(fontSize: 14, color: textDark),
                                  decoration: InputDecoration(
                                    hintText: '••••••••',
                                    hintStyle: TextStyle(
                                      color: textDark.withValues(alpha: 0.35),
                                      fontSize: 13.5,
                                    ),
                                    filled: true,
                                    fillColor: fieldBgColor,
                                    prefixIcon: Icon(Icons.lock_outline_rounded, size: 20, color: textDark.withValues(alpha: 0.45)),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _passwordVisible ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                                        size: 20,
                                        color: textDark.withValues(alpha: 0.45),
                                      ),
                                      onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(color: fieldBorderColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(color: fieldBorderColor),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(color: primaryColor, width: 1.5),
                                    ),
                                  ),
                                  validator: (val) => ValidationUtils.validatePassword(val, minLength: 6),
                                ),
                                const SizedBox(height: 10),

                                // Remember Me & Forgot Password Row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () => setState(() => _rememberMe = !_rememberMe),
                                      borderRadius: BorderRadius.circular(6),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 4),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              width: 22,
                                              height: 22,
                                              child: Checkbox(
                                                value: _rememberMe,
                                                activeColor: primaryColor,
                                                onChanged: (val) => setState(() => _rememberMe = val ?? true),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                                side: BorderSide(
                                                  color: textDark.withValues(alpha: 0.3),
                                                  width: 1.5,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Ingat Saya',
                                              style: TextStyle(
                                                fontSize: 12.5,
                                                fontWeight: FontWeight.w500,
                                                color: textDark.withValues(alpha: 0.75),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (!_isRegisterMode)
                                      TextButton(
                                        onPressed: _showForgotPasswordDialog,
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                          minimumSize: Size.zero,
                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        child: Text(
                                          'Lupa Kata Sandi?',
                                          style: TextStyle(
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.w600,
                                            color: primaryColor,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 20),

                                // Primary Button (Pill shape)
                                SizedBox(
                                  height: 48,
                                  child: FilledButton(
                                    onPressed: _isLoading ? null : _handleEmailAuth,
                                    style: FilledButton.styleFrom(
                                      backgroundColor: primaryColor,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                    ),
                                    child: _isLoading
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2.2,
                                            ),
                                          )
                                        : Text(
                                            _isRegisterMode ? 'Daftar Sekarang' : 'Masuk Sekarang',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14.5,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Divider "atau lanjutkan dengan"
                                Row(
                                  children: [
                                    Expanded(
                                      child: Divider(
                                        color: textDark.withValues(alpha: 0.12),
                                        thickness: 0.8,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      child: Text(
                                        'atau lanjutkan dengan',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: textDark.withValues(alpha: 0.5),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Divider(
                                        color: textDark.withValues(alpha: 0.12),
                                        thickness: 0.8,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 18),

                                // Social Buttons Row (Google & Demo Mode side-by-side)
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: _isLoading ? null : _handleGoogleSignIn,
                                        style: OutlinedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                          backgroundColor: fieldBgColor,
                                          side: BorderSide(color: fieldBorderColor),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const GoogleLogo(size: 18),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Google',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13,
                                                color: textDark,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: _isLoading ? null : _handleDemoMode,
                                        style: OutlinedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                          backgroundColor: fieldBgColor,
                                          side: BorderSide(color: fieldBorderColor),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.visibility_outlined,
                                              size: 18,
                                              color: textDark.withValues(alpha: 0.7),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Demo Mode',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13,
                                                color: textDark,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 3. Toggle Register/Login Footer Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _isRegisterMode ? 'Sudah memiliki akun? ' : 'Belum memiliki akun? ',
                          style: TextStyle(
                            fontSize: 13.5,
                            color: textDark.withValues(alpha: 0.75),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isRegisterMode = !_isRegisterMode;
                              _errorMessage = null;
                            });
                          },
                          child: Text(
                            _isRegisterMode ? 'Masuk' : 'Daftar Sekarang',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
