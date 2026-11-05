import React from 'react';
import Image from 'next/image';
import Link from 'next/link';
import { Heart } from 'lucide-react';

export default function Footer() {
  const currentYear = 2026;

  return (
    <footer className="bg-white border-t border-slate-200 py-12 md:py-16 text-slate-600 text-xs sm:text-sm">
      <div className="max-w-6xl mx-auto px-4 sm:px-6">
        <div className="flex flex-col md:flex-row items-center justify-between gap-6 pb-10 border-b border-slate-100">
          {/* Brand Info */}
          <div className="flex flex-col items-center md:items-start text-center md:text-left gap-2">
            <Link href="/" className="flex items-center gap-2.5">
              <Image
                src="/assets/nikahin-symbol-master-512.png"
                alt="Logo Nikahin"
                width={28}
                height={28}
                className="object-contain"
              />
              <span className="font-extrabold text-lg text-slate-900 tracking-tight">
                Nikahin
              </span>
            </Link>
            <p className="text-xs text-slate-500 max-w-sm">
              Aplikasi pendamping pernikahan terlengkap untuk calon pengantin Indonesia. Rencanakan momen bahagiamu dengan tenang dan teratur.
            </p>
          </div>

          {/* Quick Links */}
          <div className="flex flex-wrap items-center justify-center gap-6 font-medium text-slate-600">
            <a href="/#fitur" className="hover:text-[#d81b60] transition-colors">
              Fitur Utama
            </a>
            <a href="/#preview" className="hover:text-[#d81b60] transition-colors">
              Tampilan Aplikasi
            </a>
            <a href="/#pasangan" className="hover:text-[#d81b60] transition-colors">
              Akun Pasangan
            </a>
            <a href="/#faq" className="hover:text-[#d81b60] transition-colors">
              Tanya Jawab
            </a>
            <Link href="/contact" className="hover:text-[#d81b60] transition-colors font-semibold">
              Bantuan
            </Link>
          </div>
        </div>

        {/* Legal & Policy Links */}
        <div className="pt-6 pb-4 flex flex-wrap items-center justify-center md:justify-start gap-x-5 gap-y-2 text-xs text-slate-500 font-medium">
          <Link href="/privacy" className="hover:text-[#d81b60] transition-colors">
            Kebijakan Privasi
          </Link>
          <span className="text-slate-300">•</span>
          <Link href="/terms" className="hover:text-[#d81b60] transition-colors">
            Syarat & Ketentuan
          </Link>
          <span className="text-slate-300">•</span>
          <Link href="/data-deletion" className="hover:text-[#d81b60] transition-colors">
            Penghapusan Data
          </Link>
          <span className="text-slate-300">•</span>
          <Link href="/contact" className="hover:text-[#d81b60] transition-colors">
            Kontak Resmi
          </Link>
        </div>

        {/* Bottom Copyright & Blessing */}
        <div className="pt-4 border-t border-slate-100 flex flex-col sm:flex-row items-center justify-between gap-4 text-xs text-slate-400">
          <p>© {currentYear} Nikahin App. Hak Cipta Dilindungi.</p>
          <p className="flex items-center gap-1 text-slate-500">
            <span>Dibuat dengan</span>
            <Heart className="w-3.5 h-3.5 fill-[#d81b60] text-[#d81b60]" />
            <span>untuk calon pengantin Indonesia.</span>
          </p>
        </div>
      </div>
    </footer>
  );
}
