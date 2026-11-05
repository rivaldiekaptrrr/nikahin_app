import { NextRequest, NextResponse } from 'next/server';

const R2_BASE =
  process.env.R2_BASE_URL ||
  'https://pub-f7149e09e969412da84fa6ab201a475e.r2.dev';

export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url);
  const requestedArch = searchParams.get('arch');
  const requestedBitness = searchParams.get('bitness');

  const secBitness = request.headers.get('sec-ch-ua-bitness');
  const userAgent = request.headers.get('user-agent')?.toLowerCase() || '';

  // Deteksi arsitektur 32-bit vs 64-bit
  const isExplicit32 =
    requestedArch === 'universal' ||
    requestedArch === '32' ||
    requestedBitness === '32' ||
    secBitness === '32' ||
    userAgent.includes('armeabi') ||
    userAgent.includes('armv7l');

  // Pilih berkas APK yang paling tepat
  const targetFile = isExplicit32 ? 'nikahin-universal.apk' : 'nikahin-arm64.apk';
  const downloadUrl = `${R2_BASE}/${targetFile}`;

  return NextResponse.redirect(downloadUrl, {
    status: 302,
    headers: {
      'Cache-Control': 'no-cache, no-store, must-revalidate',
      'Accept-CH': 'Sec-CH-UA-Bitness, Sec-CH-UA-Arch',
    },
  });
}
