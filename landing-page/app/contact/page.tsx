import React from 'react';
import Link from 'next/link';
import Image from 'next/image';
import { ArrowLeft, MessageCircle, Mail, Phone, Clock, HelpCircle, Shield, CheckCircle } from 'lucide-react';
import Footer from '@/components/Footer';
import type { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'Kontak & Bantuan | Nikahin App',
  description: 'Hubungi tim dukungan resmi Nikahin App untuk pertanyaan aktivasi lisensi, bantuan teknis aplikasi, atau kendala akun bersama pasangan.',
};

export default function ContactPage() {
  return (
    <div className="min-h-screen flex flex-col bg-[#fff9fa]">
      {/* Top Header */}
      <header className="fixed top-0 left-0 right-0 z-50 bg-white/90 backdrop-blur-md border-b border-slate-100 py-3.5">
        <div className="max-w-4xl mx-auto px-4 sm:px-6 flex items-center justify-between">
          <Link href="/" className="flex items-center gap-2.5">
            <div className="relative w-7 h-7 rounded-lg overflow-hidden flex items-center justify-center">
              <Image
                src="/assets/nikahin-symbol-master-512.png"
                alt="Logo Nikahin"
                width={28}
                height={28}
                className="object-contain"
              />
            </div>
            <span className="font-extrabold text-lg tracking-tight text-slate-900">
              Nikahin
            </span>
          </Link>

          <Link
            href="/"
            className="inline-flex items-center gap-1.5 text-xs font-bold text-slate-700 hover:text-[#d81b60] px-3 py-1.5 rounded-xl hover:bg-slate-100 transition-colors"
          >
            <ArrowLeft className="w-4 h-4" />
            <span>Kembali ke Beranda</span>
          </Link>
        </div>
      </header>

      {/* Main Document Content */}
      <main className="flex-1 max-w-4xl mx-auto px-4 sm:px-6 pt-28 pb-20">
        <div className="mb-10 text-center sm:text-left">
          <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-[#fdf0de] text-[#ad1457] text-xs font-bold uppercase tracking-wider mb-3">
            <MessageCircle className="w-3.5 h-3.5 text-[#d81b60]" />
            <span>Layanan Pelanggan</span>
          </div>
          <h1 className="text-3xl sm:text-4xl font-black text-slate-900 tracking-tight">
            Hubungi Kami
          </h1>
          <p className="text-xs sm:text-sm text-slate-600 mt-2 max-w-2xl leading-relaxed">
            Ada pertanyaan seputar aktivasi, kendala teknis di HP, atau permohonan data? Tim Nikahin siap membantu Anda dan pasangan dengan senang hati.
          </p>
        </div>

        {/* 2 Main Contact Cards */}
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-5 mb-10">
          {/* Card WhatsApp */}
          <div className="p-6 sm:p-7 rounded-3xl bg-white border border-slate-200/80 shadow-xs hover:shadow-md hover:border-[#ffd9e2] transition-all flex flex-col justify-between">
            <div>
              <div className="w-12 h-12 rounded-2xl bg-emerald-50 text-emerald-600 flex items-center justify-center mb-4">
                <Phone className="w-6 h-6" />
              </div>
              <h2 className="text-lg font-bold text-slate-900 mb-1">
                WhatsApp Customer Support
              </h2>
              <p className="text-xs sm:text-sm text-slate-600 leading-relaxed mb-6">
                Saluran tercepat untuk respon langsung seputar bantuan instalasi dan konfirmasi pembayaran.
              </p>
            </div>

            <div>
              <a
                href="https://wa.me/6287834284141"
                target="_blank"
                rel="noopener noreferrer"
                className="w-full inline-flex items-center justify-center gap-2 px-5 py-3.5 rounded-2xl bg-emerald-600 hover:bg-emerald-700 text-white font-bold text-sm shadow-md shadow-emerald-600/20 transition-all"
              >
                <MessageCircle className="w-4 h-4" />
                <span>Chat via WhatsApp</span>
              </a>
              <p className="text-center text-[11px] text-slate-400 mt-2.5">
                Nomor Resmi: +62 878-3428-4141
              </p>
            </div>
          </div>

          {/* Card Email */}
          <div className="p-6 sm:p-7 rounded-3xl bg-white border border-slate-200/80 shadow-xs hover:shadow-md hover:border-[#ffd9e2] transition-all flex flex-col justify-between">
            <div>
              <div className="w-12 h-12 rounded-2xl bg-[#ffd9e2]/50 text-[#d81b60] flex items-center justify-center mb-4">
                <Mail className="w-6 h-6" />
              </div>
              <h2 className="text-lg font-bold text-slate-900 mb-1">
                Email Dukungan Pengembang
              </h2>
              <p className="text-xs sm:text-sm text-slate-600 leading-relaxed mb-6">
                Untuk pertanyaan kerjasama, laporan bug teknis, atau pengajuan permohonan penghapusan data resmi.
              </p>
            </div>

            <div>
              <a
                href="mailto:rivaldiekaputr@gmail.com"
                className="w-full inline-flex items-center justify-center gap-2 px-5 py-3.5 rounded-2xl bg-[#d81b60] hover:bg-[#c2185b] text-white font-bold text-sm shadow-md shadow-[#d81b60]/20 transition-all"
              >
                <Mail className="w-4 h-4" />
                <span>Kirim Pesan Email</span>
              </a>
              <p className="text-center text-[11px] text-slate-400 mt-2.5">
                Alamat: rivaldiekaputr@gmail.com
              </p>
            </div>
          </div>
        </div>

        {/* Operating Hours & Guarantee */}
        <div className="p-6 sm:p-7 rounded-3xl bg-white border border-slate-200/80 shadow-xs space-y-4 text-slate-700 text-xs sm:text-sm mb-10">
          <h3 className="text-base font-bold text-slate-900 flex items-center gap-2">
            <Clock className="w-4 h-4 text-[#d81b60]" />
            <span>Waktu Operasional & Layanan Bantuan</span>
          </h3>
          <p className="text-slate-600 leading-relaxed">
            Tim dukungan Nikahin siap merespon pesan Anda setiap hari:
          </p>
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 pt-1">
            <div className="flex items-center gap-2.5 p-3 rounded-2xl bg-[#fff9fa] border border-slate-100">
              <CheckCircle className="w-4 h-4 text-emerald-600 shrink-0" />
              <div>
                <strong>Senin – Minggu:</strong> 08:00 – 22:00 WIB
              </div>
            </div>
            <div className="flex items-center gap-2.5 p-3 rounded-2xl bg-[#fff9fa] border border-slate-100">
              <CheckCircle className="w-4 h-4 text-emerald-600 shrink-0" />
              <div>
                <strong>Aktivasi Lisensi Otomatis:</strong> 24 Jam Nonstop
              </div>
            </div>
          </div>
        </div>

        {/* Quick Links to Legal Documents */}
        <div className="p-6 rounded-3xl bg-slate-50 border border-slate-200/80 text-xs sm:text-sm text-slate-600 space-y-2">
          <p className="font-bold text-slate-800 flex items-center gap-1.5">
            <Shield className="w-4 h-4 text-[#d81b60]" />
            <span>Dokumen Terkait Privasi & Layanan:</span>
          </p>
          <div className="flex flex-wrap gap-x-6 gap-y-2 pt-1 font-medium text-[#d81b60]">
            <Link href="/privacy" className="hover:underline">
              Kebijakan Privasi
            </Link>
            <Link href="/terms" className="hover:underline">
              Syarat & Ketentuan
            </Link>
            <Link href="/data-deletion" className="hover:underline">
              Kebijakan Penghapusan Data
            </Link>
          </div>
        </div>
      </main>

      <Footer />
    </div>
  );
}
