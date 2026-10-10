import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../app/config/business_config.dart';
import '../../../data/local/mock_seeder.dart';
import '../../../data/local/preferences_manager.dart';
import '../../../data/remote/midtrans_payment_service.dart';
import '../../../data/repositories/wedding_repository.dart';
import '../../../domain/models/access_level.dart';
import '../../../domain/models/midtrans_core_models.dart';
import 'auth_state.dart';

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    // Asynchronously initialize state
    Future.microtask(() => init());
    return const AuthState(status: AuthStatus.initial);
  }

  Future<void> init() async {
    final email = await AppPreferences.getUserEmail();
    final isDemo = await AppPreferences.isDemoMode();
    final userId = await AppPreferences.getUserId();
    final cachedAccess = await AppPreferences.getAccessLevel();

    if (email != null && email.isNotEmpty) {
      final uid = userId ?? 'user_${email.hashCode.abs()}';
      final isAdmin = email.toLowerCase() == BusinessConfig.adminEmail.toLowerCase();
      var level = isAdmin ? AccessLevel.admin : AccessLevel.fromCode(cachedAccess);

      // Verify and refresh latest accessLevel from Firestore
      try {
        final firestoreService = ref.read(firestoreServiceProvider);
        final remoteUser = await firestoreService.getUserInfo(uid);
        if (remoteUser != null) {
          level = isAdmin ? AccessLevel.admin : remoteUser.accessLevel;
          await AppPreferences.setAccessLevel(level.code);
        }
      } catch (_) {}

      ref.read(syncManagerProvider).configure(
            newUserId: uid,
            enabled: level.isPremium,
          );

      state = AuthState(
        status: AuthStatus.authenticated,
        userId: uid,
        email: email,
        displayName: email.split('@').first,
        accessLevel: level,
      );

      // Background pull if premium
      if (level.isPremium) {
        ref.read(syncManagerProvider).pullAll();
      }
    } else if (isDemo) {
      ref.read(syncManagerProvider).configure(
            newUserId: null,
            enabled: false,
          );
      state = const AuthState(
        status: AuthStatus.demoMode,
        displayName: 'Tamu (Demo)',
        accessLevel: AccessLevel.none,
      );
    } else {
      ref.read(syncManagerProvider).configure(
            newUserId: null,
            enabled: false,
          );
      state = const AuthState(
        status: AuthStatus.unauthenticated,
        accessLevel: AccessLevel.none,
      );
    }
  }

  Future<bool> enterDemoMode() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await AppPreferences.setDemoMode(true);
      await AppPreferences.setUserEmail(null);
      await AppPreferences.setUserId(null);
      await AppPreferences.setAccessLevel('NONE');
      await AppPreferences.setHasSkippedLogin(true);
      await AppPreferences.setActiveProfileId(MockSeeder.primaryMockProfileId);

      final db = ref.read(databaseProvider);
      final existingMockProfile = await db.getProfileById(MockSeeder.primaryMockProfileId);
      if (existingMockProfile == null) {
        await MockSeeder.seedAllMockData(db);
      }

      ref.read(syncManagerProvider).configure(
            newUserId: null,
            enabled: false,
          );

      state = const AuthState(
        status: AuthStatus.demoMode,
        displayName: 'Tamu (Demo)',
        accessLevel: AccessLevel.none,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final firestoreService = ref.read(firestoreServiceProvider);
      final res = await firestoreService.signInWithEmail(
        email: email,
        password: password,
      );

      if (res != null && !res.isSuccess) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: res.errorMessage,
        );
        return false;
      }

      final uid = res?.localId ?? 'user_${email.hashCode.abs()}';
      final isAdmin = email.toLowerCase() == BusinessConfig.adminEmail.toLowerCase();
      var level = isAdmin ? AccessLevel.admin : AccessLevel.none;

      // Check remote Firestore user document
      try {
        final remoteUser = await firestoreService.getUserInfo(uid, idToken: res?.idToken);
        if (remoteUser != null) {
          level = isAdmin ? AccessLevel.admin : remoteUser.accessLevel;
        } else {
          // Register new user doc in Firestore
          await firestoreService.syncUserInfo(
            AppUserInfo(
              uid: uid,
              email: email,
              displayName: email.split('@').first,
              accessLevel: level,
              createdAt: DateTime.now().millisecondsSinceEpoch,
              updatedAt: DateTime.now().millisecondsSinceEpoch,
            ),
            idToken: res?.idToken,
          );
        }
      } catch (_) {}

      await AppPreferences.setUserEmail(email);
      await AppPreferences.setUserId(uid);
      await AppPreferences.setAccessLevel(level.code);
      await AppPreferences.setIdToken(res?.idToken);
      await AppPreferences.setDemoMode(false);
      await AppPreferences.setHasSkippedLogin(false);

      ref.read(userEmailProvider.notifier).state = email;
      ref.read(syncManagerProvider).configure(
            newUserId: uid,
            newIdToken: res?.idToken,
            enabled: level.isPremium,
          );

      state = AuthState(
        status: AuthStatus.authenticated,
        userId: uid,
        email: email,
        displayName: email.split('@').first,
        accessLevel: level,
      );

      if (level.isPremium) {
        ref.read(syncManagerProvider).pullAll();
      }
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final firestoreService = ref.read(firestoreServiceProvider);
      var res = await firestoreService.signUpWithEmail(
        email: email,
        password: password,
      );

      // Jika email sudah pernah terdaftar di Firebase Auth (misal: profil Firestore sebelumnya dihapus oleh Super Admin):
      if (res != null && !res.isSuccess && (res.errorMessage?.contains('sudah terdaftar') ?? false)) {
        // Coba login otomatis dengan kata sandi yang diinput pengguna
        final loginRes = await firestoreService.signInWithEmail(
          email: email,
          password: password,
        );
        if (loginRes != null && loginRes.isSuccess) {
          res = loginRes; // Autentikasi valid, lanjutkan sinkronisasi ulang ke Firestore
        } else {
          // Kata sandi tidak cocok dengan akun terdaftar di Auth
          state = state.copyWith(
            isLoading: false,
            errorMessage: 'Email ini sudah terdaftar. Kata sandi tidak cocok, atau silakan gunakan tab "Masuk".',
          );
          return false;
        }
      }

      if (res != null && !res.isSuccess) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: res.errorMessage,
        );
        return false;
      }

      final uid = res?.localId ?? 'user_${email.hashCode.abs()}';
      final isAdmin = email.toLowerCase() == BusinessConfig.adminEmail.toLowerCase();
      var level = isAdmin ? AccessLevel.admin : AccessLevel.none;

      // Cek apakah dokumen user sudah ada di Firestore atau perlu didaftarkan ulang sebagai akun baru
      try {
        final remoteUser = await firestoreService.getUserInfo(uid, idToken: res?.idToken);
        if (remoteUser != null) {
          level = isAdmin ? AccessLevel.admin : remoteUser.accessLevel;
        } else {
          // Dokumen tidak ada (karena baru atau baru saja dihapus oleh admin) -> Buat profil baru
          await firestoreService.syncUserInfo(
            AppUserInfo(
              uid: uid,
              email: email,
              displayName: email.split('@').first,
              accessLevel: level,
              createdAt: DateTime.now().millisecondsSinceEpoch,
              updatedAt: DateTime.now().millisecondsSinceEpoch,
            ),
            idToken: res?.idToken,
          );
        }
      } catch (_) {}

      await AppPreferences.setUserEmail(email);
      await AppPreferences.setUserId(uid);
      await AppPreferences.setAccessLevel(level.code);
      await AppPreferences.setIdToken(res?.idToken);
      await AppPreferences.setDemoMode(false);
      await AppPreferences.setHasSkippedLogin(false);

      ref.read(userEmailProvider.notifier).state = email;
      ref.read(syncManagerProvider).configure(
            newUserId: uid,
            newIdToken: res?.idToken,
            enabled: level.isPremium,
          );

      state = AuthState(
        status: AuthStatus.authenticated,
        userId: uid,
        email: email,
        displayName: email.split('@').first,
        accessLevel: level,
      );

      if (level.isPremium) {
        ref.read(syncManagerProvider).pullAll();
      }
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  /// Kirim link pemulihan kata sandi resmi via Firebase Auth REST
  /// Mengembalikan null jika sukses terkirim, atau pesan error jika gagal.
  Future<String?> sendPasswordResetEmail(String email) async {
    try {
      final firestoreService = ref.read(firestoreServiceProvider);
      return await firestoreService.sendPasswordResetEmail(email: email.trim());
    } catch (e) {
      return 'Gagal mengirim email reset kata sandi: $e';
    }
  }

  Future<bool> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
      // Selalu signOut dari sesi cache lokal agar sistem selalu memunculkan native Google Account Picker
      try {
        await googleSignIn.signOut();
      } catch (_) {}

      final GoogleSignInAccount? account = await googleSignIn.signIn();
      if (account == null) {
        // Pengguna membatalkan pemilihan akun di dialog bawaan sistem
        state = state.copyWith(isLoading: false);
        return false;
      }

      final email = account.email.trim().toLowerCase();
      final displayName = account.displayName ?? email.split('@').first;
      final isAdmin = email == BusinessConfig.adminEmail.toLowerCase();
      var level = isAdmin ? AccessLevel.admin : AccessLevel.none;

      final googleAuth = await account.authentication;
      final googleIdToken = googleAuth.idToken ?? '';
      final firestoreService = ref.read(firestoreServiceProvider);

      String? firebaseIdToken;
      String uid = 'google_user_${account.id.isNotEmpty ? account.id : email.hashCode.abs()}';

      // Tukar Google ID Token dengan Firebase Auth ID Token jika tersedia
      if (googleIdToken.isNotEmpty) {
        final firebaseAuthRes = await firestoreService.signInWithGoogleIdToken(
          googleIdToken: googleIdToken,
        );
        if (firebaseAuthRes != null && firebaseAuthRes.isSuccess) {
          firebaseIdToken = firebaseAuthRes.idToken;
          if (firebaseAuthRes.localId.isNotEmpty) {
            uid = firebaseAuthRes.localId;
          }
        }
      }

      firebaseIdToken ??= (googleIdToken.isNotEmpty ? googleIdToken : null);
      await AppPreferences.setIdToken(firebaseIdToken);

      // Cek apakah akun ini sudah ada di Firestore atau daftarkan doc user baru
      try {
        final remoteUser = await firestoreService.getUserInfo(uid, idToken: firebaseIdToken);
        if (remoteUser != null) {
          level = isAdmin ? AccessLevel.admin : remoteUser.accessLevel;
        } else {
          await firestoreService.syncUserInfo(
            AppUserInfo(
              uid: uid,
              email: email,
              displayName: displayName,
              accessLevel: level,
              createdAt: DateTime.now().millisecondsSinceEpoch,
              updatedAt: DateTime.now().millisecondsSinceEpoch,
            ),
            idToken: firebaseIdToken,
          );
        }
      } catch (_) {}

      await AppPreferences.setUserEmail(email);
      await AppPreferences.setUserId(uid);
      await AppPreferences.setAccessLevel(level.code);
      await AppPreferences.setDemoMode(false);
      await AppPreferences.setHasSkippedLogin(false);

      ref.read(userEmailProvider.notifier).state = email;
      ref.read(syncManagerProvider).configure(
            newUserId: uid,
            newIdToken: firebaseIdToken,
            enabled: level.isPremium,
          );

      state = AuthState(
        status: AuthStatus.authenticated,
        userId: uid,
        email: email,
        displayName: displayName,
        accessLevel: level,
      );

      if (level.isPremium) {
        ref.read(syncManagerProvider).pullAll();
      }
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  /// Cek status lisensi terkini dari Cloud Firestore (Tombol 'Cek Status Akses')
  Future<AccessLevel> checkAccessStatus() async {
    final uid = state.userId;
    final email = state.email;
    if (uid == null || email == null) return AccessLevel.none;

    final isAdmin = email.toLowerCase() == BusinessConfig.adminEmail.toLowerCase();
    if (isAdmin) {
      state = state.copyWith(accessLevel: AccessLevel.admin);
      await AppPreferences.setAccessLevel('ADMIN');
      return AccessLevel.admin;
    }

    try {
      final firestoreService = ref.read(firestoreServiceProvider);
      // Gunakan idToken yang tersimpan agar Firestore Security Rules tidak menolak
      final savedToken = await AppPreferences.getIdToken();
      final userDoc = await firestoreService.getUserInfo(uid, idToken: savedToken);
      if (userDoc != null) {
        final level = userDoc.accessLevel;
        await AppPreferences.setAccessLevel(level.code);
        state = state.copyWith(accessLevel: level);

        ref.read(syncManagerProvider).configure(
              newUserId: uid,
              enabled: level.isPremium,
            );

        if (level.isPremium) {
          ref.read(syncManagerProvider).pullAll();
        }
        return level;
      }
    } catch (_) {}

    return state.accessLevel;
  }

  /// Meminta Midtrans Snap Token & Checkout URL ke Backend Vercel
  Future<MidtransPaymentResult> createMidtransPayment({
    String accessLevel = BusinessConfig.midtransPackageCode,
  }) async {
    final uid = state.userId;
    final email = state.email;
    if (uid == null || email == null) {
      return const MidtransPaymentResult.error(
        message: 'Sesi login tidak ditemukan. Silakan login kembali.',
      );
    }

    final paymentService = ref.read(midtransPaymentServiceProvider);
    return await paymentService.createSnapTransaction(
      userId: uid,
      email: email,
      accessLevel: accessLevel,
    );
  }

  /// Memproses Direct Charge Midtrans Core API (100% Native Custom UI)
  Future<MidtransCoreChargeResult> chargeMidtransCoreApi({
    required PaymentChannel channel,
    double amount = BusinessConfig.lifetimePrice,
  }) async {
    final uid = state.userId;
    final email = state.email;
    final name = state.displayName ?? 'Pengguna Nikahin';
    if (uid == null || email == null) {
      return const MidtransCoreChargeResult.error(
        message: 'Sesi login tidak ditemukan. Silakan login kembali.',
      );
    }

    final paymentService = ref.read(midtransPaymentServiceProvider);
    return await paymentService.chargeCoreApi(
      channel: channel,
      userId: uid,
      email: email,
      customerName: name,
      amount: amount,
    );
  }

  /// Cek dan sinkronkan status hak akses lisensi terbaru dari Firestore
  Future<AccessLevel> refreshAccessLevel() async {
    final uid = state.userId;
    if (uid == null) return state.accessLevel;

    try {
      final firestoreService = ref.read(firestoreServiceProvider);
      final remoteUser = await firestoreService.getUserInfo(uid);
      if (remoteUser != null) {
        final level = state.isAdmin ? AccessLevel.admin : remoteUser.accessLevel;
        await AppPreferences.setAccessLevel(level.code);
        state = state.copyWith(accessLevel: level);

        ref.read(syncManagerProvider).configure(
              newUserId: uid,
              enabled: level.isPremium,
            );
        if (level.isPremium) {
          ref.read(syncManagerProvider).pullAll();
        }
        return level;
      }
    } catch (_) {}

    return state.accessLevel;
  }
  /// Update hak akses lisensi user lain (Fitur Super Admin)
  Future<bool> updateTargetUserAccess(String targetUserId, AccessLevel newLevel) async {
    if (!state.isAdmin) return false;
    try {
      final firestoreService = ref.read(firestoreServiceProvider);
      final idToken = await AppPreferences.getIdToken();
      return await firestoreService.updateUserAccessLevel(targetUserId, newLevel, idToken: idToken);
    } catch (_) {
      return false;
    }
  }

  /// Ambil seluruh user terdaftar (Fitur Super Admin)
  Future<List<AppUserInfo>> fetchAllUsers() async {
    if (!state.isAdmin) return [];
    try {
      final firestoreService = ref.read(firestoreServiceProvider);
      final idToken = await AppPreferences.getIdToken();
      return await firestoreService.getAllAppUsers(idToken: idToken);
    } catch (_) {
      return [];
    }
  }

  /// Hapus akun pengguna dari Firestore (Fitur Super Admin)
  Future<bool> deleteTargetUser(String targetUserId) async {
    if (!state.isAdmin) return false;
    try {
      final firestoreService = ref.read(firestoreServiceProvider);
      final idToken = await AppPreferences.getIdToken();
      return await firestoreService.deleteUser(targetUserId, idToken: idToken);
    } catch (_) {
      return false;
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);
    try {
      final googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
    } catch (_) {}

    await AppPreferences.setUserEmail(null);
    await AppPreferences.setUserId(null);
    await AppPreferences.setAccessLevel('NONE');
    await AppPreferences.setIdToken(null);
    await AppPreferences.setDemoMode(false);
    await AppPreferences.setActiveProfileId('');
    ref.read(activeProfileIdProvider.notifier).state = '';
    ref.read(userEmailProvider.notifier).state = null;
    ref.read(syncManagerProvider).configure(
          newUserId: null,
          newIdToken: null,
          enabled: false,
        );

    state = const AuthState(
      status: AuthStatus.unauthenticated,
      accessLevel: AccessLevel.none,
    );
  }
}

final authNotifierProvider =
    NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

final isDemoModeProvider = Provider<bool>((ref) {
  return ref.watch(authNotifierProvider.select((s) => s.isDemoMode));
});

final userAccessLevelProvider = Provider<AccessLevel>((ref) {
  return ref.watch(authNotifierProvider.select((s) => s.accessLevel));
});
