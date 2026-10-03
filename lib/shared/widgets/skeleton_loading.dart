import 'package:flutter/material.dart';

/// Animated skeleton placeholder with elegant shimmer/pulse effect for smooth loading transitions
class SkeletonPlaceholder extends StatefulWidget {
  final double? width;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;

  const SkeletonPlaceholder({
    super.key,
    this.width,
    required this.height,
    this.borderRadius = 8,
    this.margin,
  });

  @override
  State<SkeletonPlaceholder> createState() => _SkeletonPlaceholderState();
}

class _SkeletonPlaceholderState extends State<SkeletonPlaceholder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.35, end: 0.85).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          margin: widget.margin,
          decoration: BoxDecoration(
            color: baseColor.withValues(alpha: _animation.value),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        );
      },
    );
  }
}

/// Skeleton Card resembling BentoCard layout
class SkeletonCard extends StatelessWidget {
  final double height;
  final EdgeInsetsGeometry margin;

  const SkeletonCard({
    super.key,
    this.height = 90,
    this.margin = const EdgeInsets.only(bottom: 12),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: height,
      margin: margin,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              SkeletonPlaceholder(width: 38, height: 38, borderRadius: 12),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonPlaceholder(width: 140, height: 14, borderRadius: 4),
                    SizedBox(height: 6),
                    SkeletonPlaceholder(width: 80, height: 10, borderRadius: 4),
                  ],
                ),
              ),
              SkeletonPlaceholder(width: 60, height: 22, borderRadius: 8),
            ],
          ),
        ],
      ),
    );
  }
}

/// Skeleton Header Summary Banner
class SkeletonSummaryHeader extends StatelessWidget {
  const SkeletonSummaryHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SkeletonPlaceholder(width: 120, height: 14, borderRadius: 4),
              SkeletonPlaceholder(width: 90, height: 16, borderRadius: 4),
            ],
          ),
          SizedBox(height: 14),
          SkeletonPlaceholder(height: 8, borderRadius: 4),
          SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SkeletonPlaceholder(width: 70, height: 12, borderRadius: 4),
              SkeletonPlaceholder(width: 70, height: 12, borderRadius: 4),
              SkeletonPlaceholder(width: 70, height: 12, borderRadius: 4),
            ],
          ),
        ],
      ),
    );
  }
}

/// Full Skeleton List for list view loading states
class SkeletonListView extends StatelessWidget {
  final int itemCount;
  final bool showHeader;
  final EdgeInsetsGeometry padding;

  const SkeletonListView({
    super.key,
    this.itemCount = 4,
    this.showHeader = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: padding,
      children: [
        if (showHeader) const SkeletonSummaryHeader(),
        ...List.generate(itemCount, (index) => const SkeletonCard()),
      ],
    );
  }
}
