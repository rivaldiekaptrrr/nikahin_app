import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Service to collect device and platform diagnostics for technical support.
class DeviceInfoService {
  final DeviceInfoPlugin _deviceInfoPlugin;

  DeviceInfoService({DeviceInfoPlugin? deviceInfoPlugin})
      : _deviceInfoPlugin = deviceInfoPlugin ?? DeviceInfoPlugin();

  /// Returns a clean, human-readable diagnostics block for technical support messages.
  Future<String> getDiagnosticsPayload() async {
    String deviceModel = 'Tidak diketahui';
    String osVersion = 'Tidak diketahui';
    String appVersion = 'Tidak diketahui';

    try {
      final pkg = await PackageInfo.fromPlatform();
      appVersion = '${pkg.version} (Build ${pkg.buildNumber})';
    } catch (_) {}

    try {
      if (Platform.isAndroid) {
        final android = await _deviceInfoPlugin.androidInfo;
        deviceModel = '${android.brand.toUpperCase()} ${android.model}';
        osVersion = 'Android ${android.version.release} (API ${android.version.sdkInt})';
      } else if (Platform.isIOS) {
        final ios = await _deviceInfoPlugin.iosInfo;
        deviceModel = ios.utsname.machine;
        osVersion = '${ios.systemName} ${ios.systemVersion}';
      } else if (Platform.isWindows) {
        final win = await _deviceInfoPlugin.windowsInfo;
        deviceModel = 'PC (${win.computerName})';
        osVersion = win.productName;
      } else if (Platform.isMacOS) {
        final mac = await _deviceInfoPlugin.macOsInfo;
        deviceModel = mac.model;
        osVersion = 'macOS ${mac.osRelease}';
      } else if (Platform.isLinux) {
        final linux = await _deviceInfoPlugin.linuxInfo;
        deviceModel = linux.name;
        osVersion = linux.versionId ?? 'Linux';
      }
    } catch (_) {}

    return '\n---\nInformasi Perangkat:\n'
        '• Perangkat: $deviceModel\n'
        '• Sistem Operasi: $osVersion\n'
        '• Versi Aplikasi: $appVersion';
  }
}

/// Provider for DeviceInfoService
final deviceInfoServiceProvider = Provider<DeviceInfoService>((ref) {
  return DeviceInfoService();
});
