import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/app_release_info.dart';
import '../update_notifier.dart';

/// Dialog konfirmasi dan progres In-App Update
class UpdateDialog extends ConsumerWidget {
  final AppReleaseInfo releaseInfo;

  const UpdateDialog({
    super.key,
    required this.releaseInfo,
  });

  /// Helper statis untuk menampilkan dialog pembaruan
  static Future<void> show(
    BuildContext context, {
    required AppReleaseInfo release,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => UpdateDialog(releaseInfo: release),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final updateState = ref.watch(updateNotifierProvider);
    final isDownloading = updateState.status == UpdateStatus.downloading;
    final isReadyToInstall = updateState.status == UpdateStatus.readyToInstall;

    return PopScope(
      canPop: !isDownloading,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header dengan Ikon & Judul
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        isReadyToInstall
                            ? Icons.check_circle_rounded
                            : Icons.rocket_launch_rounded,
                        color: theme.colorScheme.primary,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isReadyToInstall
                                ? 'Unduhan Selesai'
                                : 'Pembaruan Tersedia!',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'v${updateState.currentVersion}',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Icon(
                                Icons.arrow_forward_rounded,
                                size: 14,
                                color: theme.colorScheme.outline,
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withAlpha(25),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'v${releaseInfo.versionName}',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Area Catatan Rilis / Status Unduhan
                if (isDownloading) ...[
                  _buildDownloadProgress(context, updateState),
                ] else if (isReadyToInstall) ...[
                  _buildReadyToInstallView(context),
                ] else ...[
                  _buildReleaseNotes(context),
                ],

                // Error message jika ada
                if (updateState.errorMessage != null &&
                    !isDownloading &&
                    !isReadyToInstall) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer.withAlpha(100),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          size: 18,
                          color: theme.colorScheme.error,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            updateState.errorMessage!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                // Tombol Aksi
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (!isDownloading) ...[
                      TextButton(
                        onPressed: () {
                          ref.read(updateNotifierProvider.notifier).dismiss();
                          Navigator.of(context).pop();
                        },
                        child: const Text('Nanti'),
                      ),
                      const SizedBox(width: 8),
                    ],
                    if (isReadyToInstall)
                      FilledButton.icon(
                        onPressed: () {
                          ref
                              .read(updateNotifierProvider.notifier)
                              .installExistingApk();
                        },
                        icon: const Icon(Icons.install_mobile_rounded, size: 18),
                        label: const Text('Pasang Sekarang'),
                      )
                    else if (!isDownloading)
                      FilledButton.icon(
                        onPressed: () {
                          ref
                              .read(updateNotifierProvider.notifier)
                              .startDownloadAndInstall(releaseInfo);
                        },
                        icon: const Icon(Icons.download_rounded, size: 18),
                        label: const Text('Unduh Sekarang'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReleaseNotes(BuildContext context) {
    final theme = Theme.of(context);
    final notes = releaseInfo.releaseNotes.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Catatan Rilis:',
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxHeight: 180),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withAlpha(80),
            ),
          ),
          child: SingleChildScrollView(
            child: Text(
              notes.isNotEmpty
                  ? notes
                  : 'Pembaruan ini mencakup peningkatan performa, perbaikan bug, dan optimasi kestabilan aplikasi.',
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.4,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDownloadProgress(BuildContext context, UpdateState state) {
    final theme = Theme.of(context);
    final percent = (state.downloadProgress * 100).clamp(0, 100).toInt();
    final isIndeterminate = state.downloadProgress < 0;

    final receivedMb = (state.receivedBytes / (1024 * 1024)).toStringAsFixed(1);
    final totalMb = state.totalBytes > 0
        ? (state.totalBytes / (1024 * 1024)).toStringAsFixed(1)
        : null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Mengunduh pembaruan...',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (!isIndeterminate)
                Text(
                  '$percent%',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: isIndeterminate ? null : state.downloadProgress,
              minHeight: 8,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            totalMb != null ? '$receivedMb MB / $totalMb MB' : '$receivedMb MB',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadyToInstallView(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withAlpha(80),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.colorScheme.primary.withAlpha(50),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.verified_rounded,
            color: theme.colorScheme.primary,
            size: 32,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Berkas APK Siap Dipasang',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Klik tombol di bawah untuk memasang pembaruan.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
