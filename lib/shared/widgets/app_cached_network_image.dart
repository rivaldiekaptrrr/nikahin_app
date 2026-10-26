import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Reusable cached network image with graceful wedding-themed placeholder and error fallback.
class AppCachedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  const AppCachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Widget image = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) =>
          placeholder ??
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: isDark
                  ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4)
                  : const Color(0xFFFDF0DE).withValues(alpha: 0.6),
            ),
            child: const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
      errorWidget: (context, url, error) =>
          errorWidget ??
          Container(
            width: width,
            height: height,
            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            child: Icon(
              Icons.broken_image_outlined,
              size: (width != null && width! < 40) ? 18 : 24,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
    );

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: image,
      );
    }

    return image;
  }
}

/// Circular avatar with network caching and initials/icon fallback.
class AppCachedAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  final String? fallbackInitials;
  final IconData fallbackIcon;
  final VoidCallback? onTap;

  const AppCachedAvatar({
    super.key,
    this.imageUrl,
    this.radius = 24,
    this.fallbackInitials,
    this.fallbackIcon = Icons.person_rounded,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasImage = imageUrl != null && imageUrl!.trim().isNotEmpty;

    Widget avatar = CircleAvatar(
      radius: radius,
      backgroundColor: theme.colorScheme.primaryContainer,
      child: hasImage
          ? ClipOval(
              child: AppCachedNetworkImage(
                imageUrl: imageUrl!,
                width: radius * 2,
                height: radius * 2,
                fit: BoxFit.cover,
                errorWidget: _buildFallback(theme),
              ),
            )
          : _buildFallback(theme),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: avatar,
      );
    }

    return avatar;
  }

  Widget _buildFallback(ThemeData theme) {
    if (fallbackInitials != null && fallbackInitials!.trim().isNotEmpty) {
      return Text(
        fallbackInitials!.trim().toUpperCase(),
        style: TextStyle(
          fontSize: radius * 0.75,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.primary,
        ),
      );
    }
    return Icon(
      fallbackIcon,
      size: radius * 1.1,
      color: theme.colorScheme.primary,
    );
  }
}
