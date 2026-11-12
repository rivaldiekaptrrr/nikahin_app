'use client';

import React, { useEffect, useRef, useState } from 'react';

interface ScrollRevealProps {
  children: React.ReactNode;
  className?: string;
  delayMs?: number;
  threshold?: number;
}

export default function ScrollReveal({
  children,
  className = '',
  delayMs = 0,
  threshold = 0.1,
}: ScrollRevealProps) {
  const [isVisible, setIsVisible] = useState(false);
  const domRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    // Patuhi preferensi pengguna untuk reduced-motion
    if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
      setIsVisible(true);
      return;
    }

    // Jika elemen sudah masuk viewport saat awal load, tampilkan langsung
    if (domRef.current) {
      const rect = domRef.current.getBoundingClientRect();
      if (rect.top < window.innerHeight * 0.95) {
        setIsVisible(true);
        return;
      }
    }

    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            setIsVisible(true);
            if (domRef.current) {
              observer.unobserve(domRef.current);
            }
          }
        });
      },
      {
        threshold,
        rootMargin: '0px 0px -50px 0px',
      }
    );

    const target = domRef.current;
    if (target) {
      observer.observe(target);
    }

    return () => {
      if (target) {
        observer.unobserve(target);
      }
    };
  }, [threshold]);

  return (
    <div
      ref={domRef}
      style={{
        transitionDelay: `${delayMs}ms`,
      }}
      className={`transition-[opacity,transform] duration-700 ease-out will-change-[opacity,transform] ${
        isVisible
          ? 'opacity-100 translate-y-0'
          : 'opacity-0 translate-y-6 pointer-events-none'
      } ${className}`}
    >
      {children}
    </div>
  );
}

