import 'package:flutter/material.dart';

/// Helper to generate the concave card path with rounded corners
/// and an organic, smooth downward dip at the top edge.
Path getConcaveCardPath(
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

  final halfW = w / 2;
  final span = halfW - cr;

  // 1. Mulai dari sisi kiri tepat di bawah sudut kiri atas
  path.moveTo(0, cr);
  // Sudut cembung kiri atas (berakhir mendatar horizontal di cr, 0)
  path.quadraticBezierTo(0, 0, cr, 0);

  // 2. Lengkungan cekung di bagian atas (C1 continuous, transisi mulus alami tanpa sudut lancip)
  // Paruh kiri: mulai meluncur lembut dari (cr, 0) langsung ke lembah tengah (halfW, dipDepth)
  path.cubicTo(
    cr + span * 0.12, 0,
    halfW - span * 0.55, dipDepth,
    halfW, dipDepth,
  );

  // Paruh kanan: dari lembah tengah (halfW, dipDepth) meluncur kembali ke bahu kanan (w - cr, 0)
  path.cubicTo(
    halfW + span * 0.55, dipDepth,
    w - cr - span * 0.12, 0,
    w - cr, 0,
  );

  // 3. Sudut cembung kanan atas (dimulai mendatar horizontal dari w - cr, 0)
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
    this.dipDepth = 26.0,
    this.cornerRadius = 32.0,
    this.bottomRadius = 30.0,
  });

  @override
  Path getClip(Size size) {
    return getConcaveCardPath(size, dipDepth, cornerRadius, bottomRadius);
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
    this.dipDepth = 26.0,
    this.cornerRadius = 32.0,
    this.bottomRadius = 30.0,
    required this.shadowColor,
    this.blurRadius = 18.0,
    this.offset = const Offset(0, 8),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = getConcaveCardPath(size, dipDepth, cornerRadius, bottomRadius);
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
    this.dipDepth = 26.0,
    this.cornerRadius = 32.0,
    this.bottomRadius = 30.0,
    required this.borderColor,
    this.strokeWidth = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = getConcaveCardPath(size, dipDepth, cornerRadius, bottomRadius);
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
