import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../ui/theme/theme_controller.dart';

/// Reusable wrapper that paints the theme-dependent canvas background color
/// along with an optional seamless wedding doodle wallpaper pattern.
class WeddingDoodleBackground extends ConsumerWidget {
  final Widget child;

  const WeddingDoodleBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final doodleEnabled = ref.watch(doodlePatternEnabledProvider);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        image: doodleEnabled
            ? DecorationImage(
                image: const AssetImage('assets/images/wedding_doodle_pattern.png'),
                scale: 2.0,
                repeat: ImageRepeat.repeat,
                opacity: isDark ? 0.065 : 0.08,
                colorFilter: ColorFilter.mode(
                  isDark
                      ? Colors.white
                      : theme.colorScheme.onSurface,
                  BlendMode.srcIn,
                ),
              )
            : null,
      ),
      child: child,
    );
  }
}
