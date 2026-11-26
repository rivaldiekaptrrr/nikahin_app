import React from 'react';
import ScrollReveal from './ScrollReveal';
import { Check, Sparkles, ShieldCheck, HeartHandshake, Users } from 'lucide-react';
import DeviceCta from './DeviceCta';
import DynamicPriceDisplay from './DynamicPriceDisplay';
import { ReleaseMetadata } from '@/lib/github-release';

interface PricingSectionProps {
  release: ReleaseMetadata;
}

const PRICING_FEATURES = [
  'Tersambung langsung di HP kamu dan pasangan secara real-time',
  'Catat bujet dan jadwal bayar vendor (uang muka, termin, dan pelunasan)',
  'Susunan acara (rundown) menit demi menit beserta kontak penanggung jawab',
  'Buku tamu digital, pencatatan amplop, serta ekspor daftar tamu ke Excel/CSV',
  'Daftar lengkap syarat KUA dan Catatan Sipil agar tidak ada berkas yang tertinggal',
  'Daftar barang seserahan, status bungkus, dan pembagian hantaran',
  'Cetak Buku Panduan Pernikahan format PDF untuk pegangan keluarga dan vendor',
  'Bebas ganti tema tampilan aplikasi kapan saja sesuai konsep pernikahan kalian',
  'Bebas iklan, aktif tanpa batas waktu, dan bebas biaya bulanan',
];

export default function PricingSection({ release }: PricingSectionProps) {
  return (
    <section id="harga" className="py-12 sm:py-16 md:py-24 relative overflow-hidden">
      <div className="max-w-5xl mx-auto px-4 sm:px-6">
        {/* Section Header - Tampil Langsung Tanpa Tertahan Animasi */}
        <div className="text-center max-w-2xl mx-auto mb-8 sm:mb-12">
          <p className="text-xs font-semibold uppercase tracking-wider text-[#d81b60] mb-2 flex items-center justify-center gap-1.5">
            <Sparkles className="w-3.5 h-3.5 text-amber-500" />
            <span>Sekali Bayar, Bebas Pakai Selamanya</span>
          </p>
          <h2 className="text-2xl sm:text-4xl md:text-5xl font-semibold text-stone-900 tracking-tight leading-[1.18]">
            Satu harga pasti untuk hari bahagiamu berdua
          </h2>
          <p className="text-stone-600 text-xs sm:text-base mt-2.5 sm:mt-3 leading-relaxed">
            Nggak ada tagihan tersembunyi atau biaya perpanjangan. Cukup sekali aktivasi untuk dipakai berdua sampai seluruh rangkaian pernikahan selesai.
          </p>
        </div>

        {/* Lifetime Pricing Card (Featured Luxury Frame) */}
        <ScrollReveal delayMs={100}>
          <div className="relative max-w-3xl mx-auto rounded-3xl bg-white border-2 border-amber-400/50 p-5 sm:p-10 md:p-12 shadow-[0_20px_50px_-12px_rgba(217,119,6,0.12),0_4px_20px_-4px_rgba(28,25,23,0.06)] overflow-hidden">
            {/* Ambient Gold Glow Halo in Background */}
            <div className="absolute top-0 right-0 w-80 h-80 bg-gradient-to-bl from-amber-200/30 via-rose-100/20 to-transparent rounded-full blur-3xl pointer-events-none -z-0" />

            <div className="relative z-10">
              {/* Header: Package Name & Discount Badge */}
              <div className="flex flex-wrap items-center justify-between gap-3 mb-6">
                <div>
                  <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-amber-100/70 border border-amber-300/60 text-xs font-bold text-amber-900 uppercase tracking-wider mb-2">
                    <Sparkles className="w-3.5 h-3.5 text-amber-700" />
                    <span>Akses Sekali Bayar Seumur Hidup</span>
                  </div>
                  <h3 className="text-2xl sm:text-3xl font-bold text-stone-900 tracking-tight">
                    Paket Lengkap Nikahin
                  </h3>
                </div>

                <div className="flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-stone-100 border border-stone-200 text-xs font-medium text-stone-600">
                  <Users className="w-3.5 h-3.5 text-[#d81b60]" />
                  <span>Berlaku untuk 2 Akun (CPP &amp; CPW)</span>
                </div>
              </div>

              {/* Price Highlight Row (Dynamic Pricing & Promo Aware) */}
              <DynamicPriceDisplay />

              {/* Included Features Checklist (2-Column Grid on Tablet/Desktop) */}
              <div className="mb-10">
                <p className="text-xs font-bold uppercase tracking-wider text-stone-500 mb-4">
                  Semua Fasilitas Langsung Aktif:
                </p>
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-3.5">
                  {PRICING_FEATURES.map((feature, idx) => (
                    <div key={idx} className="flex items-start gap-2.5">
                      <div className="w-5 h-5 rounded-full bg-emerald-100 text-emerald-700 flex items-center justify-center shrink-0 mt-0.5">
                        <Check className="w-3.5 h-3.5 stroke-[2.5]" />
                      </div>
                      <span className="text-xs sm:text-sm text-stone-700 leading-snug">
                        {feature}
                      </span>
                    </div>
                  ))}
                </div>
              </div>

              {/* CTA Action Button */}
              <div className="flex flex-col items-center justify-center gap-3 pt-2">
                <DeviceCta release={release} />
                <div className="flex items-center gap-2 text-xs text-stone-500 mt-1">
                  <ShieldCheck className="w-4 h-4 text-emerald-600" />
                  <span>Aktivasi otomatis langsung aktif di kedua ponsel setelah pembayaran</span>
                </div>
              </div>
            </div>
          </div>
        </ScrollReveal>
      </div>
    </section>
  );
}

