'use client';

import React from 'react';
import { X, ShieldCheck, Download, AlertTriangle, Settings, CheckCircle2 } from 'lucide-react';

interface AndroidInstallModalProps {
  isOpen: boolean;
  onClose: () => void;
  downloadUrl?: string;
}

export default function AndroidInstallModal({
  isOpen,
  onClose,
  downloadUrl = '/download',
}: AndroidInstallModalProps) {
  if (!isOpen) return null;

  return (
    <div
      className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-900/60 backdrop-blur-sm animate-in fade-in duration-200"
      onClick={onClose}
    >
      <div
        className="relative w-full max-w-md bg-white rounded-3xl p-6 sm:p-7 shadow-2xl border border-slate-100 overflow-hidden max-h-[90vh] overflow-y-auto"
        onClick={(e) => e.stopPropagation()}
      >
        {/* Tombol Tutup */}
        <button
          onClick={onClose}
          className="absolute top-5 right-5 p-2 text-slate-400 hover:text-slate-700 rounded-full hover:bg-slate-100 transition-colors"
          aria-label="Tutup panduan"
        >
          <X className="w-5 h-5" />
        </button>

        {/* Header Modal */}
        <div className="flex items-center gap-3.5 mb-5 pr-8">
          <div className="w-11 h-11 rounded-2xl bg-[#fdf0de] flex items-center justify-center text-[#d81b60] shrink-0">
            <ShieldCheck className="w-6 h-6" />
          </div>
          <div>
            <h3 className="font-extrabold text-lg text-slate-900 leading-snug">
              Panduan Pemasangan di Android
            </h3>
            <p className="text-xs text-slate-500 font-medium mt-0.5">
              Unduhan sedang berjalan otomatis di latar belakang
            </p>
          </div>
        </div>

        {/* Banner Jaminan Keamanan */}
        <div className="mb-4 p-3 rounded-2xl bg-[#fff9fa] border border-[#ffd9e2] flex items-center gap-2.5">
          <CheckCircle2 className="w-4 h-4 text-[#d81b60] shrink-0" />
          <p className="text-[11.5px] text-slate-700 font-medium leading-relaxed">
            Berkas resmi Nikahin terverifikasi <span className="font-bold text-[#ad1457]">100% aman</span>, bersih, dan bebas dari malware.
          </p>
        </div>

        {/* 3 Langkah Praktis */}
        <div className="space-y-3 my-4">
          {/* Langkah 1 */}
          <div className="flex items-start gap-3.5 p-3.5 rounded-2xl bg-slate-50 border border-slate-200/70">
            <div className="w-6 h-6 rounded-full bg-[#d81b60] text-white flex items-center justify-center text-xs font-bold shrink-0 mt-0.5">
              1
            </div>
            <div>
              <p className="text-xs font-bold text-slate-900 flex items-center gap-1.5">
                <span>Pilih &quot;Tetap Download&quot; / &quot;Download Anyway&quot;</span>
              </p>
              <p className="text-[11.5px] text-slate-600 mt-1 leading-relaxed">
                Chrome menampilkan peringatan ini untuk semua berkas APK di luar Play Store. Silakan tekan tombol konfirmasi unduh.
              </p>
            </div>
          </div>

          {/* Langkah 2 */}
          <div className="flex items-start gap-3.5 p-3.5 rounded-2xl bg-slate-50 border border-slate-200/70">
            <div className="w-6 h-6 rounded-full bg-[#d81b60] text-white flex items-center justify-center text-xs font-bold shrink-0 mt-0.5">
              2
            </div>
            <div>
              <p className="text-xs font-bold text-slate-900 flex items-center gap-1.5">
                <span>Buka Berkas & Aktifkan Izin Sumber</span>
                <Settings className="w-3.5 h-3.5 text-[#d81b60]" />
              </p>
              <p className="text-[11.5px] text-slate-600 mt-1 leading-relaxed">
                Ketuk notifikasi selesai unduh. Jika muncul permintaan izin, aktifkan opsi <span className="font-semibold text-slate-800">&quot;Izinkan dari sumber ini&quot;</span> pada pengaturan ponsel.
              </p>
            </div>
          </div>

          {/* Langkah 3 (Play Protect) */}
          <div className="flex items-start gap-3.5 p-3.5 rounded-2xl bg-slate-50 border border-slate-200/70">
            <div className="w-6 h-6 rounded-full bg-[#d81b60] text-white flex items-center justify-center text-xs font-bold shrink-0 mt-0.5">
              3
            </div>
            <div>
              <p className="text-xs font-bold text-slate-900 flex items-center gap-1.5">
                <span>Jika Ada Play Protect: Ketuk &quot;Tetap Pasang&quot;</span>
                <AlertTriangle className="w-3.5 h-3.5 text-amber-500" />
              </p>
              <p className="text-[11.5px] text-slate-600 mt-1 leading-relaxed">
                Jika muncul pop-up Play Protect, ketuk teks <span className="font-semibold text-slate-800">&quot;Detail selengkapnya&quot;</span> lalu pilih <span className="font-bold text-[#ad1457]">&quot;Tetap pasang (Install anyway)&quot;</span>.
              </p>
            </div>
          </div>
        </div>

        {/* Tombol Aksi */}
        <div className="pt-2 flex flex-col gap-2">
          <button
            onClick={onClose}
            className="w-full py-3.5 px-4 rounded-2xl bg-[#d81b60] hover:bg-[#c2185b] text-white font-bold text-sm shadow-md shadow-[#d81b60]/20 transition-all text-center"
          >
            Saya Mengerti, Lanjutkan
          </button>

          <a
            href={downloadUrl}
            download="nikahin.apk"
            className="text-center text-xs font-medium text-slate-500 hover:text-[#d81b60] transition-colors py-1.5"
          >
            Unduhan tidak berjalan otomatis? <span className="font-bold underline">Klik di sini untuk mengunduh ulang</span>
          </a>
        </div>
      </div>
    </div>
  );
}
