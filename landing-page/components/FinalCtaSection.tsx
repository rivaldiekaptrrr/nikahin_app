import React from 'react';
import Image from 'next/image';
import { Sparkles, Smartphone, HeartHandshake } from 'lucide-react';
import DeviceCta from './DeviceCta';
import { ReleaseMetadata } from '@/lib/github-release';

interface FinalCtaSectionProps {
  release: ReleaseMetadata;
}

export default function FinalCtaSection({ release }: FinalCtaSectionProps) {
  return (
    <section className="py-20 md:py-28 bg-white relative overflow-hidden">
      <div className="max-w-5xl mx-auto px-4 sm:px-6">
        <div className="relative rounded-[36px] bg-gradient-to-br from-[#ffd9e2]/40 via-[#fff9fa] to-[#fdf0de]/60 border border-[#ffd9e2]/80 p-8 sm:p-12 md:p-16 text-center shadow-xs overflow-hidden">
          {/* Subtle Ambient Backing */}
          <div className="absolute -top-24 -left-24 w-72 h-72 bg-[#ffd9e2]/40 rounded-full blur-3xl pointer-events-none" />
          <div className="absolute -bottom-24 -right-24 w-72 h-72 bg-[#fdf0de]/50 rounded-full blur-3xl pointer-events-none" />

          <div className="relative z-10 max-w-2xl mx-auto">
            {/* Logo Icon */}
            <div className="relative w-14 h-14 mx-auto mb-6">
              <Image
                src="/assets/nikahin-symbol-master-512.png"
                alt="Logo Simbol Nikahin"
                width={56}
                height={56}
                className="object-contain"
              />
            </div>

            {/* Editorial Eyebrow */}
            <p className="text-xs font-bold uppercase tracking-wider text-[#ad1457] mb-3">
              Langkah Awal Menuju Pelaminan
            </p>

            {/* Headline */}
            <h2 className="text-3xl sm:text-4xl md:text-5xl font-black text-slate-900 tracking-tight leading-[1.18] mb-4">
              Mulai Rencanakan Hari Bahagiamu Berdua
            </h2>

            {/* Subtitle */}
            <p className="text-sm sm:text-base text-slate-600 leading-relaxed font-normal mb-8 max-w-xl mx-auto">
              Tak perlu lagi pusing mencatat rincian biaya di banyak tempat. Buka Nikahin di Android atau iPhone, sambungkan akun dengan pasangan, dan siapkan pernikahan impianmu dengan tenang.
            </p>

            {/* Adaptive CTA */}
            <div className="mb-8">
              <DeviceCta release={release} />
            </div>

            {/* Trust Points */}
            <div className="pt-6 border-t border-slate-200/60 flex flex-wrap items-center justify-center gap-y-2 gap-x-6 text-xs text-slate-600 font-medium">
              <span className="flex items-center gap-1.5">
                <Smartphone className="w-4 h-4 text-[#d81b60]" />
                Tersedia untuk Android & iPhone
              </span>
              <span className="flex items-center gap-1.5">
                <HeartHandshake className="w-4 h-4 text-emerald-600" />
                Otomatis tersambung di HP berdua
              </span>
              <span className="flex items-center gap-1.5">
                <Sparkles className="w-4 h-4 text-amber-500" />
                Akses selamanya tanpa langganan
              </span>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
