import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Service to monitor network connectivity status across Wi-Fi, Cellular, and Ethernet.
/// Powers the Online-First Cloud-Synced synchronization trigger and offline awareness.
class NetworkConnectivityService {
  final Connectivity _connectivity;

  NetworkConnectivityService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  /// Stream emitting boolean [true] when online, [false] when disconnected.
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map((results) {
      return results.any((r) => r != ConnectivityResult.none);
    }).distinct();
  }

  /// Instant check for current connectivity status.
  Future<bool> checkIsOnline() async {
    try {
      final results = await _connectivity.checkConnectivity();
      return results.any((r) => r != ConnectivityResult.none);
    } catch (_) {
      return false;
    }
  }
}

/// Provider for NetworkConnectivityService instance
final networkConnectivityServiceProvider = Provider<NetworkConnectivityService>((ref) {
  return NetworkConnectivityService();
});

/// StreamProvider listening to online/offline state changes
final isOnlineStreamProvider = StreamProvider<bool>((ref) {
  final service = ref.watch(networkConnectivityServiceProvider);
  return service.onConnectivityChanged;
});
