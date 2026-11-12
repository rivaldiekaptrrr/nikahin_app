'use client';

import React, { useState } from 'react';
import Image from 'next/image';
import {
  LayoutDashboard,
  Wallet,
  CheckSquare,
  HeartHandshake,
  UserCheck,
} from 'lucide-react';

export default function AppPreviewMockup() {
  const [activeTab, setActiveTab] = useState<'beranda' | 'anggaran' | 'tugas' | 'couple'>('beranda');

  return (
    <section id="preview" className="pt-2 pb-16 sm:pt-6 sm:pb-20 md:pt-12 md:pb-28 relative overflow-hidden">
      <div className="max-w-6xl mx-auto px-4 sm:px-6">
        {/* Section Header - Ramping di Mobile */}
        <div className="text-center max-w-2xl mx-auto mb-6 sm:mb-10">
          <p className="text-xs font-semibold uppercase tracking-wider text-[#d81b60] mb-1.5">
            Tangkapan Layar Nyata
          </p>
          <h2 className="text-2xl sm:text-3xl md:text-4xl font-semibold text-stone-900 tracking-tight">
            Dirancang rapi untuk setiap tahap persiapan
          </h2>
          <p className="text-stone-600 text-xs sm:text-sm md:text-base mt-2 sm:mt-3">
            Tampilan asli aplikasi Nikahin yang mendampingi kamu dan pasangan mengelola hari bahagia berdua.
          </p>
        </div>

        {/* Feature Tabs Bar - Ramping & Nyaman Digeser */}
        <div className="w-full flex justify-center mb-6 sm:mb-8 px-2 sm:px-0">
          <div className="flex items-center justify-start sm:justify-center gap-1.5 max-w-full sm:max-w-xl p-1.5 rounded-2xl bg-stone-200/60 border border-[#1f1b16]/6 overflow-x-auto scroll-smooth touch-pan-x [-ms-overflow-style:none] [scrollbar-width:none] [&::-webkit-scrollbar]:hidden">
            <button
              onClick={() => setActiveTab('beranda')}
              className={`flex items-center gap-2 px-3 py-1.5 sm:px-4 sm:py-2 rounded-xl text-xs font-semibold transition-colors shrink-0 ${
                activeTab === 'beranda'
                  ? 'bg-white text-stone-900 shadow-sm'
                  : 'text-stone-600 hover:text-stone-900'
              }`}
            >
              <LayoutDashboard className="w-4 h-4" />
              <span>Beranda &amp; D-Day</span>
            </button>

            <button
              onClick={() => setActiveTab('anggaran')}
              className={`flex items-center gap-2 px-3 py-1.5 sm:px-4 sm:py-2 rounded-xl text-xs font-semibold transition-colors shrink-0 ${
                activeTab === 'anggaran'
                  ? 'bg-white text-stone-900 shadow-sm'
                  : 'text-stone-600 hover:text-stone-900'
              }`}
            >
              <Wallet className="w-4 h-4" />
              <span>Anggaran &amp; Biaya</span>
            </button>

            <button
              onClick={() => setActiveTab('tugas')}
              className={`flex items-center gap-2 px-3 py-1.5 sm:px-4 sm:py-2 rounded-xl text-xs font-semibold transition-colors shrink-0 ${
                activeTab === 'tugas'
                  ? 'bg-white text-stone-900 shadow-sm'
                  : 'text-stone-600 hover:text-stone-900'
              }`}
            >
              <CheckSquare className="w-4 h-4" />
              <span>Tugas &amp; Ceklist</span>
            </button>

            <button
              onClick={() => setActiveTab('couple')}
              className={`flex items-center gap-2 px-3 py-1.5 sm:px-4 sm:py-2 rounded-xl text-xs font-semibold transition-colors shrink-0 ${
                activeTab === 'couple'
                  ? 'bg-white text-stone-900 shadow-sm'
                  : 'text-stone-600 hover:text-stone-900'
              }`}
            >
              <HeartHandshake className="w-4 h-4" />
              <span>Koneksi Pasangan</span>
            </button>
          </div>
        </div>

        {/* Realistic Smartphone Frame (Center Showcase with Natural Ambient Shadow) */}
        <div className="relative max-w-[310px] sm:max-w-[350px] mx-auto">
          {/* Warm Ambient Halo behind the Mockup */}
          <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[340px] sm:w-[460px] h-[340px] sm:h-[460px] bg-gradient-to-tr from-[#fce7ef]/40 via-[#fdf0de]/60 to-transparent rounded-full blur-3xl pointer-events-none -z-10" />

          {/* Editorial Atmosphere Card: Wedding Banquet (Left side on Desktop) */}
          <div className="hidden lg:block absolute -left-48 top-16 w-44 rounded-2xl p-2 bg-white/95 shadow-xl shadow-stone-900/5 border border-stone-200/80 -rotate-6 pointer-events-none select-none z-10">
            <div className="relative aspect-[4/5] rounded-xl overflow-hidden mb-2">
              <Image
                src="/assets/editorial/wedding-banquet.jpg"
                alt="Dekorasi Meja Jamuan"
                fill
                sizes="176px"
                className="object-cover"
              />
            </div>
            <p className="text-[11px] font-medium text-stone-700 text-center tracking-tight">
              Dekorasi &amp; Jamuan Idaman
            </p>
          </div>

          {/* Editorial Atmosphere Card: Wedding Couple (Right side on Desktop) */}
          <div className="hidden lg:block absolute -right-48 bottom-24 w-44 rounded-2xl p-2 bg-white/95 shadow-xl shadow-stone-900/5 border border-stone-200/80 rotate-6 pointer-events-none select-none z-10">
            <div className="relative aspect-[4/5] rounded-xl overflow-hidden mb-2">
              <Image
                src="/assets/editorial/wedding-couple-indo.jpg"
                alt="Momen Bahagia Berdua"
                fill
                sizes="176px"
                className="object-cover object-top"
              />
            </div>
            <p className="text-[11px] font-medium text-stone-700 text-center tracking-tight">
              Momen Bahagia Berdua
            </p>
          </div>

          {/* Decorative Floating Accents Around Frame */}
          <div className="absolute -top-3 -right-3 sm:-top-5 sm:-right-6 pointer-events-none select-none z-30 animate-float-slow">
            <Image
              src="/assets/editorial/leaf-green.svg"
              alt=""
              width={48}
              height={48}
              className="w-8 h-8 sm:w-11 sm:h-11 -rotate-45 opacity-85"
            />
          </div>
          <div className="absolute -bottom-3 -left-3 sm:-bottom-5 sm:-left-6 pointer-events-none select-none z-30 animate-float-reverse">
            <Image
              src="/assets/editorial/petal-jasmine.svg"
              alt=""
              width={44}
              height={44}
              className="w-7 h-7 sm:w-10 sm:h-10 rotate-12 opacity-80"
            />
          </div>

          {/* Outer Phone Shell */}
          <div className="relative rounded-[50px] p-3 bg-stone-950 shadow-[0_32px_64px_-16px_rgba(28,25,23,0.24)] ring-1 ring-stone-900 border-[3.5px] border-stone-800">
            {/* Dynamic Island / Speaker Notch */}
            <div className="absolute top-5 left-1/2 -translate-x-1/2 w-24 h-4 bg-black rounded-full z-20 flex items-center justify-between px-2.5 pointer-events-none">
              <div className="w-2 h-2 rounded-full bg-stone-900 border border-stone-800" />
              <div className="w-2 h-2 rounded-full bg-stone-950" />
            </div>

            {/* Inner Screen Canvas (Standard 9:20 Phone Ratio) */}
            <div className="relative rounded-[38px] bg-stone-900 overflow-hidden aspect-[9/20] w-full">
              {/* TAB 1: BERANDA (Real Screenshot) */}
              {activeTab === 'beranda' && (
                <div className="relative w-full h-full animate-in fade-in duration-300">
                  <Image
                    src="/screenshots/beranda.jpeg"
                    alt="Tampilan Asli Beranda & Countdown D-Day Nikahin App"
                    fill
                    priority
                    sizes="(max-width: 640px) 320px, 350px"
                    className="object-cover object-top select-none pointer-events-none"
                  />
                </div>
              )}

              {/* TAB 2: ANGGARAN (Real Screenshot) */}
              {activeTab === 'anggaran' && (
                <div className="relative w-full h-full animate-in fade-in duration-300">
                  <Image
                    src="/screenshots/anggaran.jpeg"
                    alt="Tampilan Asli Modul Anggaran Nikahin App"
                    fill
                    priority
                    sizes="(max-width: 640px) 320px, 350px"
                    className="object-cover object-top select-none pointer-events-none"
                  />
                </div>
              )}

              {/* TAB 3: TUGAS & CEKLIST (Real Screenshot) */}
              {activeTab === 'tugas' && (
                <div className="relative w-full h-full animate-in fade-in duration-300">
                  <Image
                    src="/screenshots/tugas.jpeg"
                    alt="Tampilan Asli Modul Tugas & Ceklist Nikahin App"
                    fill
                    priority
                    sizes="(max-width: 640px) 320px, 350px"
                    className="object-cover object-top select-none pointer-events-none"
                  />
                </div>
              )}

              {/* TAB 4: KONEKSI PASANGAN (Interactive Design Mockup) */}
              {activeTab === 'couple' && (
                <div className="relative w-full h-full bg-[#fcf9f5] p-4 text-stone-900 flex flex-col justify-between animate-in fade-in duration-300 pt-7">
                  {/* Screen Status Bar */}
                  <div className="flex items-center justify-between text-[11px] font-bold text-slate-400 px-2 pt-1 pb-2">
                    <span>09:41</span>
                    <span className="flex items-center gap-1.5">
                      <span>5G</span>
                      <span>100%</span>
                    </span>
                  </div>

                  {/* Couple Sync Content */}
                  <div className="flex-1 space-y-3 pt-2">
                    <div className="p-4 rounded-2xl bg-gradient-to-br from-[#ffd9e2]/50 via-white to-[#fdf0de]/50 border border-[#ffd9e2] text-center shadow-xs">
                      <div className="w-10 h-10 rounded-full bg-[#d81b60] text-white mx-auto flex items-center justify-center mb-2 shadow-sm">
                        <HeartHandshake className="w-5 h-5" />
                      </div>
                      <h4 className="text-xs font-black text-slate-900 uppercase tracking-wide">
                        Status Terhubung
                      </h4>
                      <p className="text-[11px] text-slate-600 mt-0.5 font-medium">
                        Rivaldi &amp; Annisa (Pasangan Terhubung)
                      </p>
                      <div className="mt-3 p-2 bg-white rounded-xl border border-slate-200/80 inline-flex items-center gap-2">
                        <span className="text-[10px] text-slate-400 font-semibold">Kode Unik:</span>
                        <span className="text-xs font-mono font-black text-[#d81b60] tracking-wider">
                          NK-8X2P99
                        </span>
                      </div>
                    </div>

                    <div className="p-3.5 rounded-xl bg-white border border-slate-100 shadow-xs space-y-2">
                      <p className="text-xs font-bold text-slate-900 flex items-center gap-1.5">
                        <UserCheck className="w-3.5 h-3.5 text-emerald-600" />
                        <span>Sinkronisasi Otomatis 2 Arah</span>
                      </p>
                      <p className="text-[11px] text-slate-600 leading-relaxed">
                        Setiap perubahan anggaran, penambahan checklist, dan status persiapan yang diedit salah satu pihak langsung terupdate di layar pasangan seketika.
                      </p>
                    </div>

                    <div className="p-3 rounded-xl bg-white border border-slate-100 shadow-xs flex items-center justify-between text-xs font-semibold text-slate-700">
                      <span>Akses Data Pernikahan</span>
                      <span className="text-emerald-600 text-[11px] font-bold">Privat &amp; Real-Time</span>
                    </div>
                  </div>

                  {/* Bottom In-App Nav Bar */}
                  <div className="pt-2.5 pb-1 border-t border-slate-200/70 flex items-center justify-around text-slate-400">
                    <div className="flex flex-col items-center">
                      <LayoutDashboard className="w-4 h-4" />
                      <span className="text-[9px] font-medium mt-0.5">Beranda</span>
                    </div>
                    <div className="flex flex-col items-center">
                      <Wallet className="w-4 h-4" />
                      <span className="text-[9px] font-medium mt-0.5">Anggaran</span>
                    </div>
                    <div className="flex flex-col items-center">
                      <CheckSquare className="w-4 h-4" />
                      <span className="text-[9px] font-medium mt-0.5">Tugas</span>
                    </div>
                    <div className="flex flex-col items-center text-[#d81b60]">
                      <HeartHandshake className="w-4 h-4" />
                      <span className="text-[9px] font-bold mt-0.5">Pasangan</span>
                    </div>
                  </div>
                </div>
              )}
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
