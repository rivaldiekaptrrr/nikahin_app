import React from 'react';
import Image from 'next/image';
import { HeartHandshake, KeyRound, RefreshCw, Smartphone } from 'lucide-react';

export default function CoupleSyncBanner() {
  return (
    <section id="pasangan" className="py-16 md:py-24 relative">
      <div className="max-w-6xl mx-auto px-4 sm:px-6">
        <div className="relative rounded-3xl bg-white border border-[#1f1b16]/10 p-8 sm:p-12 md:p-14 overflow-hidden shadow-[0_8px_30px_-8px_rgba(28,25,23,0.06)]">
          {/* Subtle Organic Accent */}
          <div className="absolute top-4 right-4 pointer-events-none select-none z-0 animate-float-slow">
            <Image
              src="/assets/editorial/petal-blush.svg"
              alt=""
              width={40}
              height={40}
              className="w-6 h-6 sm:w-9 sm:h-9 opacity-70 rotate-45"
            />
          </div>
          <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 items-center relative z-10">
            {/* Left Content */}
            <div className="lg:col-span-7 space-y-5">
              <p className="flex items-center gap-2 text-xs font-medium text-stone-600">
                <HeartHandshake className="w-4 h-4 text-stone-700" />
                <span>Akun terhubung</span>
              </p>

              <h2 className="text-2xl sm:text-3xl md:text-4xl font-semibold text-stone-900 tracking-tight leading-tight">
                Satu pembelian, otomatis aktif untuk dua akun pasangan
              </h2>

              <p className="text-sm sm:text-base text-stone-600 leading-relaxed">
                Kamu tidak perlu membayar dua kali atau berbagi akun email yang sama.
                Cukup bagikan <strong>6 karakter kode undangan</strong> kepada pasanganmu untuk langsung
                terhubung secara otomatis.
              </p>

              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 pt-2">
                <div className="flex items-start gap-3 p-3.5 rounded-2xl bg-stone-50 border border-[#1f1b16]/8">
                  <div className="w-8 h-8 rounded-xl bg-stone-200/70 text-stone-800 flex items-center justify-center shrink-0">
                    <RefreshCw className="w-4 h-4" />
                  </div>
                  <div>
                    <h4 className="text-xs font-semibold text-stone-900">Sinkronisasi langsung</h4>
                    <p className="text-[11px] text-stone-500 mt-0.5">
                      Catat pengeluaran, langsung muncul di ponsel pasangan.
                    </p>
                  </div>
                </div>

                <div className="flex items-start gap-3 p-3.5 rounded-2xl bg-stone-50 border border-[#1f1b16]/8">
                  <div className="w-8 h-8 rounded-xl bg-stone-200/70 text-stone-800 flex items-center justify-center shrink-0">
                    <KeyRound className="w-4 h-4" />
                  </div>
                  <div>
                    <h4 className="text-xs font-semibold text-stone-900">Akun masing-masing</h4>
                    <p className="text-[11px] text-stone-500 mt-0.5">
                      Masuk dengan Google sendiri tanpa perlu bertukar kata sandi.
                    </p>
                  </div>
                </div>
              </div>
            </div>

            {/* Right Card: Visual Demonstration */}
            <div className="lg:col-span-5 flex justify-center">
              <div className="w-full max-w-sm p-6 rounded-2xl bg-stone-50/80 border border-[#1f1b16]/10 text-center">
                <div className="relative w-14 h-14 mx-auto mb-4">
                  <Image
                    src="/assets/nikahin-symbol-master-512.png"
                    alt="Logo Simbol Nikahin"
                    width={56}
                    height={56}
                    className="object-contain"
                  />
                </div>

                <h3 className="font-semibold text-base text-stone-900">
                  Undang pasanganmu
                </h3>
                <p className="text-xs text-stone-500 mt-1 mb-5">
                  Bagikan kode berikut kepada pasangan untuk bergabung ke dokumen pernikahan yang sama:
                </p>

                {/* Voucher Code Box */}
                <div className="p-4 rounded-xl bg-white border border-[#1f1b16]/12 mb-5 shadow-xs">
                  <span className="text-[11px] font-medium text-stone-500 block mb-1">
                    Kode pasangan unik
                  </span>
                  <span className="text-2xl font-mono font-bold text-stone-900 tracking-widest">
                    NK-8X2P99
                  </span>
                </div>

                <div className="flex items-center justify-center gap-2 text-xs font-medium text-stone-700 bg-white border border-[#1f1b16]/8 py-2.5 px-4 rounded-xl">
                  <Smartphone className="w-4 h-4 text-stone-600" />
                  <span>Bisa digunakan di Android & iPhone</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}

