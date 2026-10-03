import 'package:flutter/material.dart';

class StatusChip extends StatelessWidget {
  final String status;
  final String? label;

  const StatusChip({
    super.key,
    required this.status,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getStatusConfig(status, context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: config.borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: config.textColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label ?? config.displayLabel,
            style: TextStyle(
              color: config.textColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  _ChipConfig _getStatusConfig(String status, BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    switch (status.toUpperCase()) {
      // Selesai / Lunas / Hadir / Siap
      case 'FULLY_PAID':
      case 'LUNAS':
        return _ChipConfig(
          displayLabel: 'Lunas',
          textColor: isDark ? const Color(0xFF81C784) : const Color(0xFF2E7D32),
          backgroundColor: isDark ? const Color(0xFF1B3820) : const Color(0xFFE8F5E9),
          borderColor: isDark ? const Color(0xFF2E7D32) : const Color(0xFFA5D6A7),
        );
      case 'ATTENDING':
      case 'HADIR':
        return _ChipConfig(
          displayLabel: 'Hadir',
          textColor: isDark ? const Color(0xFF81C784) : const Color(0xFF2E7D32),
          backgroundColor: isDark ? const Color(0xFF1B3820) : const Color(0xFFE8F5E9),
          borderColor: isDark ? const Color(0xFF2E7D32) : const Color(0xFFA5D6A7),
        );
      case 'SELESAI':
        return _ChipConfig(
          displayLabel: 'Selesai',
          textColor: isDark ? const Color(0xFF81C784) : const Color(0xFF2E7D32),
          backgroundColor: isDark ? const Color(0xFF1B3820) : const Color(0xFFE8F5E9),
          borderColor: isDark ? const Color(0xFF2E7D32) : const Color(0xFFA5D6A7),
        );
      case 'SIAP':
        return _ChipConfig(
          displayLabel: 'Siap',
          textColor: isDark ? const Color(0xFF81C784) : const Color(0xFF2E7D32),
          backgroundColor: isDark ? const Color(0xFF1B3820) : const Color(0xFFE8F5E9),
          borderColor: isDark ? const Color(0xFF2E7D32) : const Color(0xFFA5D6A7),
        );
      case 'SIAP_PAKAI':
        return _ChipConfig(
          displayLabel: 'Siap Pakai',
          textColor: isDark ? const Color(0xFF81C784) : const Color(0xFF2E7D32),
          backgroundColor: isDark ? const Color(0xFF1B3820) : const Color(0xFFE8F5E9),
          borderColor: isDark ? const Color(0xFF2E7D32) : const Color(0xFFA5D6A7),
        );

      // In Progress / Partial / DP / Sedang
      case 'PARTIAL_DP':
      case 'DP':
        return _ChipConfig(
          displayLabel: 'DP / Sebagian',
          textColor: isDark ? const Color(0xFFFFB74D) : const Color(0xFFE65100),
          backgroundColor: isDark ? const Color(0xFF3E2723) : const Color(0xFFFFF3E0),
          borderColor: isDark ? const Color(0xFFE65100) : const Color(0xFFFFCC80),
        );
      case 'TANDA_JADI':
      case 'KONTRAK':
        return _ChipConfig(
          displayLabel: status == 'KONTRAK' ? 'Kontrak' : 'Tanda Jadi',
          textColor: isDark ? const Color(0xFF64B5F6) : const Color(0xFF1565C0),
          backgroundColor: isDark ? const Color(0xFF102A43) : const Color(0xFFE3F2FD),
          borderColor: isDark ? const Color(0xFF1565C0) : const Color(0xFF90CAF9),
        );
      case 'SEDANG_JAHIT':
        return _ChipConfig(
          displayLabel: 'Sedang Jahit',
          textColor: isDark ? const Color(0xFFFFB74D) : const Color(0xFFE65100),
          backgroundColor: isDark ? const Color(0xFF3E2723) : const Color(0xFFFFF3E0),
          borderColor: isDark ? const Color(0xFFE65100) : const Color(0xFFFFCC80),
        );
      case 'WRAPPING':
      case 'DIBELI':
        return _ChipConfig(
          displayLabel: status == 'DIBELI' ? 'Sudah Beli' : 'Sedang Dihias',
          textColor: isDark ? const Color(0xFFBA68C8) : const Color(0xFF6A1B9A),
          backgroundColor: isDark ? const Color(0xFF331440) : const Color(0xFFF3E5F5),
          borderColor: isDark ? const Color(0xFF6A1B9A) : const Color(0xFFCE93D8),
        );
      case 'PENDING':
        return _ChipConfig(
          displayLabel: 'Menunggu',
          textColor: isDark ? const Color(0xFFFFB74D) : const Color(0xFFE65100),
          backgroundColor: isDark ? const Color(0xFF3E2723) : const Color(0xFFFFF3E0),
          borderColor: isDark ? const Color(0xFFE65100) : const Color(0xFFFFCC80),
        );

      // Unpaid / Belum / Decline / Prospek
      case 'DECLINED':
        return _ChipConfig(
          displayLabel: 'Tidak Hadir',
          textColor: isDark ? const Color(0xFFE57373) : const Color(0xFFC62828),
          backgroundColor: isDark ? const Color(0xFF3B1E1E) : const Color(0xFFFFEBEE),
          borderColor: isDark ? const Color(0xFFC62828) : const Color(0xFFFFCDD2),
        );
      case 'UNPAID':
      case 'BELUM_BAYAR':
        return _ChipConfig(
          displayLabel: 'Belum Bayar',
          textColor: isDark ? const Color(0xFFE57373) : const Color(0xFFC62828),
          backgroundColor: isDark ? const Color(0xFF3B1E1E) : const Color(0xFFFFEBEE),
          borderColor: isDark ? const Color(0xFFC62828) : const Color(0xFFFFCDD2),
        );
      case 'BELUM_BELI':
        return _ChipConfig(
          displayLabel: 'Belum Beli',
          textColor: isDark ? const Color(0xFFB0BEC5) : const Color(0xFF455A64),
          backgroundColor: isDark ? const Color(0xFF263238) : const Color(0xFFECEFF1),
          borderColor: isDark ? const Color(0xFF455A64) : const Color(0xFFCFD8DC),
        );
      case 'BELUM_DIBAGI':
        return _ChipConfig(
          displayLabel: 'Belum Dibagi',
          textColor: isDark ? const Color(0xFFB0BEC5) : const Color(0xFF455A64),
          backgroundColor: isDark ? const Color(0xFF263238) : const Color(0xFFECEFF1),
          borderColor: isDark ? const Color(0xFF455A64) : const Color(0xFFCFD8DC),
        );
      case 'PROSPEK':
      default:
        return _ChipConfig(
          displayLabel: status,
          textColor: isDark ? const Color(0xFFB0BEC5) : const Color(0xFF546E7A),
          backgroundColor: isDark ? const Color(0xFF263238) : const Color(0xFFECEFF1),
          borderColor: isDark ? const Color(0xFF455A64) : const Color(0xFFCFD8DC),
        );
    }
  }
}

class _ChipConfig {
  final String displayLabel;
  final Color textColor;
  final Color backgroundColor;
  final Color borderColor;

  const _ChipConfig({
    required this.displayLabel,
    required this.textColor,
    required this.backgroundColor,
    required this.borderColor,
  });
}
