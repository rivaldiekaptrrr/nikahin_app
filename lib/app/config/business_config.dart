
/// Konfigurasi Bisnis, Monetisasi, & Lisensi Aplikasi Nikahin
class BusinessConfig {
  BusinessConfig._();

  /// Email Akun Super Admin
  static const String adminEmail = 'rivaldiekaputr@gmail.com';

  /// Toggle Mode Pembayaran Manual (QRIS Statis & Konfirmasi WhatsApp)
  /// Nilai `true` mengaktifkan mode manual (QRIS statis + kirim bukti via WhatsApp + aktivasi Admin Panel).
  /// Nilai `false` mengaktifkan mode direct payment otomatis Midtrans Core API.
  static const bool useManualPaymentMode = true;

  /// Nomor WhatsApp Admin Utama (Format Internasional tanpa +)
  static const String adminWhatsAppNumber = '6287834284141';

  /// Nomor WhatsApp Khusus Konfirmasi Pembayaran Manual (+6287834284141)
  static const String manualPaymentWhatsAppNumber = '6287834284141';

  /// Lokasi Asset Gambar QRIS Statis untuk Mode Manual
  static const String manualQrisAssetPath = 'assets/images/qris.jpeg';

  /// Backend URL Midtrans Snap Token Generator (Vercel Serverless Function)
  static const String midtransBackendUrl = String.fromEnvironment(
    'MIDTRANS_BACKEND_URL',
    defaultValue: 'https://track-it-backend-sand.vercel.app/api/create-snap-token',
  );

  /// Backend URL Midtrans Core API Charge (Vercel Serverless Function)
  static const String midtransCoreChargeBackendUrl = String.fromEnvironment(
    'MIDTRANS_CORE_CHARGE_BACKEND_URL',
    defaultValue: 'https://track-it-backend-sand.vercel.app/api/charge-core-api',
  );

  /// Status Lingkungan Midtrans (false = Sandbox, true = Production)
  static const bool isProduction = bool.fromEnvironment('MIDTRANS_IS_PRODUCTION', defaultValue: false);

  /// Server Key Midtrans Sandbox (Testing)
  static const String midtransSandboxServerKey = String.fromEnvironment(
    'MIDTRANS_SANDBOX_SERVER_KEY',
    defaultValue: 'SB-Mid-server-PLACEHOLDER',
  );

  /// Server Key Midtrans Production (Live)
  static const String midtransProductionServerKey = String.fromEnvironment(
    'MIDTRANS_PRODUCTION_SERVER_KEY',
    defaultValue: 'Mid-server-PLACEHOLDER',
  );

  /// Server Key aktif berdasarkan lingkungan
  static String get midtransServerKey => isProduction ? midtransProductionServerKey : midtransSandboxServerKey;

  /// Kode Paket Lisensi Midtrans
  static const String midtransPackageCode = 'WEDDING';

  /// Informasi Harga Paket Lisensi
  static const double lifetimePrice = 49000.0;
  static const double originalPrice = 99000.0;
  static const String packageName = 'Paket Wedding Planner Seumur Hidup (Lifetime)';

  /// Generator URL WhatsApp untuk Konfirmasi Pembeli
  static Uri getWhatsAppConfirmationUri({
    required String userEmail,
  }) {
    final targetNumber = useManualPaymentMode ? manualPaymentWhatsAppNumber : adminWhatsAppNumber;
    final message = '''
Halo Tim Nikahin, saya sudah melakukan pembayaran lisensi via QRIS (Rp 49.000):

Email Terdaftar: $userEmail

Berikut saya lampirkan bukti pembayaran QRIS. Mohon untuk diverifikasi dan diaktifkan akses akun saya. Terima kasih!
'''
        .trim();

    return Uri.parse(
      'https://wa.me/$targetNumber?text=${Uri.encodeComponent(message)}',
    );
  }

  /// Generator URL WhatsApp Umum
  static Uri getWhatsAppGeneralUri(String message) {
    return Uri.parse(
      'https://wa.me/$adminWhatsAppNumber?text=${Uri.encodeComponent(message)}',
    );
  }
}
