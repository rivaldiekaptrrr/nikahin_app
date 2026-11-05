import { NextResponse } from 'next/server';

export async function GET() {
  const r2DownloadUrl =
    process.env.R2_DOWNLOAD_URL ||
    'https://pub-f7149e09e969412da84fa6ab201a475e.r2.dev/nikahin.apk';

  return NextResponse.redirect(r2DownloadUrl, {
    status: 302,
    headers: {
      'Cache-Control': 'no-cache, no-store, must-revalidate',
    },
  });
}
