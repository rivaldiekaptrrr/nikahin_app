'use client';

import React, { useState, useEffect } from 'react';
import Image from 'next/image';
import Link from 'next/link';
import { Smartphone, Menu, X, ArrowRight } from 'lucide-react';

export default function Navbar() {
  const [isScrolled, setIsScrolled] = useState(false);
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);

  useEffect(() => {
    const handleScroll = () => {
      setIsScrolled(window.scrollY > 20);
    };
    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  return (
    <header
      className={`fixed top-0 left-0 right-0 z-50 transition-all duration-300 ${
        isScrolled
          ? 'bg-white/90 backdrop-blur-md shadow-sm border-b border-slate-100 py-3.5'
          : 'bg-transparent py-5'
      }`}
    >
      <div className="max-w-6xl mx-auto px-4 sm:px-6 flex items-center justify-between">
        {/* Brand Logo */}
        <Link href="/" className="flex items-center gap-2.5 group">
          <div className="relative w-8 h-8 rounded-lg overflow-hidden flex items-center justify-center">
            <Image
              src="/assets/nikahin-symbol-master-512.png"
              alt="Logo Nikahin"
              width={32}
              height={32}
              className="object-contain"
              priority
            />
          </div>
          <span className="font-extrabold text-xl tracking-tight text-slate-900 group-hover:text-[#d81b60] transition-colors">
            Nikahin
          </span>
        </Link>

        {/* Desktop Navigation */}
        <nav className="hidden md:flex items-center gap-8 text-sm font-medium text-slate-600">
          <a href="#fitur" className="hover:text-[#d81b60] transition-colors">
            Fitur Utama
          </a>
          <a href="#preview" className="hover:text-[#d81b60] transition-colors">
            Tampilan Aplikasi
          </a>
          <a href="#pasangan" className="hover:text-[#d81b60] transition-colors">
            Akun Pasangan
          </a>
          <a href="#faq" className="hover:text-[#d81b60] transition-colors">
            Tanya Jawab
          </a>
        </nav>

        {/* Desktop CTA Button */}
        <div className="hidden md:flex items-center gap-3">
          <a
            href="#hero"
            className="inline-flex items-center gap-2 text-xs font-bold text-white bg-[#d81b60] hover:bg-[#c2185b] px-4 py-2.5 rounded-full shadow-sm shadow-[#d81b60]/20 hover:shadow-md hover:shadow-[#d81b60]/30 transition-all"
          >
            <Smartphone className="w-3.5 h-3.5" />
            <span>Pasang Sekarang</span>
          </a>
        </div>

        {/* Mobile Hamburger Button */}
        <button
          onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
          className="md:hidden p-2 text-slate-700 hover:text-[#d81b60] focus:outline-none"
          aria-label="Toggle menu"
        >
          {mobileMenuOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
        </button>
      </div>

      {/* Mobile Drawer */}
      {mobileMenuOpen && (
        <div className="md:hidden bg-white/95 backdrop-blur-lg border-b border-slate-100 px-6 py-5 shadow-lg space-y-4">
          <nav className="flex flex-col gap-3 text-sm font-medium text-slate-700">
            <a
              href="#fitur"
              onClick={() => setMobileMenuOpen(false)}
              className="py-1.5 hover:text-[#d81b60]"
            >
              Fitur Utama
            </a>
            <a
              href="#preview"
              onClick={() => setMobileMenuOpen(false)}
              className="py-1.5 hover:text-[#d81b60]"
            >
              Tampilan Aplikasi
            </a>
            <a
              href="#pasangan"
              onClick={() => setMobileMenuOpen(false)}
              className="py-1.5 hover:text-[#d81b60]"
            >
              Akun Pasangan
            </a>
            <a
              href="#faq"
              onClick={() => setMobileMenuOpen(false)}
              className="py-1.5 hover:text-[#d81b60]"
            >
              Tanya Jawab
            </a>
          </nav>
          <div className="pt-3 border-t border-slate-100 flex flex-col gap-2.5">
            <a
              href="#hero"
              onClick={() => setMobileMenuOpen(false)}
              className="w-full inline-flex items-center justify-center gap-2 text-sm font-bold text-white bg-[#d81b60] py-2.5 rounded-xl shadow-md transition-all"
            >
              <span>Download Aplikasi</span>
              <ArrowRight className="w-4 h-4" />
            </a>
          </div>
        </div>
      )}
    </header>
  );
}

