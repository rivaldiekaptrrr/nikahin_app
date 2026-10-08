/// Konfigurasi Pusat Firebase untuk Aplikasi Nikahin
/// 
/// Nilai kredensial dapat diisi langsung pada konstanta di bawah atau
/// di-pass melalui compile-time flag:
/// `--dart-define=FIREBASE_PROJECT_ID=my-project --dart-define=FIREBASE_API_KEY=AIzaSy...`
class FirebaseConfig {
  FirebaseConfig._();

  /// Project ID Firebase
  static const String projectId = String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
    defaultValue: 'nikahin-wedding-app',
  );

  /// Web API Key dari Firebase Console (Project Settings -> General -> Web API Key)
  static const String apiKey = String.fromEnvironment(
    'FIREBASE_API_KEY',
    defaultValue: 'AIzaSyB7Nxopm8-yWXGH3cF_0MEK2K5IL6Nq0Oc',
  );

  /// Status apakah kredensial API Key Firebase telah diisi
  static bool get isConfigured => apiKey.isNotEmpty && projectId.isNotEmpty;

  /// URL Dasar Firestore REST API
  static String get firestoreBaseUrl =>
      'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents';

  /// URL Dasar Firebase Auth REST API
  static String get authBaseUrl =>
      'https://identitytoolkit.googleapis.com/v1';
}
