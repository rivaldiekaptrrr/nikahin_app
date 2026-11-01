import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/local/preferences_manager.dart';
import '../../shared/widgets/concave_card.dart';
import '../../shared/widgets/wedding_doodle_background.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_WelcomeSlideData> _slides = const [
    _WelcomeSlideData(
      titlePrefix: 'Satu Rencana Bahagia\n',
      titleAccent: 'Terhubung Berdua',
      titleSuffix: '',
      description:
          'Cukup tautkan kode pasangan, seluruh checklist, anggaran, dan catatan persiapan otomatis tersinkron di ponsel berdua.',
      imageAsset: 'assets/images/welcome1.png',
      isCutout: true,
    ),
    _WelcomeSlideData(
      titlePrefix: 'Kendali Anggaran &\n',
      titleAccent: 'Pembayaran Vendor',
      titleSuffix: '',
      description:
          'Catat setiap pos biaya, pantau termin DP hingga pelunasan vendor, dan pastikan pengeluaran pesta tetap aman tanpa boncos.',
      imageAsset: 'assets/images/welcome2.jpg',
      isCutout: false,
    ),
    _WelcomeSlideData(
      titlePrefix: 'Checklist Persiapan\n',
      titleAccent: 'Hingga Hari-H Teratur',
      titleSuffix: '',
      description:
          'Pantau progres tugas dari berkas KUA, seserahan, hingga susunan acara menit demi menit agar momen bahagiamu berjalan tanpa kendala.',
      imageAsset: 'assets/images/welcome3.jpg',
      isCutout: false,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() async {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeInOutCubic,
      );
    } else {
      await AppPreferences.setHasSeenWelcome(true);
      if (mounted) context.go('/login');
    }
  }

  void _onPrevious() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _onSkip() async {
    await AppPreferences.setHasSeenWelcome(true);
    if (mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textDark = theme.colorScheme.onSurface;
    final primaryColor = theme.colorScheme.primary;

    final cardBgColor = isDark ? const Color(0xFF1E1E24) : Colors.white;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: WeddingDoodleBackground(
        forceDisableDoodle: true,
        child: SafeArea(
          child: Column(
            children: [
              // 1. Header Brand Lockup (Logo + Wordmark Nikahin terpusat)
              Padding(
                padding: const EdgeInsets.only(top: 14, bottom: 6),
                child: Image.asset(
                  isDark
                      ? 'assets/logo/png/nikahin-lockup-header-dark.png'
                      : 'assets/logo/png/nikahin-lockup-header-light.png',
                  height: 38,
                  fit: BoxFit.contain,
                ),
              ),

              // 2. Carousel PageView
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _slides.length,
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  itemBuilder: (context, index) {
                    final slide = _slides[index];

                    return Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 450),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final totalHeight = constraints.maxHeight;
                            // Rasio tinggi kartu yang seimbang (~54% layar) agar porsi gambar dan konten selaras
                            final cardHeight = (totalHeight * 0.54).clamp(390.0, 480.0);

                            return Stack(
                              clipBehavior: Clip.none,
                              children: [
                                // A. Lapisan Foto / Gambar (Berada di belakang kartu cekung)
                                if (slide.isCutout)
                                  // Slide 1: Siluet pengantin digeser ke bawah sedikit agar pas dan berjarak nyaman dari logo
                                  Positioned(
                                    top: 14,
                                    left: 16,
                                    right: 16,
                                    bottom: cardHeight - 55,
                                    child: Image.asset(
                                      slide.imageAsset,
                                      fit: BoxFit.contain,
                                      alignment: Alignment.topCenter,
                                    ),
                                  )
                                else
                                  // Slide 2 & 3: Foto memanjang penuh dari atas ke belakang kartu dengan cekungan crop atas
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    right: 0,
                                    bottom: cardHeight - 50,
                                    child: ClipPath(
                                      clipper: const ConcaveTopCardClipper(
                                        dipDepth: 22.0,
                                        cornerRadius: 0.0,
                                        bottomRadius: 0.0,
                                      ),
                                      child: Image.asset(
                                        slide.imageAsset,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        alignment: Alignment.topCenter,
                                      ),
                                    ),
                                  ),

                                // B. Kartu Cekung Putih (Tampil proporsional, ergonomis, dan mengalir alami)
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                                    child: CustomPaint(
                                      painter: ConcaveCardShadowPainter(
                                        dipDepth: 26.0,
                                        cornerRadius: 32.0,
                                        bottomRadius: 30.0,
                                        shadowColor: isDark
                                            ? Colors.black.withValues(alpha: 0.45)
                                            : const Color(0xFF2C1810).withValues(alpha: 0.08),
                                        blurRadius: 20.0,
                                        offset: const Offset(0, 8),
                                      ),
                                      foregroundPainter: ConcaveCardBorderPainter(
                                        dipDepth: 26.0,
                                        cornerRadius: 32.0,
                                        bottomRadius: 30.0,
                                        borderColor: isDark
                                            ? Colors.white.withValues(alpha: 0.08)
                                            : const Color(0xFF2C1810).withValues(alpha: 0.06),
                                        strokeWidth: 1.0,
                                      ),
                                      child: ClipPath(
                                        clipper: const ConcaveTopCardClipper(
                                          dipDepth: 26.0,
                                          cornerRadius: 32.0,
                                          bottomRadius: 30.0,
                                        ),
                                        child: Container(
                                          height: cardHeight,
                                          color: cardBgColor,
                                          padding: const EdgeInsets.fromLTRB(24, 60, 24, 18),
                                          child: Column(
                                            children: [
                                              // 1. Blok Atas: Judul & Deskripsi
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  // Judul Megah Serif Playfair Display
                                                  Text.rich(
                                                    TextSpan(
                                                      style: GoogleFonts.playfairDisplay(
                                                        fontSize: 25,
                                                        fontWeight: FontWeight.w700,
                                                        color: textDark,
                                                        height: 1.25,
                                                      ),
                                                      children: [
                                                        TextSpan(text: slide.titlePrefix),
                                                        TextSpan(
                                                          text: slide.titleAccent,
                                                          style: TextStyle(
                                                            color: primaryColor,
                                                          ),
                                                        ),
                                                        TextSpan(text: slide.titleSuffix),
                                                      ],
                                                    ),
                                                    textAlign: TextAlign.center,
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height: 14),

                                                  // Deskripsi Alami & Hangat
                                                  Text(
                                                    slide.description,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 14.5,
                                                      color: textDark.withValues(alpha: 0.72),
                                                      height: 1.55,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              // 2. Blok Tengah: Animasi Titik Geser (Centered Sempurna di Antara Deskripsi & Tombol)
                                              Expanded(
                                                child: Center(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: List.generate(_slides.length, (dotIndex) {
                                                      final isSelected = _currentPage == dotIndex;
                                                      return AnimatedContainer(
                                                        duration: const Duration(milliseconds: 260),
                                                        margin: const EdgeInsets.symmetric(horizontal: 4),
                                                        width: isSelected ? 26 : 7,
                                                        height: 7,
                                                        decoration: BoxDecoration(
                                                          color: isSelected
                                                              ? primaryColor
                                                              : textDark.withValues(alpha: 0.18),
                                                          borderRadius: BorderRadius.circular(4),
                                                        ),
                                                      );
                                                    }),
                                                  ),
                                                ),
                                              ),

                                              // 3. Blok Bawah: Tombol Utama Lebar Penuh + Aksi Sekunder
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  // Tombol Utama Memanjang Penuh (Thumb-Friendly)
                                                  SizedBox(
                                                    width: double.infinity,
                                                    height: 52,
                                                    child: FilledButton(
                                                      onPressed: _onNext,
                                                      style: FilledButton.styleFrom(
                                                        backgroundColor: primaryColor,
                                                        elevation: 0,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(26),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        _currentPage == _slides.length - 1
                                                            ? 'Mulai Sekarang'
                                                            : 'Lanjutkan',
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.w700,
                                                          fontSize: 15.5,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),

                                                  // Baris Navigasi Sekunder (Kembali & Lewati)
                                                  SizedBox(
                                                    height: 36,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        if (_currentPage > 0)
                                                          TextButton(
                                                            onPressed: _onPrevious,
                                                            style: TextButton.styleFrom(
                                                              padding: const EdgeInsets.symmetric(
                                                                horizontal: 12,
                                                                vertical: 6,
                                                              ),
                                                              minimumSize: Size.zero,
                                                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                            ),
                                                            child: Text(
                                                              'Kembali',
                                                              style: TextStyle(
                                                                fontSize: 13.5,
                                                                fontWeight: FontWeight.w600,
                                                                color: textDark.withValues(alpha: 0.60),
                                                              ),
                                                            ),
                                                          )
                                                        else
                                                          const SizedBox.shrink(),
                                                        if (_currentPage < _slides.length - 1)
                                                          TextButton(
                                                            onPressed: _onSkip,
                                                            style: TextButton.styleFrom(
                                                              padding: const EdgeInsets.symmetric(
                                                                horizontal: 12,
                                                                vertical: 6,
                                                              ),
                                                              minimumSize: Size.zero,
                                                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                            ),
                                                            child: Text(
                                                              'Lewati',
                                                              style: TextStyle(
                                                                fontSize: 13.5,
                                                                fontWeight: FontWeight.w600,
                                                                color: textDark.withValues(alpha: 0.60),
                                                              ),
                                                            ),
                                                          )
                                                        else
                                                          const SizedBox.shrink(),
                                                      ],
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
                              ],
                            );
                          },
                        ),
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
}

class _WelcomeSlideData {
  final String titlePrefix;
  final String titleAccent;
  final String titleSuffix;
  final String description;
  final String imageAsset;
  final bool isCutout;

  const _WelcomeSlideData({
    required this.titlePrefix,
    required this.titleAccent,
    required this.titleSuffix,
    required this.description,
    required this.imageAsset,
    required this.isCutout,
  });
}
