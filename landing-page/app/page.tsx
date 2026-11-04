import React from 'react';
import Navbar from '@/components/Navbar';
import HeroSection from '@/components/HeroSection';
import AppPreviewMockup from '@/components/AppPreviewMockup';
import FeatureBentoGrid from '@/components/FeatureBentoGrid';
import CoupleSyncBanner from '@/components/CoupleSyncBanner';
import FaqAccordion from '@/components/FaqAccordion';
import Footer from '@/components/Footer';
import DeviceCta from '@/components/DeviceCta';
import { getLatestRelease } from '@/lib/github-release';
import { Heart } from 'lucide-react';

export default async function HomePage() {
  const release = await getLatestRelease();

  return (
    <main className="min-h-screen flex flex-col bg-[#fff9fa] selection:bg-[#ffd9e2] selection:text-[#3e001d]">
      <Navbar />

      <HeroSection release={release} />

      <AppPreviewMockup />

      <FeatureBentoGrid />

      <CoupleSyncBanner />

      {/* Dedicated Final Download Section */}
      <section id="download" className="py-20 md:py-28 bg-white relative overflow-hidden">
        <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[550px] h-[300px] bg-gradient-to-tr from-[#ffd9e2]/30 via-[#fdf0de]/40 to-transparent blur-3xl pointer-events-none -z-10" />

        <div className="max-w-4xl mx-auto px-4 sm:px-6 text-center">
          <div className="w-14 h-14 rounded-2xl bg-[#ffd9e2]/50 text-[#d81b60] mx-auto flex items-center justify-center mb-5 shadow-xs">
            <Heart className="w-7 h-7 fill-[#d81b60]" />
          </div>

          <h2 className="text-3xl sm:text-4xl md:text-5xl font-black text-slate-900 tracking-tight leading-tight mb-4">
            Mulai Rencanakan Hari Istimewamu Sekarang
          </h2>

          <p className="text-sm sm:text-base text-slate-600 max-w-xl mx-auto mb-10 leading-relaxed">
            Pasang Nikahin sekarang di perangkat Android atau iPhone. Cukup 1 akun untuk kamu dan pasangan.
          </p>

          <div className="max-w-lg mx-auto">
            <DeviceCta release={release} />
          </div>
        </div>
      </section>

      <FaqAccordion />

      <Footer />
    </main>
  );
}
