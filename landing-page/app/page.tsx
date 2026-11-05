import React from 'react';
import Navbar from '@/components/Navbar';
import HeroSection from '@/components/HeroSection';
import AppPreviewMockup from '@/components/AppPreviewMockup';
import FeatureBentoGrid from '@/components/FeatureBentoGrid';
import CoupleSyncBanner from '@/components/CoupleSyncBanner';
import FaqAccordion from '@/components/FaqAccordion';
import FinalCtaSection from '@/components/FinalCtaSection';
import Footer from '@/components/Footer';
import { getLatestRelease } from '@/lib/github-release';

export default async function HomePage() {
  const release = await getLatestRelease();

  return (
    <main className="min-h-screen flex flex-col bg-[#fff9fa] selection:bg-[#ffd9e2] selection:text-[#3e001d]">
      <Navbar />

      <HeroSection release={release} />

      <AppPreviewMockup />

      <FeatureBentoGrid />

      <CoupleSyncBanner />

      <FaqAccordion />

      <FinalCtaSection release={release} />

      <Footer />
    </main>
  );
}
