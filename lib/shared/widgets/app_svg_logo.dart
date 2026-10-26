import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum NikahinLogoVariant {
  master,
  black,
  white,
  horizontalLockup,
  stackedLockup,
  appIconBg,
}

/// Reusable vector SVG brand asset renderer for Nikahin App.
/// Provides infinite resolution scaling without raster pixelation.
class NikahinSvgLogo extends StatelessWidget {
  final NikahinLogoVariant variant;
  final double? width;
  final double? height;
  final BoxFit fit;
  final ColorFilter? colorFilter;

  const NikahinSvgLogo({
    super.key,
    this.variant = NikahinLogoVariant.master,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.colorFilter,
  });

  const NikahinSvgLogo.master({
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.colorFilter,
  }) : variant = NikahinLogoVariant.master;

  const NikahinSvgLogo.horizontal({
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.colorFilter,
  }) : variant = NikahinLogoVariant.horizontalLockup;

  const NikahinSvgLogo.stacked({
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.colorFilter,
  }) : variant = NikahinLogoVariant.stackedLockup;

  String get _assetPath {
    switch (variant) {
      case NikahinLogoVariant.master:
        return 'assets/logo/svg/nikahin-symbol-master.svg';
      case NikahinLogoVariant.black:
        return 'assets/logo/svg/nikahin-symbol-black.svg';
      case NikahinLogoVariant.white:
        return 'assets/logo/svg/nikahin-symbol-white.svg';
      case NikahinLogoVariant.horizontalLockup:
        return 'assets/logo/svg/nikahin-lockup-horizontal-dark.svg';
      case NikahinLogoVariant.stackedLockup:
        return 'assets/logo/svg/nikahin-lockup-stacked-dark.svg';
      case NikahinLogoVariant.appIconBg:
        return 'assets/logo/svg/nikahin-app-icon-bg.svg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _assetPath,
      width: width,
      height: height,
      fit: fit,
      colorFilter: colorFilter,
      placeholderBuilder: (context) => SizedBox(
        width: width ?? 48,
        height: height ?? 48,
        child: const Center(
          child: SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
    );
  }
}
