'use client';

import React from 'react';
import { X, Share, PlusSquare, ExternalLink, Smartphone, Compass } from 'lucide-react';
import { trackDownloadClick } from '@/lib/fpixel';

interface IosInstallModalProps {
  isOpen: boolean;
  onClose: () => void;
  appUrl: string;
}

export default function IosInstallModal({ isOpen, onClose, appUrl }: IosInstallModalProps) {
  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-900/60 backdrop-blur-sm animate-in fade-in duration-200">
      <div
        className="relative w-full max-w-md bg-white rounded-3xl p-6 sm:p-7 shadow-2xl border border-slate-100 overflow-hidden text-left"
        onClick={(e) => e.stopPropagation()}
      >
        {/* Close Button */}
        <button
          onClick={onClose}
          className="absolute top-5 right-5 p-2 text-slate-400 hover:text-slate-700 rounded-full hover:bg-slate-100 transition-colors"
          aria-label="Tutup modal"
        >
          <X className="w-5 h-5" />
        </button>

        {/* Modal Header */}
        <div className="flex items-center gap-3.5 mb-5 pr-8">
          <div className="w-11 h-11 rounded-2xl bg-[#fdf0de] flex items-center justify-center text-[#d81b60] shrink-0">
            <Smartphone className="w-6 h-6" />
          </div>
          <div>
            <h3 className="font-extrabold text-lg text-slate-900 leading-snug">
              Pasang Nikahin di iPhone
            </h3>
            <p className="text-xs text-slate-500 font-medium mt-0.5">
              Cukup buka di Safari dan tambahkan ke layar utama, tanpa repot lewat App Store
            </p>
          </div>
        </div>

        {/* 3 Steps Guide */}
        <div className="space-y-3.5 my-6">
          {/* Step 1 */}
          <div className="flex items-start gap-3.5 p-3.5 rounded-2xl bg-[#fff9fa] border border-[#ffd9e2]/50">
            <div className="w-7 h-7 rounded-full bg-[#d81b60] text-white flex items-center justify-center text-xs font-bold shrink-0 mt-0.5">
              1
            </div>
            <div className="flex-1">
              <p className="text-xs font-bold text-slate-900 flex items-center gap-1.5">
                <span>Buka di Peramban Safari</span>
                <Compass className="w-3.5 h-3.5 text-[#d81b60] shrink-0" />
              </p>
              <p className="text-[11.5px] text-slate-600 mt-0.5 leading-relaxed">
                Pastikan kamu membuka tautan aplikasi menggunakan browser Safari bawaan iPhone.
              </p>
            </div>
          </div>

          {/* Step 2 */}
          <div className="flex items-start gap-3.5 p-3.5 rounded-2xl bg-[#fff9fa] border border-[#ffd9e2]/50">
            <div className="w-7 h-7 rounded-full bg-[#d81b60] text-white flex items-center justify-center text-xs font-bold shrink-0 mt-0.5">
              2
            </div>
            <div className="flex-1">
              <p className="text-xs font-bold text-slate-900 flex items-center gap-1.5">
                <span>Tekan Tombol Bagikan</span>
                <Share className="w-3.5 h-3.5 text-[#d81b60] shrink-0" />
              </p>
              <p className="text-[11.5px] text-slate-600 mt-0.5 leading-relaxed">
                Ketuk ikon <span className="font-semibold text-slate-800">Share</span> (kotak berpanah atas) di menu bilah bawah Safari.
              </p>
            </div>
          </div>

          {/* Step 3 */}
          <div className="flex items-start gap-3.5 p-3.5 rounded-2xl bg-[#fff9fa] border border-[#ffd9e2]/50">
            <div className="w-7 h-7 rounded-full bg-[#d81b60] text-white flex items-center justify-center text-xs font-bold shrink-0 mt-0.5">
              3
            </div>
            <div className="flex-1">
              <p className="text-xs font-bold text-slate-900 flex items-center gap-1.5">
                <span>Pilih &quot;Tambah ke Layar Utama&quot;</span>
                <PlusSquare className="w-3.5 h-3.5 text-[#d81b60] shrink-0" />
              </p>
              <p className="text-[11.5px] text-slate-600 mt-0.5 leading-relaxed">
                Gulir ke bawah lalu pilih <span className="font-semibold text-slate-800">Add to Home Screen</span>. Ikon Nikahin akan langsung muncul di beranda iPhone kamu.
              </p>
            </div>
          </div>
        </div>

        {/* Action Button */}
        <div className="pt-2">
          <a
            href={appUrl}
            target="_blank"
            rel="noopener noreferrer"
            onClick={() => trackDownloadClick('ios', { source: 'safari_install_modal_open_app' })}
            className="w-full inline-flex items-center justify-center gap-2 py-3.5 px-5 rounded-2xl bg-[#d81b60] hover:bg-[#c2185b] text-white font-bold text-sm shadow-md shadow-[#d81b60]/25 transition-all"
          >
            <span>Buka Aplikasi di Safari</span>
            <ExternalLink className="w-4 h-4" />
          </a>
          <p className="text-left text-[11px] text-slate-400 mt-2.5 leading-relaxed">
            Aplikasi otomatis terbuka layar penuh seperti aplikasi biasa.
          </p>
        </div>
      </div>
    </div>
  );
}

