import 'package:flutter/material.dart';

/// Modern 4-Color Vector Google 'G' Logo
class GoogleLogo extends StatelessWidget {
  final double size;

  const GoogleLogo({super.key, this.size = 22.0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _GoogleLogoPainter(),
      ),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24.0;
    canvas.save();
    canvas.scale(scale, scale);

    final paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;

    // 1. Google Blue (#4285F4)
    paint.color = const Color(0xFF4285F4);
    final bluePath = Path()
      ..moveTo(23.49, 12.28)
      ..cubicTo(23.49, 11.48, 23.42, 10.71, 23.3, 9.96)
      ..lineTo(12.0, 9.96)
      ..lineTo(12.0, 14.58)
      ..lineTo(18.45, 14.58)
      ..cubicTo(18.17, 16.08, 17.32, 17.35, 16.05, 18.2)
      ..lineTo(16.05, 21.24)
      ..lineTo(19.94, 21.24)
      ..cubicTo(22.21, 19.14, 23.49, 16.05, 23.49, 12.28)
      ..close();
    canvas.drawPath(bluePath, paint);

    // 2. Google Green (#34A853)
    paint.color = const Color(0xFF34A853);
    final greenPath = Path()
      ..moveTo(12.0, 24.0)
      ..cubicTo(15.24, 24.0, 17.96, 22.92, 19.94, 21.24)
      ..lineTo(16.05, 18.2)
      ..cubicTo(14.97, 18.93, 13.59, 19.38, 12.0, 19.38)
      ..cubicTo(8.87, 19.38, 6.22, 17.26, 5.27, 14.41)
      ..lineTo(1.25, 14.41)
      ..lineTo(1.25, 17.52)
      ..cubicTo(3.23, 21.46, 7.3, 24.0, 12.0, 24.0)
      ..close();
    canvas.drawPath(greenPath, paint);

    // 3. Google Yellow (#FBBC05)
    paint.color = const Color(0xFFFBBC05);
    final yellowPath = Path()
      ..moveTo(5.27, 14.41)
      ..cubicTo(5.03, 13.68, 4.89, 12.9, 4.89, 12.09)
      ..cubicTo(4.89, 11.28, 5.03, 10.5, 5.27, 9.77)
      ..lineTo(5.27, 6.66)
      ..lineTo(1.25, 6.66)
      ..cubicTo(0.45, 8.24, 0.0, 10.06, 0.0, 12.09)
      ..cubicTo(0.0, 14.12, 0.45, 15.94, 1.25, 17.52)
      ..lineTo(5.27, 14.41)
      ..close();
    canvas.drawPath(yellowPath, paint);

    // 4. Google Red (#EA4335)
    paint.color = const Color(0xFFEA4335);
    final redPath = Path()
      ..moveTo(12.0, 4.75)
      ..cubicTo(13.77, 4.75, 15.35, 5.36, 16.6, 6.55)
      ..lineTo(20.03, 3.12)
      ..cubicTo(17.95, 1.19, 15.23, 0.0, 12.0, 0.0)
      ..cubicTo(7.3, 0.0, 3.23, 2.54, 1.25, 6.66)
      ..lineTo(5.27, 9.77)
      ..cubicTo(6.22, 6.92, 8.87, 4.75, 12.0, 4.75)
      ..close();
    canvas.drawPath(redPath, paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
