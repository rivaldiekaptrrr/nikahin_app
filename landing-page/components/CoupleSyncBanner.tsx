import React from 'react';
import Image from 'next/image';
import { HeartHandshake, KeyRound, RefreshCw, Smartphone } from 'lucide-react';

export default function CoupleSyncBanner() {
  return (
    <section id="pasangan" className="py-16 md:py-24 bg-white">
      <div className="max-w-6xl mx-auto px-4 sm:px-6">
        <div className="relative rounded-[36px] bg-gradient-to-br from-[#ffd9e2]/50 via-white to-[#fdf0de]/70 border border-[#ffd9e2] p-8 sm:p-12 md:p-14 overflow-hidden shadow-sm">
          {/* Subtle Ambient Glow */}
          <div className="absolute top-0 right-0 w-80 h-80 bg-gradient-to-bl from-[#d81b60]/15 to-transparent rounded-full blur-2xl pointer-events-none" />

          <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 items-center relative z-10">
            {/* Left Content */}
            <div className="lg:col-span-7 space-y-5">
              <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-white border border-[#ffd9e2] text-[#d81b60] text-xs font-bold uppercase tracking-wider">
                <HeartHandshake className="w-4 h-4" />
                <span>Akun Terhubung</span>
              </div>

              <h2 className="text-2xl sm:text-3xl md:text-4xl font-black text-slate-900 tracking-tight leading-tight">
                Satu Pembelian, Otomatis Aktif untuk Dua Akun Pasangan
              </h2>

              <p className="text-sm sm:text-base text-slate-600 leading-relaxed">
                Kamu tidak perlu membayar dua kali atau berbagi akun email yang sama. 
                Cukup bagikan <strong>6 karakter kode undangan</strong> kepada pasanganmu untuk langsung 
                terhubung secara otomatis.
              </p>

              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 pt-2">
                <div className="flex items-start gap-3 p-3.5 rounded-2xl bg-white/80 border border-slate-200/60">
                  <div className="w-8 h-8 rounded-xl bg-[#ffd9e2]/60 text-[#d81b60] flex items-center justify-center shrink-0">
                    <RefreshCw className="w-4 h-4" />
                  </div>
                  <div>
                    <h4 className="text-xs font-bold text-slate-900">Sinkronisasi Cepat</h4>
                    <p className="text-[11px] text-slate-500 mt-0.5">
                      Catat pengeluaran, langsung muncul di ponsel pasangan.
                    </p>
                  </div>
                </div>

                <div className="flex items-start gap-3 p-3.5 rounded-2xl bg-white/80 border border-slate-200/60">
                  <div className="w-8 h-8 rounded-xl bg-[#fdf0de] text-[#ad1457] flex items-center justify-center shrink-0">
                    <KeyRound className="w-4 h-4" />
                  </div>
                  <div>
                    <h4 className="text-xs font-bold text-slate-900">Akun Masing-Masing</h4>
                    <p className="text-[11px] text-slate-500 mt-0.5">
                      Masuk dengan Google sendiri tanpa perlu bertukar kata sandi.
                    </p>
                  </div>
                </div>
              </div>
            </div>

            {/* Right Card: Visual Demonstration */}
            <div className="lg:col-span-5 flex justify-center">
              <div className="w-full max-w-sm p-6 rounded-3xl bg-white border border-slate-200 shadow-xl shadow-slate-900/5 text-center">
                <div className="relative w-16 h-16 mx-auto mb-4">
                  <Image
                    src="/assets/nikahin-symbol-master-512.png"
                    alt="Logo Simbol Nikahin"
                    width={64}
                    height={64}
                    className="object-contain"
                  />
                </div>

                <h3 className="font-extrabold text-base text-slate-900">
                  Undang Pasanganmu
                </h3>
                <p className="text-xs text-slate-500 mt-1 mb-5">
                  Bagikan kode berikut kepada pasangan untuk bergabung ke dokumen pernikahan yang sama:
                </p>

                {/* Voucher Code Box */}
                <div className="p-4 rounded-2xl bg-[#fff9fa] border-2 border-dashed border-[#ffd9e2] mb-5">
                  <span className="text-xs font-semibold text-slate-400 block mb-1">
                    Kode Pasangan Unik
                  </span>
                  <span className="text-2xl font-mono font-black text-[#d81b60] tracking-widest">
                    NK-8X2P99
                  </span>
                </div>

                <div className="flex items-center justify-center gap-2 text-xs font-bold text-slate-700 bg-slate-50 py-2.5 px-4 rounded-xl">
                  <Smartphone className="w-4 h-4 text-emerald-600" />
                  <span>Bisa Digunakan di Android & iPhone</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}

