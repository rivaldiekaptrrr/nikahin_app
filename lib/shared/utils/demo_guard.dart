import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/auth_notifier.dart';
import '../../features/auth/presentation/widgets/demo_restriction_sheet.dart';

class DemoGuard {
  /// Checks if current user is in demo mode.
  /// If in demo mode, opens a friendly restriction sheet and returns `false`.
  /// If authenticated, returns `true` to allow the action to proceed.
  static bool checkAction(
    BuildContext context, {
    required WidgetRef ref,
    required String actionName,
  }) {
    final isDemo = ref.read(isDemoModeProvider);
    if (isDemo) {
      showDemoRestrictionSheet(context, featureName: actionName);
      return false;
    }
    return true;
  }
}
