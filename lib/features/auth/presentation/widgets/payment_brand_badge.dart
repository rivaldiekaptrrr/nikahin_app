import 'package:flutter/material.dart';
import '../../../../domain/models/midtrans_core_models.dart';

/// Komponen Logo Resmi Metode Pembayaran (Clean Editorial Asset — Tanpa Kotak Pembungkus)
/// Logo bernapas bebas murni sebagai aset visual tanpa kontainer artifisial.
class PaymentBrandBadge extends StatelessWidget {
  final PaymentChannel channel;
  final double size;

  const PaymentBrandBadge({
    super.key,
    required this.channel,
    this.size = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    final assetPath = _getAssetPath(channel);

    return SizedBox(
      width: size * 1.1,
      height: size * 0.75,
      child: Image.asset(
        assetPath,
        fit: BoxFit.contain,
        alignment: Alignment.centerLeft,
        errorBuilder: (context, error, stackTrace) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Text(
              channel.id.toUpperCase(),
              style: TextStyle(
                fontSize: size * 0.26,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
          );
        },
      ),
    );
  }

  String _getAssetPath(PaymentChannel channel) {
    switch (channel) {
      case PaymentChannel.bcaVa:
        return 'assets/images/payment/bca.png';
      case PaymentChannel.mandiriBill:
        return 'assets/images/payment/mandiri.png';
      case PaymentChannel.briVa:
        return 'assets/images/payment/bri.png';
      case PaymentChannel.bniVa:
        return 'assets/images/payment/bni.png';
      case PaymentChannel.cimbVa:
        return 'assets/images/payment/cimb.png';
      case PaymentChannel.permataVa:
        return 'assets/images/payment/permata.png';
      case PaymentChannel.bsiVa:
        return 'assets/images/payment/bsi.png';
      case PaymentChannel.gopay:
        return 'assets/images/payment/gopay.png';
      case PaymentChannel.shopeepay:
        return 'assets/images/payment/shopeepay.png';
      case PaymentChannel.qris:
        return 'assets/images/payment/qris.png';
    }
  }
}
