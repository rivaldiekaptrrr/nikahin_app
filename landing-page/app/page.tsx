import React from 'react';
import Navbar from '@/components/Navbar';
import TactileBackground from '@/components/TactileBackground';
import HeroSection from '@/components/HeroSection';
import AppPreviewMockup from '@/components/AppPreviewMockup';
import FeatureBentoGrid from '@/components/FeatureBentoGrid';
import CoupleSyncBanner from '@/components/CoupleSyncBanner';
import FaqAccordion from '@/components/FaqAccordion';
import FinalCtaSection from '@/components/FinalCtaSection';
import Footer from '@/components/Footer';
import TrackViewContent from '@/components/TrackViewContent';
import { getLatestRelease } from '@/lib/github-release';

export const revalidate = 300;

export default async function HomePage() {
  const release = await getLatestRelease();

  return (
    <main className="min-h-screen relative flex flex-col bg-[#faf7f2] text-[#1c1917] selection:bg-[#fce7ef] selection:text-[#831843]">
      <TactileBackground />
      <TrackViewContent />
      <Navbar />

      <div className="relative z-10 flex flex-col">
        <HeroSection release={release} />
        <AppPreviewMockup />
        <FeatureBentoGrid />
        <CoupleSyncBanner />
        <FaqAccordion />
        <FinalCtaSection release={release} />
        <Footer />
      </div>
    </main>
  );
}
