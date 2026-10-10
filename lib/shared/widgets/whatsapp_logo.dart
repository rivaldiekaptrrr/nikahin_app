import 'package:flutter/material.dart';

/// Vector WhatsApp Logo Widget
/// Can be rendered as a single-color icon (e.g. white inside colored button)
/// or with official WhatsApp brand colors (green circle + white phone).
class WhatsAppLogo extends StatelessWidget {
  final double size;
  final Color? color;

  const WhatsAppLogo({
    super.key,
    this.size = 22.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _WhatsAppLogoPainter(
          color: color ?? Colors.white,
        ),
      ),
    );
  }
}

class _WhatsAppLogoPainter extends CustomPainter {
  final Color color;

  const _WhatsAppLogoPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24.0;
    canvas.save();
    canvas.scale(scale, scale);

    final paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..color = color;

    // Standard 24x24 WhatsApp Vector Icon
    // 1. Speech bubble outline with pointer tail
    final bubblePath = Path()
      ..moveTo(0.06, 24.0)
      ..lineTo(1.75, 17.84)
      ..cubicTo(0.71, 16.03, 0.16, 13.99, 0.16, 11.89)
      ..cubicTo(0.16, 5.33, 5.5, 0.0, 12.05, 0.0)
      ..cubicTo(15.23, 0.0, 18.22, 1.24, 20.47, 3.49)
      ..cubicTo(22.71, 5.74, 23.95, 8.73, 23.95, 11.89)
      ..cubicTo(23.95, 18.45, 18.61, 23.78, 12.05, 23.78)
      ..cubicTo(10.06, 23.78, 8.1, 23.28, 6.36, 22.33)
      ..lineTo(0.06, 24.0)
      ..close();

    // 2. Inner bubble cutout (to create the bubble border thickness)
    final innerCutout = Path()
      ..moveTo(6.65, 20.19)
      ..cubicTo(8.33, 21.19, 9.93, 21.78, 12.05, 21.78)
      ..cubicTo(17.5, 21.78, 21.94, 17.35, 21.94, 11.89)
      ..cubicTo(21.94, 6.43, 17.52, 2.0, 12.05, 2.0)
      ..cubicTo(6.6, 2.0, 2.16, 6.43, 2.16, 11.89)
      ..cubicTo(2.16, 14.11, 2.81, 15.78, 3.91, 17.52)
      ..lineTo(2.91, 21.17)
      ..lineTo(6.65, 20.19)
      ..close();

    final outerBubble = Path.combine(
      PathOperation.difference,
      bubblePath,
      innerCutout,
    );
    canvas.drawPath(outerBubble, paint);

    // 3. Handset telephone icon inside
    final handsetPath = Path()
      ..moveTo(18.04, 14.73)
      ..cubicTo(17.97, 14.6, 17.77, 14.53, 17.47, 14.38)
      ..cubicTo(17.17, 14.23, 15.71, 13.51, 15.44, 13.41)
      ..cubicTo(15.17, 13.31, 14.97, 13.26, 14.77, 13.56)
      ..cubicTo(14.57, 13.86, 14.0, 14.53, 13.83, 14.73)
      ..cubicTo(13.66, 14.93, 13.48, 14.95, 13.19, 14.8)
      ..cubicTo(12.89, 14.65, 11.93, 14.34, 10.8, 13.33)
      ..cubicTo(9.92, 12.54, 9.32, 11.57, 9.15, 11.27)
      ..cubicTo(8.98, 10.97, 9.13, 10.81, 9.28, 10.66)
      ..cubicTo(9.41, 10.53, 9.58, 10.32, 9.73, 10.14)
      ..cubicTo(9.88, 9.97, 9.93, 9.85, 10.03, 9.65)
      ..cubicTo(10.13, 9.45, 10.08, 9.28, 10.0, 9.13)
      ..cubicTo(9.93, 8.98, 9.33, 7.52, 9.09, 6.92)
      ..cubicTo(8.84, 6.34, 8.6, 6.42, 8.42, 6.41)
      ..lineTo(7.85, 6.4)
      ..cubicTo(7.65, 6.4, 7.33, 6.47, 7.06, 6.77)
      ..cubicTo(6.79, 7.07, 6.02, 7.79, 6.02, 9.25)
      ..cubicTo(6.02, 10.71, 7.09, 12.13, 7.23, 12.32)
      ..cubicTo(7.38, 12.52, 9.33, 15.52, 12.31, 16.81)
      ..cubicTo(13.02, 17.12, 13.57, 17.3, 14.0, 17.44)
      ..cubicTo(14.71, 17.67, 15.36, 17.63, 15.87, 17.56)
      ..cubicTo(16.44, 17.47, 17.63, 16.84, 17.88, 16.14)
      ..cubicTo(18.13, 15.45, 18.13, 14.85, 18.04, 14.73)
      ..close();

    canvas.drawPath(handsetPath, paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _WhatsAppLogoPainter oldDelegate) =>
      oldDelegate.color != color;
}
