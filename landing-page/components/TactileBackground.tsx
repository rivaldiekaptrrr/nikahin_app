import React from 'react';

/**
 * TactileBackground: Latar belakang bertema Wedding Stationery & Cotton Paper
 * Dibuat mengikuti standar Unslop: bebas dari glowing blobs / AI-slop, mengedepankan
 * tekstur kertas fisik (subtle grain) dan aksen garis tipis cincin bertaut (signature detail).
 */
export default function TactileBackground() {
  return (
    <div
      aria-hidden="true"
      className="fixed inset-0 pointer-events-none z-0 overflow-hidden select-none"
    >
      {/* 1. Subtle Paper Grain Texture Layer (Pure Inline SVG Filter) */}
      <svg
        className="absolute inset-0 w-full h-full pointer-events-none opacity-[0.035]"
        xmlns="http://www.w3.org/2000/svg"
      >
        <filter id="weddingPaperNoise">
          <feTurbulence
            type="fractalNoise"
            baseFrequency="0.8"
            numOctaves="3"
            stitchTiles="stitch"
          />
        </filter>
        <rect width="100%" height="100%" filter="url(#weddingPaperNoise)" />
      </svg>

      {/* 2. Soft Ambient Warmth (Very Low Saturation, Warm Paper Atmosphere) */}
      <div
        className="absolute top-0 left-1/2 -translate-x-1/2 w-full max-w-7xl h-[600px] opacity-60 pointer-events-none"
        style={{
          background:
            'radial-gradient(ellipse 65% 50% at 50% 0%, #fdf0de 0%, #faf7f2 100%)',
        }}
      />

      {/* 3. Signature Minimalist Wedding Rings Line-Art (Top Right Accent) */}
      <div className="absolute top-16 right-[-40px] lg:right-12 w-64 h-64 opacity-25 pointer-events-none hidden sm:block">
        <svg
          viewBox="0 0 200 200"
          fill="none"
          xmlns="http://www.w3.org/2000/svg"
          className="w-full h-full text-[#c49756]"
        >
          {/* Ring 1 */}
          <circle
            cx="80"
            cy="100"
            r="48"
            stroke="currentColor"
            strokeWidth="1.2"
            strokeDasharray="3 3"
          />
          {/* Ring 2 (Interlocking) */}
          <circle
            cx="120"
            cy="100"
            r="48"
            stroke="currentColor"
            strokeWidth="1.2"
          />
          {/* Sparkle Accent */}
          <path
            d="M80 48L82 56L90 58L82 60L80 68L78 60L70 58L78 56L80 48Z"
            fill="currentColor"
            opacity="0.8"
          />
        </svg>
      </div>

      {/* 4. Soft Bottom Ambient Vignette */}
      <div
        className="absolute bottom-0 left-0 right-0 h-96 opacity-40 pointer-events-none"
        style={{
          background:
            'linear-gradient(to top, #f5efe6 0%, transparent 100%)',
        }}
      />
    </div>
  );
}

