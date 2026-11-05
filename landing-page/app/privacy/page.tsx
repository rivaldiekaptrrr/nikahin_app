import React from 'react';
import Link from 'next/link';
import Image from 'next/image';
import { ArrowLeft } from 'lucide-react';
import Footer from '@/components/Footer';
import type { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'Kebijakan Privasi | Nikahin App',
  description: 'Kebijakan privasi resmi Nikahin App. Pelajari bagaimana kami melindungi data perencanaan pernikahan, anggaran, dan informasi pribadi Anda bersama pasangan.',
};

export default function PrivacyPolicyPage() {
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
          <div className="inline-flex items-center px-3 py-1 rounded-full bg-[#fdf0de] text-[#ad1457] text-xs font-bold uppercase tracking-wider mb-3">
            <span>Keamanan & Data</span>
          </div>
          <h1 className="text-3xl sm:text-4xl font-black text-slate-900 tracking-tight">
            Kebijakan Privasi
          </h1>
        </div>

        <div className="space-y-8 text-slate-700 text-sm leading-relaxed">
          {/* Ringkasan Komitmen */}
          <section className="p-5 sm:p-6 rounded-3xl bg-white border border-[#ffd9e2]/60 shadow-xs">
            <h2 className="text-base font-bold text-slate-900 mb-2.5">
              Komitmen Privasi Nikahin
            </h2>
            <p className="text-slate-600 leading-relaxed">
              Nikahin menghargai privasi dan kerahasiaan momen sakral pernikahan Anda. 
              Aplikasi ini dirancang bebas iklan dan tidak pernah menjual atau menyewakan data Anda 
              kepada pihak ketiga. Seluruh data yang tersimpan murni digunakan untuk mempermudah koordinasi 
              rencana pernikahan antara Anda dan pasangan.
            </p>
          </section>

          {/* 1. Informasi yang Dikumpulkan */}
          <section className="p-5 sm:p-6 rounded-3xl bg-white border border-slate-200/80 shadow-xs space-y-3">
            <h2 className="text-base font-bold text-slate-900">
              1. Informasi yang Kami Kumpulkan
            </h2>
            <p className="text-slate-600">
              Saat menggunakan Nikahin, informasi yang dikumpulkan meliputi:
            </p>
            <ul className="list-disc pl-5 space-y-1.5 text-slate-600">
              <li>
                <strong>Informasi Akun:</strong> Alamat email, nama lengkap, dan foto profil saat masuk menggunakan Akun Google.
              </li>
              <li>
                <strong>Data Perencanaan:</strong> Tanggal pernikahan, rincian pos anggaran, status pembayaran vendor, susunan acara, daftar tamu undangan, dan catatan hantaran.
              </li>
              <li>
                <strong>Kode Pasangan:</strong> Kode acak 6 karakter untuk menghubungkan akun Anda dengan akun pasangan secara aman.
              </li>
              <li>
                <strong>Informasi Perangkat:</strong> Jenis sistem operasi (Android atau iOS) untuk memastikan pembaruan aplikasi berjalan lancar.
              </li>
            </ul>
          </section>

          {/* 2. Penggunaan Data */}
          <section className="p-5 sm:p-6 rounded-3xl bg-white border border-slate-200/80 shadow-xs space-y-3">
            <h2 className="text-base font-bold text-slate-900">
              2. Cara Kami Menggunakan Data Anda
            </h2>
            <p className="text-slate-600">
              Data yang Anda simpan di Nikahin hanya digunakan untuk keperluan fungsional aplikasi:
            </p>
            <ul className="list-disc pl-5 space-y-1.5 text-slate-600">
              <li>Menyinkronkan data pernikahan secara instan antara ponsel Anda dan ponsel pasangan.</li>
              <li>Menyimpan cadangan data di cloud agar catatan tidak hilang saat berganti ponsel.</li>
              <li>Mengirimkan pengingat jatuh tempo pembayaran vendor dan agenda acara.</li>
              <li>Memverifikasi aktivasi lisensi sekali bayar melalui kanal pembayaran resmi.</li>
            </ul>
          </section>

          {/* 3. Layanan Pihak Ketiga */}
          <section className="p-5 sm:p-6 rounded-3xl bg-white border border-slate-200/80 shadow-xs space-y-3">
            <h2 className="text-base font-bold text-slate-900">
              3. Layanan Pihak Ketiga
            </h2>
            <p className="text-slate-600">
              Untuk menjaga kestabilan dan keamanan sistem, Nikahin bermitra dengan penyedia teknologi terpercaya:
            </p>
            <ul className="list-disc pl-5 space-y-1.5 text-slate-600">
              <li>
                <strong>Google Firebase:</strong> Untuk proses masuk yang aman dan penyimpanan database cloud terenkripsi.
              </li>
              <li>
                <strong>Midtrans:</strong> Gerbang pembayaran resmi berlisensi Bank Indonesia untuk memproses transaksi QRIS, Virtual Account, dan e-wallet. Nikahin tidak pernah menyimpan nomor kartu atau PIN perbankan Anda.
              </li>
              <li>
                <strong>Cloudflare:</strong> Untuk penyajian aset CDN yang cepat dan terenkripsi aman.
              </li>
            </ul>
          </section>

          {/* 4. Keamanan dan Hak Pengguna */}
          <section className="p-5 sm:p-6 rounded-3xl bg-white border border-slate-200/80 shadow-xs space-y-3">
            <h2 className="text-base font-bold text-slate-900">
              4. Keamanan dan Hak Pengguna
            </h2>
            <p className="text-slate-600">
              Seluruh komunikasi data dilindungi dengan enkripsi standar industri HTTPS. Anda memiliki kendali penuh atas data Anda:
            </p>
            <ul className="list-disc pl-5 space-y-1.5 text-slate-600">
              <li>Mengubah atau menghapus data rincian pernikahan kapan saja.</li>
              <li>Memutuskan tautan akun dengan pasangan secara mandiri.</li>
              <li>Mengajukan permohonan penghapusan akun dan seluruh data pribadi secara permanen sesuai panduan di halaman <Link href="/data-deletion" className="text-[#d81b60] font-semibold underline underline-offset-2">Kebijakan Penghapusan Data</Link>.</li>
            </ul>
          </section>

          {/* 5. Hubungi Kami */}
          <section className="p-5 sm:p-6 rounded-3xl bg-white border border-slate-200/80 shadow-xs space-y-3">
            <h2 className="text-base font-bold text-slate-900">
              5. Pertanyaan Seputar Privasi
            </h2>
            <p className="text-slate-600">
              Jika ada hal yang ingin ditanyakan terkait privasi dan perlindungan data di Nikahin, silakan hubungi tim kami langsung melalui halaman bantuan resmi.
            </p>
            <div className="pt-2">
              <Link
                href="/contact"
                className="inline-flex items-center gap-2 px-5 py-2.5 rounded-xl bg-[#d81b60] hover:bg-[#c2185b] text-white font-bold text-xs shadow-xs transition-colors"
              >
                <span>Buka Halaman Kontak & Bantuan</span>
              </Link>
            </div>
          </section>
        </div>
      </main>

      <Footer />
    </div>
  );
}
