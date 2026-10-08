import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../shared/utils/validation_utils.dart';
import '../../shared/widgets/google_logo.dart';
import 'presentation/auth_notifier.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isRegisterMode = false;
  bool _passwordVisible = false;
  bool _rememberMe = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
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
          // Cek apakah user sudah punya profil pernikahan nyata
          context.go('/');
        }
      } else if (mounted) {
        setState(() {
          _errorMessage = ref.read(authNotifierProvider).errorMessage ?? 'Gagal masuk akun. Silakan coba lagi.';
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
        context.go('/');
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
    final emailResetCtrl = TextEditingController(text: _emailController.text);
    String? resetError;
    showDialog(
      context: context,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Text('Lupa Password?', style: TextStyle(fontWeight: FontWeight.bold)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Masukkan email akun Anda untuk menerima tautan reset kata sandi.'),
                  const SizedBox(height: 14),
                  TextField(
                    controller: emailResetCtrl,
                    keyboardType: TextInputType.emailAddress,
                    inputFormatters: [LengthLimitingTextInputFormatter(60)],
                    maxLength: 60,
                    buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                    decoration: InputDecoration(
                      labelText: 'Email Terdaftar',
                      prefixIcon: const Icon(Icons.email_outlined),
                      errorText: resetError,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogCtx).pop(),
                  child: const Text('Batal'),
                ),
                FilledButton(
                  onPressed: () {
                    final emailErr = ValidationUtils.validateEmail(emailResetCtrl.text.trim(), isRequired: true);
                    if (emailErr != null) {
                      setDialogState(() => resetError = emailErr);
                      return;
                    }
                    Navigator.of(dialogCtx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Tautan pemulihan kata sandi telah dikirim ke ${emailResetCtrl.text.trim()}')),
                    );
                  },
                  child: const Text('Kirim Link'),
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
    final textDark = theme.colorScheme.onSurface;
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Header Illustration (Matching Welcome Screen & 2-in-1 theme)
                  Center(
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            primaryColor,
                            theme.colorScheme.secondary,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withValues(alpha: 0.35),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.favorite_rounded,
                        color: Colors.white,
                        size: 48,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 2. Animated Header Title (Matching LoginScreen.kt)
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Column(
                      key: ValueKey<bool>(_isRegisterMode),
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isRegisterMode ? 'Buat Akun Baru' : 'Welcome Back! 👋',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: textDark,
                            fontFamily: theme.textTheme.displayLarge?.fontFamily,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _isRegisterMode
                              ? 'Yuk, mulai rencanakan pernikahan impian bersama'
                              : 'Yuk, masuk ke akun pernikahanmu',
                          style: TextStyle(
                            fontSize: 14,
                            color: textDark.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // 3. Error Banner
                  if (_errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline_rounded, color: theme.colorScheme.error, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(fontSize: 12, color: theme.colorScheme.onErrorContainer),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // 4. Form Fields
                  if (_isRegisterMode) ...[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nama Lengkap',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: textDark.withValues(alpha: 0.8),
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _nameController,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(50),
                            ValidationUtils.nameInputFormatter,
                          ],
                          maxLength: 50,
                          buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                          decoration: InputDecoration(
                            hintText: 'Contoh: Rivaldi / Alya',
                            prefixIcon: Icon(Icons.person_outline_rounded, color: primaryColor),
                          ),
                          validator: (val) =>
                              _isRegisterMode ? ValidationUtils.validateName(val, 'Nama Lengkap') : null,
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ],

                  // Email Field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: textDark.withValues(alpha: 0.8),
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
                        decoration: InputDecoration(
                          hintText: 'Masukkan email akun',
                          prefixIcon: Icon(Icons.email_outlined, color: primaryColor),
                        ),
                        validator: (val) => ValidationUtils.validateEmail(val, isRequired: true),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: textDark.withValues(alpha: 0.8),
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
                        decoration: InputDecoration(
                          hintText: 'Masukkan password',
                          prefixIcon: Icon(Icons.lock_outline_rounded, color: primaryColor),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                              color: textDark.withValues(alpha: 0.5),
                            ),
                            onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
                          ),
                        ),
                        validator: (val) => ValidationUtils.validatePassword(val, minLength: 6),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Remember Me & Forgot Password Row (Matching LoginScreen.kt)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            activeColor: primaryColor,
                            onChanged: (val) => setState(() => _rememberMe = val ?? true),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          ),
                          Text(
                            'Remember Me',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: textDark.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: _showForgotPasswordDialog,
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Primary Button (Coral/Rose)
                  SizedBox(
                    height: 52,
                    child: FilledButton(
                      onPressed: _isLoading ? null : _handleEmailAuth,
                      style: FilledButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                            )
                          : Text(
                              _isRegisterMode ? 'Sign Up' : 'Login',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Toggle Register/Login Row (Matching LoginScreen.kt)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isRegisterMode ? 'Already have an Account? ' : "Don't have an Account? ",
                        style: TextStyle(
                          fontSize: 14,
                          color: textDark.withValues(alpha: 0.8),
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
                          _isRegisterMode ? 'Sign in' : 'Sign up',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Divider "atau" (Matching LoginScreen.kt)
                  Row(
                    children: [
                      Expanded(child: Divider(color: theme.colorScheme.outlineVariant)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          ' atau ',
                          style: TextStyle(
                            fontSize: 12,
                            color: textDark.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: theme.colorScheme.outlineVariant)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Google Sign-In Button
                  SizedBox(
                    height: 52,
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : _handleGoogleSignIn,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: theme.colorScheme.surface,
                        side: BorderSide(color: theme.colorScheme.outlineVariant),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const GoogleLogo(size: 20),
                          const SizedBox(width: 12),
                          Text(
                            'Lanjutkan dengan Google',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Demo Mode Button
                  TextButton.icon(
                    onPressed: _isLoading ? null : _handleDemoMode,
                    icon: Icon(Icons.visibility_outlined, size: 18, color: textDark.withValues(alpha: 0.7)),
                    label: Text(
                      'Coba Mode Demo (Hanya Lihat)',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: textDark.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
