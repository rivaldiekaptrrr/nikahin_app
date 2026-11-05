import React from 'react';
import {
  Wallet,
  Clock,
  Users2,
  FileCheck2,
  Gift,
  Shirt,
  CheckCircle,
} from 'lucide-react';

export default function FeatureBentoGrid() {
  const features = [
    {
      icon: Wallet,
      title: 'Manajemen Anggaran & Termin Vendor',
      desc: 'Pantau setiap pengeluaran pernikahan dengan jelas. Catat DP, pelunasan, hingga sisa tagihan vendor agar tidak overbudget.',
      tag: 'Anggaran Jelas',
      colSpan: 'md:col-span-2',
      highlight: true,
    },
    {
      icon: Clock,
      title: 'Susunan Acara (Rundown) & PIC',
      desc: 'Jadwalkan setiap menit acara akad dan resepsi dengan penanggung jawab (PIC) serta nomor kontak darurat keluarga.',
      tag: 'Hari H Lancar',
      colSpan: 'md:col-span-1',
    },
    {
      icon: Users2,
      title: 'Buku Tamu, VIP, & RSVP',
      desc: 'Kelola ratusan undangan dengan pengelompokan keluarga kedua pihak dan tamu VIP. Ekspor daftar tamu ke format CSV kapan saja.',
      tag: 'Manajemen Undangan',
      colSpan: 'md:col-span-1',
    },
    {
      icon: Shirt,
      title: 'Kepanitiaan & Distribusi Seragam',
      desc: 'Bagi tugas panitia keluarga dan catat pembagian bahan kain atau seragam serasi tanpa ada yang terlewat.',
      tag: 'Keluarga Kompak',
      colSpan: 'md:col-span-1',
    },
    {
      icon: Gift,
      title: 'Checklist Hantaran & Seserahan',
      desc: 'Daftar barang seserahan adat dan hantaran pengantin lengkap dengan status packing siap antar.',
      tag: 'Tradisi & Adat',
      colSpan: 'md:col-span-1',
    },
    {
      icon: FileCheck2,
      title: 'Daftar Syarat Berkas KUA & Catatan Sipil',
      desc: 'Panduan lengkap syarat dokumen nikah resmi KUA dan Catatan Sipil agar pengurusan berkas pernikahan beres tanpa bingung.',
      tag: 'Dokumen KUA & Sipil',
      colSpan: 'md:col-span-3',
      wide: true,
    },
  ];

  return (
    <section id="fitur" className="py-20 md:py-28 bg-[#fff9fa]/60 border-y border-slate-200/50">
      <div className="max-w-6xl mx-auto px-4 sm:px-6">
        <div className="text-center max-w-2xl mx-auto mb-16">
          <p className="text-xs font-bold uppercase tracking-wider text-[#d81b60] mb-2.5">
            Fitur Lengkap Nikahin
          </p>
          <h2 className="text-3xl sm:text-4xl font-extrabold text-slate-900 tracking-tight">
            Semua yang Kamu Butuhkan, Dalam Satu Aplikasi
          </h2>
          <p className="text-slate-600 text-sm sm:text-base mt-3">
            Bebas dari spreadsheet yang berantakan atau catatan terpisah di WhatsApp.
          </p>
        </div>

        {/* Bento Grid Container */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-5">
          {features.map((f, idx) => {
            const IconComponent = f.icon;
            return (
              <div
                key={idx}
                className={`p-7 rounded-3xl bg-white border border-slate-200/70 shadow-xs hover:shadow-md hover:border-[#ffd9e2] transition-all flex flex-col justify-between ${f.colSpan}`}
              >
                <div>
                  <div className="flex items-center justify-between mb-5">
                    <div className="w-12 h-12 rounded-2xl bg-[#ffd9e2]/40 text-[#d81b60] flex items-center justify-center">
                      <IconComponent className="w-6 h-6" />
                    </div>
                    <span className="text-xs font-bold tracking-wider text-[#ad1457] uppercase">
                      {f.tag}
                    </span>
                  </div>

                  <h3 className="text-lg font-bold text-slate-900 mb-2">
                    {f.title}
                  </h3>
                  <p className="text-xs sm:text-sm text-slate-600 leading-relaxed">
                    {f.desc}
                  </p>
                </div>

                {f.wide && (
                  <div className="mt-6 pt-5 border-t border-slate-100 flex flex-wrap items-center gap-x-6 gap-y-2 text-xs text-slate-600 font-medium">
                    <span className="flex items-center gap-1.5">
                      <CheckCircle className="w-4 h-4 text-emerald-600" />
                      Surat Pengantar RT/RW & Kelurahan
                    </span>
                    <span className="flex items-center gap-1.5">
                      <CheckCircle className="w-4 h-4 text-emerald-600" />
                      Pemeriksaan Kesehatan & Suntik TT
                    </span>
                    <span className="flex items-center gap-1.5">
                      <CheckCircle className="w-4 h-4 text-emerald-600" />
                      Berkas Wali Nikah & Saksi
                    </span>
                  </div>
                )}
              </div>
            );
          })}
        </div>
      </div>
    </section>
  );
}

