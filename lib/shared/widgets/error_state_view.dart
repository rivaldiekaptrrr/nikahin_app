import 'package:flutter/material.dart';
import '../utils/error_handler.dart';

/// Reusable Error State View with descriptive message and Retry CTA
class ErrorStateView extends StatelessWidget {
  final dynamic error;
  final String? errorMessage;
  final String? title;
  final VoidCallback? onRetry;
  final IconData? icon;

  const ErrorStateView({
    super.key,
    this.error,
    this.errorMessage,
    this.title,
    this.onRetry,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appException = error != null ? AppErrorHandler.parse(error) : null;

    final resolvedTitle = title ?? _resolveTitle(appException?.type);
    final resolvedMessage = errorMessage ?? appException?.message ?? 'Gagal memuat informasi. Silakan coba lagi.';
    final resolvedIcon = icon ?? appException?.icon ?? Icons.error_outline_rounded;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer.withValues(alpha: 0.6),
                shape: BoxShape.circle,
              ),
              child: Icon(
                resolvedIcon,
                size: 44,
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              resolvedTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              resolvedMessage,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              FilledButton.tonalIcon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Coba Lagi'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _resolveTitle(AppErrorType? type) {
    switch (type) {
      case AppErrorType.networkError:
        return 'Koneksi Terputus';
      case AppErrorType.serverError:
        return 'Gangguan Server';
      case AppErrorType.authError:
        return 'Akses Ditolak';
      case AppErrorType.permissionError:
        return 'Izin Diperlukan';
      case AppErrorType.timeout:
        return 'Waktu Habis';
      case AppErrorType.validationError:
        return 'Data Tidak Sesuai';
      default:
        return 'Terjadi Kendala Memuat Data';
    }
  }
}

