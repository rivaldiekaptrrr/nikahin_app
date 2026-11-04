'use client';

import React, { useState } from 'react';
import {
  Wallet,
  Clock,
  Users2,
  HeartHandshake,
  CheckCircle2,
  Sparkles,
  PhoneCall,
  UserCheck,
  CreditCard,
  Gift,
} from 'lucide-react';

export default function AppPreviewMockup() {
  const [activeTab, setActiveTab] = useState<'budget' | 'rundown' | 'guests' | 'couple'>('budget');

  return (
    <section id="preview" className="py-20 md:py-28 bg-white relative">
      <div className="max-w-6xl mx-auto px-4 sm:px-6">
        {/* Section Header */}
        <div className="text-center max-w-2xl mx-auto mb-14">
          <p className="text-xs font-bold uppercase tracking-wider text-[#d81b60] mb-2.5">
            Tampilan Nyata Aplikasi
          </p>
          <h2 className="text-3xl sm:text-4xl font-extrabold text-slate-900 tracking-tight">
            Dirancang Rapi untuk Setiap Tahap Persiapan
          </h2>
          <p className="text-slate-600 text-sm sm:text-base mt-3">
            Eksplorasi modul inti Nikahin yang akan mendampingi kamu dan pasangan hingga hari H.
          </p>
        </div>

        {/* Feature Tabs Bar */}
        <div className="w-full flex justify-center mb-12 px-2 sm:px-0">
          <div className="flex items-center justify-start sm:justify-center gap-2 max-w-full sm:max-w-xl p-1.5 rounded-2xl bg-slate-100/90 overflow-x-auto scroll-smooth touch-pan-x [-ms-overflow-style:none] [scrollbar-width:none] [&::-webkit-scrollbar]:hidden">
            <button
              onClick={() => setActiveTab('budget')}
              className={`flex items-center gap-2 px-3.5 py-2.5 sm:px-4 rounded-xl text-xs font-bold transition-all shrink-0 ${
                activeTab === 'budget'
                  ? 'bg-white text-[#d81b60] shadow-sm'
                  : 'text-slate-600 hover:text-slate-900'
              }`}
            >
              <Wallet className="w-4 h-4" />
              <span>Anggaran & Termin</span>
            </button>

            <button
              onClick={() => setActiveTab('rundown')}
              className={`flex items-center gap-2 px-3.5 py-2.5 sm:px-4 rounded-xl text-xs font-bold transition-all shrink-0 ${
                activeTab === 'rundown'
                  ? 'bg-white text-[#d81b60] shadow-sm'
                  : 'text-slate-600 hover:text-slate-900'
              }`}
            >
              <Clock className="w-4 h-4" />
              <span>Rundown & PIC</span>
            </button>

            <button
              onClick={() => setActiveTab('guests')}
              className={`flex items-center gap-2 px-3.5 py-2.5 sm:px-4 rounded-xl text-xs font-bold transition-all shrink-0 ${
                activeTab === 'guests'
                  ? 'bg-white text-[#d81b60] shadow-sm'
                  : 'text-slate-600 hover:text-slate-900'
              }`}
            >
              <Users2 className="w-4 h-4" />
              <span>Tamu & RSVP</span>
            </button>

            <button
              onClick={() => setActiveTab('couple')}
              className={`flex items-center gap-2 px-3.5 py-2.5 sm:px-4 rounded-xl text-xs font-bold transition-all shrink-0 ${
                activeTab === 'couple'
                  ? 'bg-white text-[#d81b60] shadow-sm'
                  : 'text-slate-600 hover:text-slate-900'
              }`}
            >
              <HeartHandshake className="w-4 h-4" />
              <span>Koneksi Pasangan</span>
            </button>
          </div>
        </div>

        {/* Realistic Smartphone Frame (Center Showcase) */}
        <div className="relative max-w-[340px] sm:max-w-[370px] mx-auto">
          {/* Outer Phone Shell */}
          <div className="relative rounded-[48px] p-3.5 bg-slate-900 shadow-2xl shadow-slate-900/25 ring-1 ring-slate-800 border-[3px] border-slate-700/80">
            {/* Dynamic Island / Speaker Notch */}
            <div className="absolute top-6 left-1/2 -translate-x-1/2 w-28 h-5 bg-black rounded-full z-20 flex items-center justify-between px-3">
              <div className="w-2.5 h-2.5 rounded-full bg-slate-900 border border-slate-800" />
              <div className="w-2.5 h-2.5 rounded-full bg-slate-950" />
            </div>

            {/* Inner Screen Canvas */}
            <div className="relative rounded-[36px] bg-[#fff9fa] overflow-hidden min-h-[580px] p-4 text-slate-800 flex flex-col justify-between">
              {/* Screen Status Bar */}
              <div className="flex items-center justify-between text-[11px] font-bold text-slate-400 px-3 pt-1 pb-3">
                <span>09:41</span>
                <span className="flex items-center gap-1.5">
                  <span>5G</span>
                  <span>100%</span>
                </span>
              </div>

              {/* Content Preview based on Active Tab */}
              <div className="flex-1 space-y-3.5 pt-1">
                {/* TAB 1: BUDGET & VENDORS */}
                {activeTab === 'budget' && (
                  <div className="space-y-3 animate-in fade-in duration-300">
                    <div className="p-4 rounded-2xl bg-white border border-slate-100 shadow-sm">
                      <div className="flex items-center justify-between text-xs text-slate-500 mb-1">
                        <span>Total Anggaran Acara</span>
                        <span className="font-bold text-emerald-600">Terbayar 68%</span>
                      </div>
                      <div className="text-2xl font-black text-slate-900">
                        Rp 120.000.000
                      </div>
                      <div className="w-full bg-slate-100 h-2 rounded-full overflow-hidden mt-3">
                        <div className="bg-[#d81b60] h-full rounded-full w-[68%]" />
                      </div>
                      <div className="flex items-center justify-between text-[11px] text-slate-500 mt-2 font-medium">
                        <span>Realisasi: Rp 81.600.000</span>
                        <span>Sisa: Rp 38.400.000</span>
                      </div>
                    </div>

                    {/* Vendor Payment Items */}
                    <div className="text-xs font-bold text-slate-700 px-1 pt-1 flex items-center justify-between">
                      <span>Termin Vendor</span>
                      <span className="text-[#d81b60] font-semibold text-[11px]">8 Vendor</span>
                    </div>

                    <div className="space-y-2">
                      <div className="p-3 rounded-xl bg-white border border-slate-100 flex items-center justify-between shadow-xs">
                        <div className="flex items-center gap-2.5">
                          <div className="w-8 h-8 rounded-lg bg-emerald-50 text-emerald-600 flex items-center justify-center font-bold text-xs">
                            <CheckCircle2 className="w-4 h-4" />
                          </div>
                          <div>
                            <p className="text-xs font-bold text-slate-900">Gedung Puri Ardhya</p>
                            <p className="text-[10px] text-slate-500">Venue & Catering</p>
                          </div>
                        </div>
                        <div className="text-right">
                          <p className="text-xs font-bold text-slate-900">Rp 45.000.000</p>
                          <span className="inline-block text-[9px] font-bold text-emerald-700 bg-emerald-100/70 px-1.5 py-0.5 rounded">
                            LUNAS
                          </span>
                        </div>
                      </div>

                      <div className="p-3 rounded-xl bg-white border border-slate-100 flex items-center justify-between shadow-xs">
                        <div className="flex items-center gap-2.5">
                          <div className="w-8 h-8 rounded-lg bg-amber-50 text-amber-600 flex items-center justify-center font-bold text-xs">
                            <CreditCard className="w-4 h-4" />
                          </div>
                          <div>
                            <p className="text-xs font-bold text-slate-900">Foto & Video (Lumens)</p>
                            <p className="text-[10px] text-slate-500">Dokumentasi</p>
                          </div>
                        </div>
                        <div className="text-right">
                          <p className="text-xs font-bold text-slate-900">Rp 12.000.000</p>
                          <span className="inline-block text-[9px] font-bold text-amber-700 bg-amber-100/70 px-1.5 py-0.5 rounded">
                            DP 50%
                          </span>
                        </div>
                      </div>

                      <div className="p-3 rounded-xl bg-white border border-slate-100 flex items-center justify-between shadow-xs">
                        <div className="flex items-center gap-2.5">
                          <div className="w-8 h-8 rounded-lg bg-rose-50 text-rose-600 flex items-center justify-center font-bold text-xs">
                            <Sparkles className="w-4 h-4" />
                          </div>
                          <div>
                            <p className="text-xs font-bold text-slate-900">Dekorasi Pelaminan</p>
                            <p className="text-[10px] text-slate-500">Mawar Sakral Decor</p>
                          </div>
                        </div>
                        <div className="text-right">
                          <p className="text-xs font-bold text-slate-900">Rp 20.000.000</p>
                          <span className="inline-block text-[9px] font-bold text-rose-700 bg-rose-100/70 px-1.5 py-0.5 rounded">
                            BELUM BAYAR
                          </span>
                        </div>
                      </div>
                    </div>
                  </div>
                )}

                {/* TAB 2: RUNDOWN & PIC */}
                {activeTab === 'rundown' && (
                  <div className="space-y-3 animate-in fade-in duration-300">
                    <div className="p-3.5 rounded-2xl bg-white border border-slate-100 shadow-sm flex items-center justify-between">
                      <div>
                        <span className="text-[10px] font-bold text-[#d81b60] uppercase">Hari H Pernikahan</span>
                        <h4 className="text-sm font-black text-slate-900">Akad & Resepsi Utama</h4>
                        <p className="text-[11px] text-slate-500">Sabtu, 28 November 2026</p>
                      </div>
                      <div className="text-right text-xs font-bold text-slate-700 bg-slate-50 p-2 rounded-xl">
                        12 Agenda
                      </div>
                    </div>

                    {/* Timeline items */}
                    <div className="space-y-2.5 pt-1">
                      <div className="p-3 rounded-xl bg-white border-l-4 border-l-[#d81b60] border border-slate-100 shadow-xs">
                        <div className="flex items-center justify-between mb-1">
                          <span className="text-xs font-bold text-[#d81b60]">07:30 - 08:30 WIB</span>
                          <span className="text-[10px] font-bold bg-slate-100 text-slate-700 px-2 py-0.5 rounded-md">
                            Akad Nikah
                          </span>
                        </div>
                        <p className="text-xs font-bold text-slate-900">Ijab Qabul & Doa Bersama</p>
                        <p className="text-[10px] text-slate-500 mt-1 flex items-center gap-1.5">
                          <PhoneCall className="w-3 h-3 text-[#d81b60]" />
                          <span>PIC: Dimas Wicaksono (Keluarga CPP)</span>
                        </p>
                      </div>

                      <div className="p-3 rounded-xl bg-white border-l-4 border-l-amber-500 border border-slate-100 shadow-xs">
                        <div className="flex items-center justify-between mb-1">
                          <span className="text-xs font-bold text-amber-600">08:30 - 09:30 WIB</span>
                          <span className="text-[10px] font-bold bg-slate-100 text-slate-700 px-2 py-0.5 rounded-md">
                            Adat
                          </span>
                        </div>
                        <p className="text-xs font-bold text-slate-900">Sungkeman & Foto Keluarga Inti</p>
                        <p className="text-[10px] text-slate-500 mt-1 flex items-center gap-1.5">
                          <PhoneCall className="w-3 h-3 text-amber-600" />
                          <span>PIC: Rina Maharani (WO Lead)</span>
                        </p>
                      </div>

                      <div className="p-3 rounded-xl bg-white border-l-4 border-l-emerald-500 border border-slate-100 shadow-xs">
                        <div className="flex items-center justify-between mb-1">
                          <span className="text-xs font-bold text-emerald-600">11:00 - 13:00 WIB</span>
                          <span className="text-[10px] font-bold bg-slate-100 text-slate-700 px-2 py-0.5 rounded-md">
                            Resepsi
                          </span>
                        </div>
                        <p className="text-xs font-bold text-slate-900">Resepsi Sesi 1 & Ramah Tamah</p>
                        <p className="text-[10px] text-slate-500 mt-1 flex items-center gap-1.5">
                          <PhoneCall className="w-3 h-3 text-emerald-600" />
                          <span>PIC: Panitia Konsumsi & Penerima Tamu</span>
                        </p>
                      </div>
                    </div>
                  </div>
                )}

                {/* TAB 3: GUESTS & RSVP */}
                {activeTab === 'guests' && (
                  <div className="space-y-3 animate-in fade-in duration-300">
                    <div className="grid grid-cols-3 gap-2 text-center">
                      <div className="p-3 rounded-2xl bg-white border border-slate-100 shadow-xs">
                        <span className="text-[10px] font-semibold text-slate-400 block">Total Tamu</span>
                        <span className="text-base font-black text-slate-900">350</span>
                      </div>
                      <div className="p-3 rounded-2xl bg-white border border-slate-100 shadow-xs">
                        <span className="text-[10px] font-semibold text-emerald-600 block">Hadir</span>
                        <span className="text-base font-black text-emerald-600">284</span>
                      </div>
                      <div className="p-3 rounded-2xl bg-white border border-slate-100 shadow-xs">
                        <span className="text-[10px] font-semibold text-amber-600 block">Ragu-ragu</span>
                        <span className="text-base font-black text-amber-600">42</span>
                      </div>
                    </div>

                    <div className="text-xs font-bold text-slate-700 px-1 pt-1 flex items-center justify-between">
                      <span>Daftar Undangan VIP & Keluarga</span>
                      <span className="text-[#d81b60] font-semibold text-[11px]">Export CSV</span>
                    </div>

                    <div className="space-y-2">
                      <div className="p-3 rounded-xl bg-white border border-slate-100 flex items-center justify-between shadow-xs">
                        <div>
                          <p className="text-xs font-bold text-slate-900">Prof. Dr. Bambang Sudiro</p>
                          <p className="text-[10px] text-slate-500">Tamu VIP CPP • 2 Orang</p>
                        </div>
                        <span className="text-[9px] font-bold text-emerald-700 bg-emerald-100/70 px-2 py-0.5 rounded">
                          Hadir
                        </span>
                      </div>

                      <div className="p-3 rounded-xl bg-white border border-slate-100 flex items-center justify-between shadow-xs">
                        <div>
                          <p className="text-xs font-bold text-slate-900">Keluarga Besar dr. Sarah</p>
                          <p className="text-[10px] text-slate-500">Keluarga CPW • 4 Orang</p>
                        </div>
                        <span className="text-[9px] font-bold text-emerald-700 bg-emerald-100/70 px-2 py-0.5 rounded">
                          Hadir
                        </span>
                      </div>

                      <div className="p-3 rounded-xl bg-white border border-slate-100 flex items-center justify-between shadow-xs">
                        <div>
                          <p className="text-xs font-bold text-slate-900">Rizky Ananda & Partner</p>
                          <p className="text-[10px] text-slate-500">Sahabat Kuliah • 2 Orang</p>
                        </div>
                        <span className="text-[9px] font-bold text-amber-700 bg-amber-100/70 px-2 py-0.5 rounded">
                          Belum Konfirmasi
                        </span>
                      </div>
                    </div>
                  </div>
                )}

                {/* TAB 4: COUPLE SYNC */}
                {activeTab === 'couple' && (
                  <div className="space-y-3.5 animate-in fade-in duration-300">
                    <div className="p-4 rounded-2xl bg-gradient-to-br from-[#ffd9e2]/50 via-white to-[#fdf0de]/50 border border-[#ffd9e2] text-center shadow-xs">
                      <div className="w-10 h-10 rounded-full bg-[#d81b60] text-white mx-auto flex items-center justify-center mb-2 shadow-sm">
                        <HeartHandshake className="w-5 h-5" />
                      </div>
                      <h4 className="text-xs font-black text-slate-900 uppercase tracking-wide">
                        Status Terhubung
                      </h4>
                      <p className="text-[11px] text-slate-600 mt-0.5">
                        Rivaldi (CPP) & Annisa (CPW)
                      </p>
                      <div className="mt-3 p-2 bg-white rounded-xl border border-slate-200/80 inline-flex items-center gap-2">
                        <span className="text-[10px] text-slate-400 font-semibold">Kode Unik:</span>
                        <span className="text-xs font-mono font-black text-[#d81b60] tracking-wider">
                          NK-8X2P99
                        </span>
                      </div>
                    </div>

                    <div className="p-3 rounded-xl bg-white border border-slate-100 shadow-xs space-y-2">
                      <p className="text-xs font-bold text-slate-900 flex items-center gap-1.5">
                        <UserCheck className="w-3.5 h-3.5 text-emerald-600" />
                        <span>Sinkronisasi Otomatis 2 Arah</span>
                      </p>
                      <p className="text-[11px] text-slate-600 leading-relaxed">
                        Setiap perubahan anggaran, penambahan checklist, dan status tamu yang diedit salah satu pihak akan langsung terupdate di layar pasangan seketika.
                      </p>
                    </div>
                  </div>
                )}
              </div>

              {/* Bottom In-App Nav Bar */}
              <div className="pt-3 border-t border-slate-200/70 flex items-center justify-around text-slate-400">
                <div className="flex flex-col items-center text-[#d81b60]">
                  <Wallet className="w-4 h-4" />
                  <span className="text-[9px] font-bold mt-0.5">Anggaran</span>
                </div>
                <div className="flex flex-col items-center">
                  <Clock className="w-4 h-4" />
                  <span className="text-[9px] font-medium mt-0.5">Rundown</span>
                </div>
                <div className="flex flex-col items-center">
                  <Users2 className="w-4 h-4" />
                  <span className="text-[9px] font-medium mt-0.5">Tamu</span>
                </div>
                <div className="flex flex-col items-center">
                  <Gift className="w-4 h-4" />
                  <span className="text-[9px] font-medium mt-0.5">Seserahan</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}

