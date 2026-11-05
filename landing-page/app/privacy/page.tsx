import React from 'react';
import Link from 'next/link';
import Image from 'next/image';
import { ArrowLeft, ShieldCheck, Lock, Database, Users, HelpCircle } from 'lucide-react';
import Footer from '@/components/Footer';
import type { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'Kebijakan Privasi | Nikahin App',
  description: 'Kebijakan privasi resmi Nikahin App. Pelajari bagaimana kami melindungi data perencanaan pernikahan, anggaran, dan informasi pribadi Anda bersama pasangan.',
};

export default function PrivacyPolicyPage() {
  const lastUpdated = '5 November 2026';

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
            <ShieldCheck className="w-3.5 h-3.5 text-[#d81b60]" />
            <span>Keamanan & Data</span>
          </div>
          <h1 className="text-3xl sm:text-4xl font-black text-slate-900 tracking-tight">
            Kebijakan Privasi
          </h1>
          <p className="text-xs sm:text-sm text-slate-500 mt-2 font-medium">
            Terakhir diperbarui: {lastUpdated}
          </p>
        </div>

        <div className="space-y-8 text-slate-700 text-sm leading-relaxed">
          {/* Ringkasan Komitmen */}
          <section className="p-5 sm:p-6 rounded-3xl bg-white border border-[#ffd9e2]/60 shadow-xs">
            <h2 className="text-base font-bold text-slate-900 flex items-center gap-2 mb-2.5">
              <Lock className="w-4 h-4 text-[#d81b60]" />
              <span>Komitmen Privasi Nikahin</span>
            </h2>
            <p className="text-slate-600">
              Nikahin menghargai privasi dan kerahasiaan momen sakral pernikahan Anda. 
              Aplikasi ini dirancang bebas iklan dan tidak pernah menjual atau menyewakan data Anda 
              kepada pihak ketiga untuk keperluan periklanan. Seluruh data yang disimpan murni digunakan 
              untuk mempermudah perencanaan pernikahan antara Anda dan pasangan.
            </p>
          </section>

          {/* 1. Informasi yang Kami Kumpulkan */}
          <section className="p-5 sm:p-6 rounded-3xl bg-white border border-slate-200/80 shadow-xs space-y-3">
            <h2 className="text-base font-bold text-slate-900">
              1. Informasi yang Kami Kumpulkan
            </h2>
            <p className="text-slate-600">
              Saat menggunakan Nikahin, kami dapat mengumpulkan informasi berikut:
            </p>
            <ul className="list-disc pl-5 space-y-1.5 text-slate-600">
              <li>
                <strong>Informasi Akun:</strong> Alamat email, nama lengkap, dan foto profil yang Anda gunakan saat masuk melalui Google Sign-In.
              </li>
              <li>
                <strong>Data Perencanaan Pernikahan:</strong> Tanggal pernikahan, estimasi dan rincian anggaran, status pembayaran vendor, susunan acara (rundown), daftar tamu undangan, dan checklist hantaran.
              </li>
              <li>
                <strong>Kode Pasangan:</strong> Kode acak unik 6 karakter yang digunakan untuk menghubungkan akun Anda dengan akun pasangan Anda secara aman.
              </li>
              <li>
                <strong>Informasi Perangkat:</strong> Jenis sistem operasi (Android/iOS) dan versi aplikasi untuk memastikan pembaruan dan kompatibilitas sistem berjalan baik.
              </li>
            </ul>
          </section>

          {/* 2. Tujuan Penggunaan Data */}
          <section className="p-5 sm:p-6 rounded-3xl bg-white border border-slate-200/80 shadow-xs space-y-3">
            <h2 className="text-base font-bold text-slate-900 flex items-center gap-2">
              <Database className="w-4 h-4 text-[#d81b60]" />
              <span>2. Cara Kami Menggunakan Data Anda</span>
            </h2>
            <p className="text-slate-600">
              Informasi yang Anda simpan di Nikahin hanya digunakan untuk:
            </p>
            <ul className="list-disc pl-5 space-y-1.5 text-slate-600">
              <li>Menyinkronkan data pernikahan secara instan antara ponsel Anda dan ponsel pasangan Anda.</li>
              <li>Menyimpan data cadangan di cloud agar catatan tidak hilang saat Anda berganti perangkat.</li>
              <li>Mengirimkan pengingat jatuh tempo pembayaran vendor dan jadwal acara.</li>
              <li>Memverifikasi aktivasi lisensi sekali bayar melalui payment gateway resmi.</li>
            </ul>
          </section>

          {/* 3. Layanan Pihak Ketiga */}
          <section className="p-5 sm:p-6 rounded-3xl bg-white border border-slate-200/80 shadow-xs space-y-3">
            <h2 className="text-base font-bold text-slate-900">
              3. Layanan Pihak Ketiga
            </h2>
            <p className="text-slate-600">
              Untuk menjamin keamanan dan keandalan sistem, Nikahin bekerja sama dengan penyedia infrastruktur terpercaya:
            </p>
            <ul className="list-disc pl-5 space-y-1.5 text-slate-600">
              <li>
                <strong>Google Firebase:</strong> Untuk autentikasi aman (*Firebase Authentication*) dan penyimpanan data cloud terenkripsi (*Cloud Firestore*).
              </li>
              <li>
                <strong>Midtrans (PT Midtrans):</strong> Sebagai gerbang pembayaran (*Payment Gateway*) resmi berlisensi Bank Indonesia untuk memproses transaksi QRIS, Virtual Account, dan e-wallet secara aman. Nikahin tidak menyimpan nomor kartu atau PIN perbankan Anda.
              </li>
              <li>
                <strong>Cloudflare:</strong> Untuk penyajian aset CDN yang aman dan cepat dengan enkripsi SSL tingkat tinggi.
              </li>
            </ul>
          </section>

          {/* 4. Keamanan dan Penyimpanan Data */}
          <section className="p-5 sm:p-6 rounded-3xl bg-white border border-slate-200/80 shadow-xs space-y-3">
            <h2 className="text-base font-bold text-slate-900">
              4. Keamanan & Hak Pengguna
            </h2>
            <p className="text-slate-600">
              Semua komunikasi antara aplikasi dan peladen dilindungi dengan enkripsi standar industri (HTTPS / TLS). 
              Anda memiliki hak penuh untuk:
            </p>
            <ul className="list-disc pl-5 space-y-1.5 text-slate-600">
              <li>Mengubah, memperbarui, atau menghapus data perencanaan pernikahan kapan saja.</li>
              <li>Memutuskan tautan akun dengan pasangan (*Unlink Partner*).</li>
              <li>Mengajukan permohonan penghapusan akun dan seluruh data pribadi secara permanen sesuai panduan di halaman <Link href="/data-deletion" className="text-[#d81b60] font-semibold underline underline-offset-2">Kebijakan Penghapusan Data</Link>.</li>
            </ul>
          </section>

          {/* 5. Kontak Pertanyaan Privasi */}
          <section className="p-5 sm:p-6 rounded-3xl bg-white border border-slate-200/80 shadow-xs space-y-2">
            <h2 className="text-base font-bold text-slate-900 flex items-center gap-2">
              <HelpCircle className="w-4 h-4 text-[#d81b60]" />
              <span>5. Hubungi Kami</span>
            </h2>
            <p className="text-slate-600">
              Jika Anda memiliki pertanyaan seputar Kebijakan Privasi ini atau pengelolaan data di Nikahin, silakan hubungi tim kami melalui:
            </p>
            <div className="pt-2 text-xs sm:text-sm text-slate-800 space-y-1 font-medium">
              <p>Email: <a href="mailto:rivaldiekaputr@gmail.com" className="text-[#d81b60] underline">rivaldiekaputr@gmail.com</a></p>
              <p>WhatsApp: <a href="https://wa.me/6287834284141" target="_blank" rel="noopener noreferrer" className="text-[#d81b60] underline">+62 878-3428-4141</a></p>
            </div>
          </section>
        </div>
      </main>

      <Footer />
    </div>
  );
}
