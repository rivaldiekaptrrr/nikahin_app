export interface ReleaseMetadata {
  version: string;
  apkUrl: string;
  fileSizeMb: string;
  publishedAt: string;
  changelog: string[];
}

interface GitHubAsset {
  name: string;
  size: number;
  browser_download_url: string;
}

interface GitHubReleaseResponse {
  tag_name?: string;
  html_url?: string;
  published_at?: string;
  body?: string;
  assets?: GitHubAsset[];
}

export async function getLatestRelease(): Promise<ReleaseMetadata> {
  try {
    const res = await fetch(
      'https://api.github.com/repos/rivaldiekaptrrr/nikahin_app/releases/latest',
      {
        next: { revalidate: 300 }, // ISR: Cache 5 menit di Vercel Edge
        headers: {
          'Accept': 'application/vnd.github.v3+json',
          'User-Agent': 'Nikahin-Landing-Page',
        },
      }
    );

    if (!res.ok) {
      throw new Error(`GitHub API error: ${res.status}`);
    }

    const data: GitHubReleaseResponse = await res.json();
    const assets = data.assets || [];

    // Prioritaskan universal APK atau APK rilis pertama
    const apkAsset =
      assets.find((a) => a.name.includes('universal') && a.name.endsWith('.apk')) ||
      assets.find((a) => a.name.endsWith('.apk'));

    const fileSizeMb = apkAsset?.size
      ? `${(apkAsset.size / (1024 * 1024)).toFixed(1)} MB`
      : '38.5 MB';

    const publishedAt = data.published_at
      ? new Date(data.published_at).toLocaleDateString('id-ID', {
          day: 'numeric',
          month: 'long',
          year: 'numeric',
        })
      : 'November 2026';

    const changelog = data.body
      ? data.body
          .split('\n')
          .map((line: string) => line.replace(/^[•\-\*]\s*/, '').trim())
          .filter((line: string) => line.length > 0 && !line.startsWith('#'))
      : [];

    return {
      version: data.tag_name || 'v1.1.12',
      apkUrl: apkAsset?.browser_download_url || `https://github.com/rivaldiekaptrrr/nikahin_app/releases/tag/${data.tag_name || 'v1.1.12'}`,
      fileSizeMb,
      publishedAt,
      changelog: changelog.length > 0 ? changelog : [
        'Pembaruan antarmuka Luxury Bento untuk aktivasi lisensi',
        'Kanal pembayaran Midtrans lengkap & terverifikasi otomatis',
        'Penyempurnaan sinkronisasi pasangan real-time',
      ],
    };
  } catch {
    // Fallback data aman saat build time atau jika rate limit GitHub terlampaui
    return {
      version: 'v1.1.12',
      apkUrl: 'https://github.com/rivaldiekaptrrr/nikahin_app/releases/latest',
      fileSizeMb: '38.5 MB',
      publishedAt: 'November 2026',
      changelog: [
        'Pembaruan antarmuka Luxury Bento untuk aktivasi lisensi',
        'Kanal pembayaran Midtrans lengkap & terverifikasi otomatis',
        'Penyempurnaan sinkronisasi pasangan real-time',
      ],
    };
  }
}
