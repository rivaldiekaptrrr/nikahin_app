import React from 'react';
import { Heart, ShieldCheck, Users, Sparkles } from 'lucide-react';
import DeviceCta from './DeviceCta';
import { ReleaseMetadata } from '@/lib/github-release';

interface HeroSectionProps {
  release: ReleaseMetadata;
}

export default function HeroSection({ release }: HeroSectionProps) {
  return (
    <section id="hero" className="relative pt-28 pb-16 md:pt-36 md:pb-24">
      <div className="max-w-4xl mx-auto px-4 sm:px-6 text-center">
        {/* Editorial Eyebrow (Quiet, Sentence Case) */}
        <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-stone-200/50 text-xs font-medium text-stone-700 mb-6">
          <Heart className="w-3.5 h-3.5 fill-[#d81b60] text-[#d81b60]" />
          <span>Perencana pernikahan bersama pasangan</span>
        </div>

        {/* Main Headline (Solid Ink, Weight 600, Confident & Restrained) */}
        <h1 className="text-4xl sm:text-5xl md:text-6xl font-semibold text-stone-900 tracking-tight leading-[1.15] mb-6">
          Catat anggaran bersama, wujudkan pernikahan impian dengan tenang
        </h1>

        {/* Subtitle (Warm Neutral Secondary Text) */}
        <p className="text-base sm:text-lg text-stone-600 max-w-2xl mx-auto font-normal leading-relaxed mb-10">
          Kelola rincian biaya, vendor, susunan acara, buku tamu, hingga berkas KUA dalam satu aplikasi terpadu yang langsung terhubung di ponsel berdua.
        </p>

        {/* Interactive Device Adaptive CTA */}
        <div className="mb-12">
          <DeviceCta release={release} />
        </div>

        {/* 3 Key Trust Signals (Hairline Border & Calibrated Spacing) */}
        <div className="pt-6 border-t border-[#1f1b16]/10 flex flex-wrap items-center justify-center gap-y-3 gap-x-8 text-xs font-medium text-stone-600">
          <div className="flex items-center gap-2">
            <Users className="w-4 h-4 text-stone-500" />
            <span>Cukup 1 akun untuk berdua</span>
          </div>
          <div className="flex items-center gap-2">
            <ShieldCheck className="w-4 h-4 text-emerald-600" />
            <span>Otomatis tersambung di ponsel pasangan</span>
          </div>
          <div className="flex items-center gap-2">
            <Sparkles className="w-4 h-4 text-amber-600" />
            <span>Sekali bayar, aktif selamanya</span>
          </div>
        </div>
      </div>
    </section>
  );
}

