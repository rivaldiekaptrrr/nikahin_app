'use client';

import React, { useState, useEffect, useSyncExternalStore } from 'react';
import { Download, Apple, QrCode } from 'lucide-react';
import IosInstallModal from './IosInstallModal';
import DesktopQrModal from './DesktopQrModal';
import { detectDevice, DeviceType } from '@/lib/device-detector';
import { ReleaseMetadata } from '@/lib/github-release';

interface DeviceCtaProps {
  release?: ReleaseMetadata;
  appUrl?: string;
}

function useUserAgentDevice(): DeviceType {
  return useSyncExternalStore(
    () => () => {},
    () => detectDevice(navigator.userAgent),
    () => 'desktop'
  );
}

function useIsClient(): boolean {
  return useSyncExternalStore(
    () => () => {},
    () => true,
    () => false
  );
}

export default function DeviceCta({
  release,
  appUrl = 'https://nikahin-app.pages.dev',
}: DeviceCtaProps) {
  const device = useUserAgentDevice();
  const isClient = useIsClient();
  const [iosModalOpen, setIosModalOpen] = useState(false);
  const [qrModalOpen, setQrModalOpen] = useState(false);
  const [downloadHref, setDownloadHref] = useState('/download');

  useEffect(() => {
    // Deteksi arsitektur 32-bit vs 64-bit di peramban pengguna
    const nav = navigator as unknown as {
      userAgentData?: {
        getHighEntropyValues: (hints: string[]) => Promise<{ bitness?: string; architecture?: string }>;
      };
    };

    if (nav.userAgentData?.getHighEntropyValues) {
      nav.userAgentData.getHighEntropyValues(['bitness', 'architecture'])
        .then((hints) => {
          if (hints.bitness === '32') {
            setDownloadHref('/download?arch=universal');
          } else if (hints.bitness === '64') {
            setDownloadHref('/download?arch=arm64');
          }
        })
        .catch(() => {});
    }
  }, []);

  // Selama SSR, render tampilan netral yang seimbang
  if (!isClient) {
    return (
      <div className="flex flex-col sm:flex-row items-center justify-center gap-3.5 pt-2">
        <div className="h-14 w-60 bg-slate-200/60 rounded-2xl animate-pulse" />
        <div className="h-14 w-44 bg-slate-100 rounded-2xl animate-pulse" />
      </div>
    );
  }

  return (
    <>
      <div className="flex flex-col items-center gap-3">
        {/* Tombol Utama Adaptif Sesuai Perangkat */}
        <div className="flex flex-col sm:flex-row items-center justify-center gap-3.5 w-full max-w-md sm:max-w-none">
          {/* Skenario 1: Pengguna Android */}
          {device === 'android' && (
            <a
              href={downloadHref}
              download="nikahin.apk"
              className="w-full sm:w-auto inline-flex items-center justify-center gap-2.5 px-8 py-4 rounded-2xl bg-[#d81b60] hover:bg-[#c2185b] text-white font-extrabold text-base shadow-lg shadow-[#d81b60]/25 hover:shadow-xl hover:shadow-[#d81b60]/35 hover:-translate-y-0.5 transition-all"
            >
              <Download className="w-5 h-5" />
              <span>Unduh APK</span>
            </a>
          )}

          {/* Skenario 2: Pengguna iPhone / iPad */}
          {device === 'ios' && (
            <button
              onClick={() => setIosModalOpen(true)}
              className="w-full sm:w-auto inline-flex items-center justify-center gap-2.5 px-8 py-4 rounded-2xl bg-[#d81b60] hover:bg-[#c2185b] text-white font-extrabold text-base shadow-lg shadow-[#d81b60]/25 hover:shadow-xl hover:shadow-[#d81b60]/35 hover:-translate-y-0.5 transition-all"
            >
              <Apple className="w-5 h-5" />
              <span>Pasang di iPhone</span>
            </button>
          )}

          {/* Skenario 3: Pengguna Komputer / Desktop */}
          {device === 'desktop' && (
            <>
              <a
                href={downloadHref}
                download="nikahin.apk"
                className="w-full sm:w-auto inline-flex items-center justify-center gap-2.5 px-7 py-4 rounded-2xl bg-[#d81b60] hover:bg-[#c2185b] text-white font-extrabold text-base shadow-lg shadow-[#d81b60]/25 hover:shadow-xl hover:shadow-[#d81b60]/35 hover:-translate-y-0.5 transition-all"
              >
                <Download className="w-5 h-5" />
                <span>Unduh APK</span>
              </a>

              <button
                onClick={() => setIosModalOpen(true)}
                className="w-full sm:w-auto inline-flex items-center justify-center gap-2 px-6 py-4 rounded-2xl bg-white hover:bg-slate-50 text-slate-800 font-bold text-sm border border-slate-200 shadow-sm hover:shadow transition-all"
              >
                <Apple className="w-4 h-4 text-[#d81b60]" />
                <span>Pasang di iPhone</span>
              </button>

              <button
                onClick={() => setQrModalOpen(true)}
                className="w-full sm:w-auto inline-flex items-center justify-center gap-2 px-4 py-4 rounded-2xl bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold text-sm transition-all"
                title="Buka QR Code untuk smartphone"
              >
                <QrCode className="w-4 h-4" />
                <span className="sm:hidden">Pindai QR</span>
              </button>
            </>
          )}
        </div>
      </div>

      {/* Modal Dialogs */}
      <IosInstallModal
        isOpen={iosModalOpen}
        onClose={() => setIosModalOpen(false)}
        appUrl={appUrl}
      />
      <DesktopQrModal
        isOpen={qrModalOpen}
        onClose={() => setQrModalOpen(false)}
        targetUrl="https://getnikahin.my.id"
      />
    </>
  );
}
