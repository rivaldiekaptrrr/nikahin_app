import React from 'react';
import Image from 'next/image';
import ScrollReveal from './ScrollReveal';
import { Sparkles, Smartphone, HeartHandshake } from 'lucide-react';
import DeviceCta from './DeviceCta';
import { ReleaseMetadata } from '@/lib/github-release';

interface FinalCtaSectionProps {
  release: ReleaseMetadata;
}

export default function FinalCtaSection({ release }: FinalCtaSectionProps) {
  return (
    <section className="py-20 md:py-28 relative overflow-hidden">
      <div className="max-w-5xl mx-auto px-4 sm:px-6">
        <ScrollReveal>
          <div className="relative rounded-3xl bg-white border border-[#1f1b16]/10 p-8 sm:p-12 md:p-16 text-center shadow-[0_8px_30px_-8px_rgba(28,25,23,0.06)] overflow-hidden">
          {/* Subtle Floating Organic Accents */}
          <div className="absolute top-6 left-6 pointer-events-none select-none z-0 animate-float-slow">
            <Image
              src="/assets/editorial/petal-jasmine.svg"
              alt=""
              width={40}
              height={40}
              className="w-6 h-6 sm:w-9 sm:h-9 opacity-70 rotate-12"
            />
          </div>
          <div className="absolute bottom-6 right-6 pointer-events-none select-none z-0 animate-float-reverse">
            <Image
              src="/assets/editorial/leaf-green.svg"
              alt=""
              width={44}
              height={44}
              className="w-7 h-7 sm:w-10 sm:h-10 opacity-75 -rotate-45"
            />
          </div>
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
            <p className="text-xs font-medium text-stone-600 mb-3">
              Langkah awal menuju pelaminan
            </p>

            {/* Headline */}
            <h2 className="text-3xl sm:text-4xl md:text-5xl font-semibold text-stone-900 tracking-tight leading-[1.18] mb-4">
              Mulai rencanakan hari bahagiamu berdua
            </h2>

            {/* Subtitle */}
            <p className="text-sm sm:text-base text-stone-600 leading-relaxed font-normal mb-8 max-w-xl mx-auto">
              Tak perlu lagi pusing mencatat rincian biaya di banyak tempat. Buka Nikahin di Android atau iPhone, sambungkan akun dengan pasangan, dan siapkan pernikahan impianmu dengan tenang.
            </p>

            {/* Adaptive CTA */}
            <div className="mb-8">
              <DeviceCta release={release} />
            </div>

            {/* Trust Points */}
            <div className="pt-6 border-t border-[#1f1b16]/8 flex flex-wrap items-center justify-center gap-y-2 gap-x-6 text-xs text-stone-600 font-medium">
              <span className="flex items-center gap-1.5">
                <Smartphone className="w-4 h-4 text-stone-600" />
                Tersedia untuk Android & iPhone
              </span>
              <span className="flex items-center gap-1.5">
                <HeartHandshake className="w-4 h-4 text-emerald-600" />
                Otomatis tersambung di ponsel berdua
              </span>
              <span className="flex items-center gap-1.5">
                <Sparkles className="w-4 h-4 text-amber-600" />
                Sekali bayar, aktif selamanya
              </span>
            </div>
          </div>
        </div>
      </ScrollReveal>
    </div>
  </section>
);
}
