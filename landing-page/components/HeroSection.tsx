import React from 'react';
import Image from 'next/image';
import { Heart, ShieldCheck, Users, Sparkles } from 'lucide-react';
import DeviceCta from './DeviceCta';
import { ReleaseMetadata } from '@/lib/github-release';

interface HeroSectionProps {
  release: ReleaseMetadata;
}

export default function HeroSection({ release }: HeroSectionProps) {
  return (
    <section id="hero" className="relative pt-24 pb-16 md:pt-36 md:pb-24 overflow-hidden">
      {/* Floating Organic Elements (Realistic Depth & Ambient Breeze) */}
      <div className="absolute top-10 left-3 sm:left-8 md:left-12 pointer-events-none select-none z-0 animate-float-slow">
        <Image
          src="/assets/editorial/leaf-green.svg"
          alt="Aksen Daun Melayang"
          width={72}
          height={72}
          className="w-8 h-8 sm:w-12 sm:h-12 md:w-16 md:h-16 opacity-85 -rotate-12"
        />
      </div>

      <div className="absolute top-14 right-4 sm:right-10 md:right-16 pointer-events-none select-none z-0 animate-float-reverse">
        <Image
          src="/assets/editorial/petal-jasmine.svg"
          alt="Aksen Kelopak Melati"
          width={56}
          height={56}
          className="w-7 h-7 sm:w-10 sm:h-10 md:w-12 md:h-12 opacity-80 rotate-45"
        />
      </div>

      <div className="absolute bottom-14 right-3 sm:right-12 md:right-20 pointer-events-none select-none z-0 animate-float-slow">
        <Image
          src="/assets/editorial/petal-blush.svg"
          alt="Aksen Kelopak Mawar"
          width={60}
          height={60}
          className="w-7 h-7 sm:w-11 sm:h-11 md:w-13 md:h-13 opacity-75 -rotate-15"
        />
      </div>

      <div className="max-w-4xl mx-auto px-4 sm:px-6 text-center relative z-10">
        {/* Social Proof & Trust Pill */}
        <div className="inline-flex items-center gap-2.5 px-3 py-1.5 rounded-full bg-white/85 border border-[#1f1b16]/8 shadow-xs text-xs font-medium text-stone-700 mb-6 backdrop-blur-xs">
          <div className="flex -space-x-1.5 overflow-hidden">
            <div className="relative w-5 h-5 rounded-full ring-1.5 ring-white overflow-hidden shrink-0">
              <Image
                src="/assets/editorial/wedding-couple-indo.jpg"
                alt="Pengantin Akad Nikahin"
                fill
                className="object-cover object-top"
              />
            </div>
            <div className="relative w-5 h-5 rounded-full ring-1.5 ring-white overflow-hidden shrink-0">
              <Image
                src="/assets/editorial/wedding-couple.jpg"
                alt="Pasangan Bahagia"
                fill
                className="object-cover object-top"
              />
            </div>
            <div className="relative w-5 h-5 rounded-full ring-1.5 ring-white overflow-hidden shrink-0">
              <Image
                src="/assets/editorial/wedding-rings.jpg"
                alt="Cincin Nikah"
                fill
                className="object-cover"
              />
            </div>
          </div>
          <span className="flex items-center gap-1.5 text-stone-700">
            <Heart className="w-3.5 h-3.5 fill-[#d81b60] text-[#d81b60]" />
            <span>Pilihan dipercaya pasangan calon pengantin</span>
          </span>
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
