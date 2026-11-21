import React from 'react';
import Image from 'next/image';
import { Heart, ShieldCheck, Users, Sparkles, Star, DownloadCloud } from 'lucide-react';
import DeviceCta from './DeviceCta';
import { ReleaseMetadata } from '@/lib/github-release';

interface HeroSectionProps {
  release: ReleaseMetadata;
}

export default function HeroSection({ release }: HeroSectionProps) {
  return (
    <section id="hero" className="relative pt-16 pb-4 sm:pt-24 sm:pb-14 md:pt-36 md:pb-20 overflow-hidden">
      {/* Floating Organic Elements - Disembunyikan di mobile agar tidak menumpuk logo atau menu */}
      <div className="hidden md:block absolute top-16 left-8 md:left-12 pointer-events-none select-none z-0 animate-float-slow">
        <Image
          src="/assets/editorial/leaf-green.svg"
          alt="Aksen Daun Melayang"
          width={72}
          height={72}
          className="w-12 h-12 md:w-16 md:h-16 opacity-85 -rotate-12"
        />
      </div>

      <div className="hidden md:block absolute top-20 right-10 md:right-16 pointer-events-none select-none z-0 animate-float-reverse">
        <Image
          src="/assets/editorial/petal-jasmine.svg"
          alt="Aksen Kelopak Melati"
          width={56}
          height={56}
          className="w-10 h-10 md:w-12 md:h-12 opacity-80 rotate-45"
        />
      </div>

      <div className="hidden md:block absolute bottom-10 right-12 md:right-20 pointer-events-none select-none z-0 animate-float-slow">
        <Image
          src="/assets/editorial/petal-blush.svg"
          alt="Aksen Kelopak Mawar"
          width={60}
          height={60}
          className="w-11 h-11 md:w-13 md:h-13 opacity-75 -rotate-15"
        />
      </div>

      <div className="max-w-4xl mx-auto px-4 sm:px-6 text-center relative z-10">
        {/* Social Proof & Trust Pill - Foto Lebih Terbaca & Ramping */}
        <div className="inline-flex items-center gap-2.5 px-3.5 py-1.5 rounded-full bg-white/90 border border-stone-200/80 shadow-xs text-xs font-medium text-stone-700 mb-4 sm:mb-6 backdrop-blur-xs">
          <div className="flex -space-x-2 overflow-hidden">
            <div className="relative w-6 h-6 rounded-full ring-2 ring-white overflow-hidden shrink-0 shadow-xs">
              <Image
                src="/assets/editorial/wedding-couple-indo.jpg"
                alt="Pengantin Nikahin"
                fill
                sizes="24px"
                className="object-cover object-top"
              />
            </div>
            <div className="relative w-6 h-6 rounded-full ring-2 ring-white overflow-hidden shrink-0 shadow-xs">
              <Image
                src="/assets/editorial/wedding-couple.jpg"
                alt="Pasangan Bahagia"
                fill
                sizes="24px"
                className="object-cover object-top"
              />
            </div>
            <div className="relative w-6 h-6 rounded-full ring-2 ring-white overflow-hidden shrink-0 shadow-xs">
              <Image
                src="/assets/editorial/wedding-bouquet.jpg"
                alt="Bunga Pernikahan"
                fill
                sizes="24px"
                className="object-cover"
              />
            </div>
          </div>
          <span className="flex items-center gap-1.5 text-stone-700">
            <Heart className="w-3.5 h-3.5 fill-[#d81b60] text-[#d81b60] shrink-0" />
            <span>Dipercaya ribuan calon pengantin di Indonesia</span>
          </span>
        </div>

        {/* Main Headline (Wedding Luxury Editorial with Playfair Display) */}
        <h1 className="text-[26px] sm:text-4xl md:text-6xl font-semibold text-stone-900 tracking-tight leading-[1.2] sm:leading-[1.15] mb-3 sm:mb-6">
          Catat anggaran bersama,{' '}
          <span className="font-[family-name:var(--font-playfair)] italic font-medium text-[#831843]">
            wujudkan pernikahan impian
          </span>{' '}
          lebih tenang
        </h1>

        {/* Subtitle (Warm Neutral Secondary Text) */}
        <p className="text-sm sm:text-base md:text-lg text-stone-600 max-w-2xl mx-auto font-normal leading-relaxed mb-4 sm:mb-6">
          Kelola bujet, vendor, susunan acara, buku tamu, hingga berkas KUA dalam satu aplikasi yang langsung terhubung di ponsel kalian berdua.
        </p>

        {/* 3 Metrik Kredibilitas Terpadu (Pre-CTA Social Proof Strip - WCAG AA & Tabular Nums) */}
        <div 
          role="region" 
          aria-label="Statistik pencapaian aplikasi Nikahin"
          className="mb-5 sm:mb-7 flex flex-wrap items-center justify-center gap-x-4 sm:gap-x-7 gap-y-2 text-stone-700"
        >
          {/* Metrik 1: Pasangan Pengguna */}
          <div className="flex items-center gap-1.5">
            <Users className="w-4 h-4 text-[#d81b60] shrink-0" aria-hidden="true" />
            <span className="text-sm sm:text-base font-bold text-stone-900 tracking-tight tabular-nums">
              1.200+
            </span>
            <span className="text-xs text-stone-500 font-medium">Pasangan Pengguna</span>
          </div>

          <span className="hidden sm:inline text-stone-300 select-none" aria-hidden="true">•</span>

          {/* Metrik 2: Total Unduhan */}
          <div className="flex items-center gap-1.5">
            <DownloadCloud className="w-4 h-4 text-emerald-600 shrink-0" aria-hidden="true" />
            <span className="text-sm sm:text-base font-bold text-stone-900 tracking-tight tabular-nums">
              2.500+
            </span>
            <span className="text-xs text-stone-500 font-medium">Total Unduhan</span>
          </div>

          <span className="hidden sm:inline text-stone-300 select-none" aria-hidden="true">•</span>

          {/* Metrik 3: Rating Kepuasan */}
          <div className="flex items-center gap-1.5">
            <Star className="w-4 h-4 fill-amber-400 text-amber-500 shrink-0" aria-hidden="true" />
            <span className="text-sm sm:text-base font-bold text-stone-900 tracking-tight tabular-nums">
              4.9 / 5.0
            </span>
            <span className="text-xs text-stone-500 font-medium">Rating Kepuasan</span>
          </div>
        </div>

        {/* Interactive Device Adaptive CTA */}
        <div className="mb-4 sm:mb-6">
          <DeviceCta release={release} />
        </div>

        {/* 3 Key Trust Signals - Ramping, Hangat, dan Alami */}
        <div className="flex flex-wrap items-center justify-center gap-x-4 sm:gap-x-8 gap-y-2 text-xs font-medium text-stone-600">
          <div className="inline-flex items-center gap-1.5">
            <Users className="w-3.5 h-3.5 text-stone-500 shrink-0" />
            <span>Satu akun untuk berdua</span>
          </div>
          <span className="hidden sm:inline text-stone-300">•</span>
          <div className="inline-flex items-center gap-1.5">
            <ShieldCheck className="w-3.5 h-3.5 text-emerald-600 shrink-0" />
            <span>Sinkron langsung di dua ponsel</span>
          </div>
          <span className="hidden sm:inline text-stone-300">•</span>
          <div className="inline-flex items-center gap-1.5">
            <Sparkles className="w-3.5 h-3.5 text-amber-600 shrink-0" />
            <span>Sekali bayar tanpa langganan</span>
          </div>
        </div>
      </div>
    </section>
  );
}
