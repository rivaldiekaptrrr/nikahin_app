import React from 'react';
import Link from 'next/link';
import Image from 'next/image';
import { ArrowLeft } from 'lucide-react';
import Footer from '@/components/Footer';
import type { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'Syarat & Ketentuan | Nikahin App',
  description: 'Syarat dan ketentuan penggunaan aplikasi Nikahin. Ketahui hak, kewajiban, ketentuan lisensi sekali bayar, dan batasan layanan kami.',
};

export default function TermsPage() {
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
            <span>Perjanjian Layanan</span>
          </div>
          <h1 className="text-3xl sm:text-4xl font-black text-slate-900 tracking-tight">
            Syarat & Ketentuan
          </h1>
        </div>

        <div className="space-y-8 text-slate-700 text-sm leading-relaxed">
          {/* Pembukaan */}
          <section className="p-5 sm:p-6 rounded-3xl bg-white border border-[#ffd9e2]/60 shadow-xs">
            <h2 className="text-base font-bold text-slate-900 mb-2.5">
              Ketentuan Umum
            </h2>
            <p className="text-slate-600 leading-relaxed">
              Dengan mengunduh, memasang, atau menggunakan aplikasi Nikahin di Android, iPhone, maupun web, 
              Anda menyatakan telah membaca dan menyetujui Syarat dan Ketentuan ini. Ketentuan ini berlaku 
              untuk seluruh fitur yang disediakan di dalam aplikasi.
            </p>
          </section>

          {/* 1. Ketentuan Lisensi */}
          <section className="p-5 sm:p-6 rounded-3xl bg-white border border-slate-200/80 shadow-xs space-y-3">
            <h2 className="text-base font-bold text-slate-900">
              1. Lisensi Penggunaan Sekali Bayar
            </h2>
            <p className="text-slate-600">
              Nikahin menerapkan sistem lisensi yang transparan:
            </p>
            <ul className="list-disc pl-5 space-y-1.5 text-slate-600">
              <li>
                <strong>Satu Kali Bayar untuk Selamanya:</strong> Pembelian lisensi berlaku seumur hidup untuk satu rangkaian acara pernikahan Anda tanpa biaya langganan bulanan.
              </li>
              <li>
                <strong>Otomatis untuk Dua Akun:</strong> Satu lisensi aktif otomatis mencakup dua akun pasangan (calon pengantin pria dan wanita) menggunakan tautan kode pasangan 6 karakter.
              </li>
              <li>
                <strong>Kanal Pembayaran Resmi:</strong> Transaksi diproses melalui gerbang pembayaran resmi Midtrans dengan verifikasi otomatis 24 jam.
              </li>
            </ul>
          </section>

          {/* 2. Hak Milik Data */}
          <section className="p-5 sm:p-6 rounded-3xl bg-white border border-slate-200/80 shadow-xs space-y-3">
            <h2 className="text-base font-bold text-slate-900">
              2. Hak Milik Data Pengguna
            </h2>
            <p className="text-slate-600 leading-relaxed">
              Seluruh data yang Anda masukkan—mulai dari pos anggaran, catatan pelunasan vendor, susunan acara, hingga daftar nama tamu—adalah milik Anda sepenuhnya. Nikahin tidak mengklaim hak kepemilikan atas konten pribadi tersebut.
            </p>
          </section>

          {/* 3. Batasan Tanggung Jawab */}
          <section className="p-5 sm:p-6 rounded-3xl bg-white border border-slate-200/80 shadow-xs space-y-3">
            <h2 className="text-base font-bold text-slate-900">
              3. Batasan Tanggung Jawab Layanan
            </h2>
            <ul className="list-disc pl-5 space-y-2 text-slate-600">
              <li>
                <strong>Aplikasi Pendamping Mandiri:</strong> Nikahin adalah alat bantu digital untuk mencatat dan mengoordinasikan persiapan pernikahan secara mandiri. Nikahin bukan penyedia jasa wedding organizer fisik atau perantara komisi vendor.
              </li>
              <li>
                <strong>Kesepakatan dengan Vendor:</strong> Segala perjanjian kerja, transaksi pembayaran langsung, dan hasil layanan vendor pernikahan merupakan kesepakatan langsung antara Anda dan pihak vendor.
              </li>
              <li>
                <strong>Syarat Administrasi Pernikahan:</strong> Daftar persyaratan berkas legal yang ada di aplikasi berfungsi sebagai panduan referensi umum. Ketentuan resmi tetap mengacu pada peraturan kantor KUA dan Catatan Sipil setempat.
              </li>
            </ul>
          </section>

          {/* 4. Larangan Penggunaan */}
          <section className="p-5 sm:p-6 rounded-3xl bg-white border border-slate-200/80 shadow-xs space-y-3">
            <h2 className="text-base font-bold text-slate-900">
              4. Aturan Penggunaan
            </h2>
            <p className="text-slate-600">
              Pengguna dilarang untuk:
            </p>
            <ul className="list-disc pl-5 space-y-1.5 text-slate-600">
              <li>Mencoba membongkar kode sumber, merekayasa balik, atau mendistribusikan salinan aplikasi tanpa izin resmi tertulis.</li>
              <li>Memasukkan konten palsu yang bertujuan untuk menipu atau merugikan pihak lain.</li>
              <li>Melakukan tindakan yang dapat mengganggu kestabilan sistem atau jaringan server Nikahin.</li>
            </ul>
          </section>

          {/* 5. Bantuan & Dukungan */}
          <section className="p-5 sm:p-6 rounded-3xl bg-white border border-slate-200/80 shadow-xs space-y-3">
            <h2 className="text-base font-bold text-slate-900">
              5. Bantuan dan Pertanyaan Layanan
            </h2>
            <p className="text-slate-600">
              Bila ada pertanyaan mengenai ketentuan ini atau kendala penggunaan aplikasi, tim kami siap membantu Anda melalui saluran kontak resmi.
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
