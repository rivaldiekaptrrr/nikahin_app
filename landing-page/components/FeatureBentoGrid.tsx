import React from 'react';
import Image from 'next/image';
import {
  Wallet,
  Clock,
  Users2,
  FileCheck2,
  Gift,
  Building2,
  CheckCircle,
} from 'lucide-react';

export default function FeatureBentoGrid() {
  return (
    <section id="fitur" className="py-20 md:py-28 relative border-y border-[#1f1b16]/8">
      <div className="max-w-6xl mx-auto px-4 sm:px-6">
        {/* Section Header */}
        <div className="text-center max-w-2xl mx-auto mb-16">
          <p className="text-xs font-medium text-stone-600 mb-2">
            Fitur lengkap Nikahin
          </p>
          <h2 className="text-3xl sm:text-4xl font-semibold text-stone-900 tracking-tight">
            Semua yang kamu butuhkan, dalam satu aplikasi
          </h2>
          <p className="text-stone-600 text-sm sm:text-base mt-3">
            Bebas dari spreadsheet rumit atau catatan terpisah di WhatsApp. Rencanakan hari bahagia berdua dengan tenang.
          </p>
        </div>

        {/* Bento Grid Container */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-5">
          {/* CARD 1: ANGGARAN & TERMIN VENDOR (Wide 2-col on Desktop, Stacked on Mobile) */}
          <div className="p-6 sm:p-7 rounded-2xl bg-white border border-[#1f1b16]/8 shadow-[0_4px_16px_-4px_rgba(28,25,23,0.05)] hover:border-[#1f1b16]/18 transition-all md:col-span-2 flex flex-col justify-between">
            <div>
              <div className="flex items-center justify-between mb-4">
                <div className="w-10 h-10 rounded-xl bg-stone-100 border border-[#1f1b16]/6 text-stone-800 flex items-center justify-center">
                  <Wallet className="w-5 h-5 text-stone-700" />
                </div>
                <span className="text-xs font-medium text-stone-500 bg-stone-100/70 px-2.5 py-1 rounded-full">
                  Anggaran Jelas
                </span>
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-12 gap-5 items-center">
                <div className="sm:col-span-7">
                  <h3 className="text-lg sm:text-xl font-semibold text-stone-900 mb-2">
                    Manajemen Anggaran &amp; Termin Vendor
                  </h3>
                  <p className="text-xs sm:text-sm text-stone-600 leading-relaxed mb-4">
                    Pantau setiap rupiah pengeluaran pernikahan berdua secara transparan. Catat uang muka (DP), jadwal pelunasan bertahap, hingga sisa tagihan vendor agar tidak terjadi *overbudget*.
                  </p>
                  <div className="flex flex-wrap items-center gap-2 text-xs font-medium text-stone-600">
                    <span className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-lg bg-emerald-50 text-emerald-700 border border-emerald-200/60">
                      <span className="w-1.5 h-1.5 rounded-full bg-emerald-600" />
                      Status Lunas
                    </span>
                    <span className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-lg bg-amber-50 text-amber-700 border border-amber-200/60">
                      <span className="w-1.5 h-1.5 rounded-full bg-amber-600" />
                      Termin DP
                    </span>
                    <span className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-lg bg-rose-50 text-rose-700 border border-rose-200/60">
                      <span className="w-1.5 h-1.5 rounded-full bg-rose-600" />
                      Belum Bayar
                    </span>
                  </div>
                </div>

                <div className="sm:col-span-5">
                  <div className="relative h-44 sm:h-48 w-full rounded-xl overflow-hidden border border-[#1f1b16]/8 shadow-xs">
                    <Image
                      src="/assets/editorial/wedding-rings.jpg"
                      alt="Detail Cincin Kawin & Anggaran Nikahin"
                      fill
                      sizes="(max-width: 640px) 100vw, 300px"
                      className="object-cover"
                    />
                    <div className="absolute inset-0 bg-gradient-to-t from-stone-900/60 via-transparent to-transparent flex items-end p-3">
                      <span className="text-[11px] font-medium text-white/95">
                        Alokasi pos biaya transparan
                      </span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          {/* CARD 2: VENDOR & VENUE IMPIAN (1-col) */}
          <div className="p-6 sm:p-7 rounded-2xl bg-white border border-[#1f1b16]/8 shadow-[0_4px_16px_-4px_rgba(28,25,23,0.05)] hover:border-[#1f1b16]/18 transition-all flex flex-col justify-between">
            <div>
              <div className="relative h-36 w-full rounded-xl overflow-hidden border border-[#1f1b16]/8 mb-4 shadow-xs">
                <Image
                  src="/assets/editorial/wedding-venue.jpg"
                  alt="Gedung & Dekorasi Pernikahan"
                  fill
                  sizes="(max-width: 640px) 100vw, 350px"
                  className="object-cover"
                />
              </div>

              <div className="flex items-center justify-between mb-3">
                <div className="w-9 h-9 rounded-xl bg-stone-100 border border-[#1f1b16]/6 text-stone-800 flex items-center justify-center">
                  <Building2 className="w-4.5 h-4.5 text-stone-700" />
                </div>
                <span className="text-xs font-medium text-stone-500 bg-stone-100/70 px-2.5 py-1 rounded-full">
                  Venue &amp; Vendor
                </span>
              </div>

              <h3 className="text-base sm:text-lg font-semibold text-stone-900 mb-1.5">
                Kurasi Vendor &amp; Gedung Impian
              </h3>
              <p className="text-xs sm:text-sm text-stone-600 leading-relaxed">
                Kelola kontak WO, katering, fotografer, dekorasi, hingga perias pengantin lengkap dengan tautan portofolio dan catatan negosiasi.
              </p>
            </div>
          </div>

          {/* CARD 3: SUSUNAN ACARA (RUNDOWN) & PIC (1-col) */}
          <div className="p-6 sm:p-7 rounded-2xl bg-white border border-[#1f1b16]/8 shadow-[0_4px_16px_-4px_rgba(28,25,23,0.05)] hover:border-[#1f1b16]/18 transition-all flex flex-col justify-between">
            <div>
              <div className="flex items-center justify-between mb-4">
                <div className="w-9 h-9 rounded-xl bg-stone-100 border border-[#1f1b16]/6 text-stone-800 flex items-center justify-center">
                  <Clock className="w-4.5 h-4.5 text-stone-700" />
                </div>
                <span className="text-xs font-medium text-stone-500 bg-stone-100/70 px-2.5 py-1 rounded-full">
                  Hari H Lancar
                </span>
              </div>

              <h3 className="text-base sm:text-lg font-semibold text-stone-900 mb-1.5">
                Susunan Acara (Rundown) &amp; PIC
              </h3>
              <p className="text-xs sm:text-sm text-stone-600 leading-relaxed mb-4">
                Jadwalkan setiap menit acara akad dan resepsi dengan penanggung jawab (PIC) serta nomor kontak darurat keluarga agar hari H berjalan tertib.
              </p>
            </div>

            <div className="space-y-2 pt-2 border-t border-[#1f1b16]/6">
              <div className="p-2.5 rounded-xl bg-stone-50 border border-[#1f1b16]/6 flex items-center justify-between text-xs">
                <span className="font-semibold text-stone-800">07:30 • Akad Nikah</span>
                <span className="text-[11px] text-stone-500">Keluarga CPP</span>
              </div>
              <div className="p-2.5 rounded-xl bg-stone-50 border border-[#1f1b16]/6 flex items-center justify-between text-xs">
                <span className="font-semibold text-stone-800">11:00 • Resepsi Sesi 1</span>
                <span className="text-[11px] text-stone-500">WO Lead &amp; Panitia</span>
              </div>
            </div>
          </div>

          {/* CARD 4: BUKU TAMU, VIP & RSVP (1-col) */}
          <div className="p-6 sm:p-7 rounded-2xl bg-white border border-[#1f1b16]/8 shadow-[0_4px_16px_-4px_rgba(28,25,23,0.05)] hover:border-[#1f1b16]/18 transition-all flex flex-col justify-between">
            <div>
              <div className="relative h-36 w-full rounded-xl overflow-hidden border border-[#1f1b16]/8 mb-4 shadow-xs">
                <Image
                  src="/assets/editorial/wedding-banquet.jpg"
                  alt="Meja Resepsi Tamu Undangan"
                  fill
                  sizes="(max-width: 640px) 100vw, 350px"
                  className="object-cover"
                />
              </div>

              <div className="flex items-center justify-between mb-3">
                <div className="w-9 h-9 rounded-xl bg-stone-100 border border-[#1f1b16]/6 text-stone-800 flex items-center justify-center">
                  <Users2 className="w-4.5 h-4.5 text-stone-700" />
                </div>
                <span className="text-xs font-medium text-stone-500 bg-stone-100/70 px-2.5 py-1 rounded-full">
                  Manajemen Undangan
                </span>
              </div>

              <h3 className="text-base sm:text-lg font-semibold text-stone-900 mb-1.5">
                Buku Tamu, VIP &amp; RSVP
              </h3>
              <p className="text-xs sm:text-sm text-stone-600 leading-relaxed">
                Kelola ratusan undangan dengan klasifikasi keluarga kedua pihak dan tamu VIP. Ekspor daftar tamu ke format CSV kapan pun dibutuhkan panitia.
              </p>
            </div>
          </div>

          {/* CARD 5: CHECKLIST HANTARAN & SESERAHAN (1-col) */}
          <div className="p-6 sm:p-7 rounded-2xl bg-white border border-[#1f1b16]/8 shadow-[0_4px_16px_-4px_rgba(28,25,23,0.05)] hover:border-[#1f1b16]/18 transition-all flex flex-col justify-between">
            <div>
              <div className="relative h-36 w-full rounded-xl overflow-hidden border border-[#1f1b16]/8 mb-4 shadow-xs">
                <Image
                  src="/assets/editorial/wedding-bouquet.jpg"
                  alt="Detail Seserahan & Buket Pengantin"
                  fill
                  sizes="(max-width: 640px) 100vw, 350px"
                  className="object-cover"
                />
              </div>

              <div className="flex items-center justify-between mb-3">
                <div className="w-9 h-9 rounded-xl bg-stone-100 border border-[#1f1b16]/6 text-stone-800 flex items-center justify-center">
                  <Gift className="w-4.5 h-4.5 text-stone-700" />
                </div>
                <span className="text-xs font-medium text-stone-500 bg-stone-100/70 px-2.5 py-1 rounded-full">
                  Tradisi &amp; Adat
                </span>
              </div>

              <h3 className="text-base sm:text-lg font-semibold text-stone-900 mb-1.5">
                Checklist Hantaran &amp; Seserahan
              </h3>
              <p className="text-xs sm:text-sm text-stone-600 leading-relaxed">
                Daftar barang seserahan adat, mahar, dan hantaran lengkap dengan status packing siap antar serta penanggung jawab pembawa barang.
              </p>
            </div>
          </div>

          {/* CARD 6: DAFTAR SYARAT DOKUMEN KUA & SIPIL (Wide 3-col on Desktop, Stacked on Mobile) */}
          <div className="p-6 sm:p-8 rounded-2xl bg-white border border-[#1f1b16]/8 shadow-[0_4px_16px_-4px_rgba(28,25,23,0.05)] hover:border-[#1f1b16]/18 transition-all md:col-span-3">
            <div className="grid grid-cols-1 md:grid-cols-12 gap-6 items-center">
              <div className="md:col-span-7 space-y-4">
                <div className="flex items-center gap-2">
                  <div className="w-9 h-9 rounded-xl bg-stone-100 border border-[#1f1b16]/6 text-stone-800 flex items-center justify-center shrink-0">
                    <FileCheck2 className="w-4.5 h-4.5 text-stone-700" />
                  </div>
                  <span className="text-xs font-medium text-stone-500 bg-stone-100/70 px-2.5 py-1 rounded-full">
                    Dokumen KUA &amp; Sipil
                  </span>
                </div>

                <div>
                  <h3 className="text-lg sm:text-xl font-semibold text-stone-900 mb-2">
                    Panduan Lengkap Syarat Berkas KUA &amp; Catatan Sipil
                  </h3>
                  <p className="text-xs sm:text-sm text-stone-600 leading-relaxed">
                    Panduan resmi alur dokumen pernikahan di Indonesia: mulai dari surat pengantar kelurahan (N1-N4), pemeriksaan kesehatan calon pengantin, hingga kelengkapan berkas wali nikah dan saksi.
                  </p>
                </div>

                <div className="pt-2 flex flex-wrap items-center gap-x-5 gap-y-2 text-xs text-stone-700 font-medium">
                  <span className="flex items-center gap-1.5">
                    <CheckCircle className="w-4 h-4 text-emerald-600 shrink-0" />
                    Surat pengantar RT/RW &amp; kelurahan (N1-N4)
                  </span>
                  <span className="flex items-center gap-1.5">
                    <CheckCircle className="w-4 h-4 text-emerald-600 shrink-0" />
                    Pemeriksaan kesehatan &amp; suntik TT
                  </span>
                  <span className="flex items-center gap-1.5">
                    <CheckCircle className="w-4 h-4 text-emerald-600 shrink-0" />
                    Dokumen wali nikah, saksi &amp; dispensasi
                  </span>
                </div>
              </div>

              <div className="md:col-span-5">
                <div className="relative h-48 sm:h-56 w-full rounded-2xl overflow-hidden border border-[#1f1b16]/10 shadow-xs">
                  <Image
                    src="/assets/editorial/wedding-couple-indo.jpg"
                    alt="Mempelai Akad Nikah Indonesia Resmi KUA"
                    fill
                    sizes="(max-width: 640px) 100vw, 450px"
                    className="object-cover object-top"
                  />
                  <div className="absolute inset-0 bg-gradient-to-t from-stone-950/70 via-stone-950/20 to-transparent flex items-end p-4">
                    <p className="text-xs font-medium text-white/95 leading-snug">
                      Persiapan berkas akad nikah resmi jadi lebih tenang dan runtut.
                    </p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
