import React from 'react';
import { Heart, ShieldCheck, Users, Sparkles } from 'lucide-react';
import DeviceCta from './DeviceCta';
import { ReleaseMetadata } from '@/lib/github-release';

interface HeroSectionProps {
  release: ReleaseMetadata;
}

export default function HeroSection({ release }: HeroSectionProps) {
  return (
    <section className="relative pt-32 pb-16 md:pt-40 md:pb-24 overflow-hidden">
      {/* Background Soft Glow Decoration */}
      <div className="absolute top-1/4 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[600px] h-[350px] bg-gradient-to-tr from-[#ffd9e2]/40 via-[#fdf0de]/50 to-transparent blur-3xl pointer-events-none -z-10" />

      <div className="max-w-4xl mx-auto px-4 sm:px-6 text-center">
        {/* Subtle Brand Eyebrow */}
        <div className="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-[#fdf0de] border border-[#f7e2c4] text-[#ad1457] text-xs font-bold tracking-wide uppercase mb-6 shadow-xs">
          <Heart className="w-3.5 h-3.5 fill-[#d81b60] text-[#d81b60]" />
          <span>Aplikasi Pendamping Pernikahan Modern</span>
        </div>

        {/* Main Headline */}
        <h1 className="text-4xl sm:text-5xl md:text-6xl font-black text-slate-900 tracking-tight leading-[1.12] mb-6">
          Rencanakan Hari Bahagiamu Berdua,{' '}
          <span className="text-transparent bg-clip-text bg-gradient-to-r from-[#d81b60] to-[#ad1457]">
            Lebih Tenang & Rapi
          </span>
        </h1>

        {/* Subtitle */}
        <p className="text-base sm:text-lg text-slate-600 max-w-2xl mx-auto font-normal leading-relaxed mb-9">
          Satu aplikasi lengkap untuk kelola anggaran, vendor, susunan acara,
          buku tamu, hingga berkas KUA. Terhubung langsung dengan akun pasanganmu
          secara real-time.
        </p>

        {/* Interactive Device Adaptive CTA */}
        <div className="mb-12">
          <DeviceCta release={release} />
        </div>

        {/* 3 Key Trust Signals */}
        <div className="pt-6 border-t border-slate-200/60 flex flex-wrap items-center justify-center gap-y-3 gap-x-8 text-xs font-semibold text-slate-600">
          <div className="flex items-center gap-2">
            <Users className="w-4 h-4 text-[#d81b60]" />
            <span>1 Pembelian untuk 2 Akun (CPP & CPW)</span>
          </div>
          <div className="flex items-center gap-2">
            <ShieldCheck className="w-4 h-4 text-emerald-600" />
            <span>Sinkronisasi Cloud Real-Time</span>
          </div>
          <div className="flex items-center gap-2">
            <Sparkles className="w-4 h-4 text-amber-500" />
            <span>Sekali Bayar Tanpa Iuran Bulanan</span>
          </div>
        </div>
      </div>
    </section>
  );
}

