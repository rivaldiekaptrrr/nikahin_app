import React from 'react';
import Link from 'next/link';
import Image from 'next/image';
import { ArrowLeft, FileText, CheckCircle, AlertCircle, Sparkles, Scale } from 'lucide-react';
import Footer from '@/components/Footer';
import type { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'Syarat & Ketentuan | Nikahin App',
  description: 'Syarat dan ketentuan penggunaan aplikasi Nikahin. Ketahui hak, kewajiban, ketentuan lisensi sekali bayar, dan batasan layanan kami.',
};

export default function TermsPage() {
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
            <Scale className="w-3.5 h-3.5 text-[#d81b60]" />
            <span>Perjanjian Layanan</span>
          </div>
          <h1 className="text-3xl sm:text-4xl font-black text-slate-900 tracking-tight">
            Syarat & Ketentuan
          </h1>
          <p className="text-xs sm:text-sm text-slate-500 mt-2 font-medium">
            Terakhir diperbarui: {lastUpdated}
          </p>
        </div>

        <div className="space-y-8 text-slate-700 text-sm leading-relaxed">
          {/* Pembukaan */}
          <section className="p-5 sm:p-6 rounded-3xl bg-white border border-[#ffd9e2]/60 shadow-xs">
            <h2 className="text-base font-bold text-slate-900 flex items-center gap-2 mb-2.5">
              <FileText className="w-4 h-4 text-[#d81b60]" />
              <span>Ketentuan Umum</span>
            </h2>
            <p className="text-slate-600">
              Selamat datang di Nikahin. Dengan mengunduh, memasang, mendaftar, atau menggunakan aplikasi Nikahin 
              (baik di Android, iOS, maupun web), Anda menyetujui untuk terikat oleh Syarat dan Ketentuan ini. 
              Mohon membaca dokumen ini dengan saksama sebelum mulai merencanakan pernikahan Anda bersama kami.
            </p>
          </section>

          {/* 1. Ketentuan Lisensi Sekali Bayar */}
          <section className="p-5 sm:p-6 rounded-3xl bg-white border border-slate-200/80 shadow-xs space-y-3">
            <h2 className="text-base font-bold text-slate-900 flex items-center gap-2">
              <Sparkles className="w-4 h-4 text-amber-500" />
              <span>1. Lisensi & Pembayaran (Lifetime Access)</span>
            </h2>
            <p className="text-slate-600">
              Nikahin menganut skema lisensi yang adil dan transparan bagi calon pengantin:
            </p>
            <ul className="list-disc pl-5 space-y-1.5 text-slate-600">
              <li>
                <strong>Satu Kali Bayar:</strong> Aktivasi lisensi berlaku seumur hidup (*Lifetime Access*) untuk 1 (satu) rangkaian acara pernikahan tanpa iuran atau langganan bulanan tersembunyi.
              </li>
              <li>
                <strong>Akses untuk 2 Akun:</strong> Pembelian lisensi secara otomatis mencakup hak akses penuh untuk 2 (dua) akun calon pengantin (pengguna utama dan pasangannya) melalui fitur penghubung kode unik 6 karakter.
              </li>
              <li>
                <strong>Metode Pembayaran Resmi:</strong> Seluruh pembayaran diproses melalui gerbang pembayaran resmi (*Midtrans*) yang mendukung QRIS, Virtual Account bank nasional, serta e-wallet terdaftar.
              </li>
            </ul>
          </section>

          {/* 2. Hak Milik & Tanggung Jawab Konten */}
          <section className="p-5 sm:p-6 rounded-3xl bg-white border border-slate-200/80 shadow-xs space-y-3">
            <h2 className="text-base font-bold text-slate-900">
              2. Hak Milik Data Pengguna
            </h2>
            <p className="text-slate-600">
              Seluruh data rencana pernikahan, rincian anggaran finansial, susunan acara, catatan vendor, dan daftar nama tamu yang Anda masukkan ke dalam Nikahin adalah sepenuhnya milik Anda. Kami tidak mengklaim hak kepemilikan apa pun atas konten dan data pribadi Anda.
            </p>
          </section>

          {/* 3. Batasan Tanggung Jawab Layanan */}
          <section className="p-5 sm:p-6 rounded-3xl bg-white border border-slate-200/80 shadow-xs space-y-3">
            <h2 className="text-base font-bold text-slate-900 flex items-center gap-2">
              <AlertCircle className="w-4 h-4 text-[#d81b60]" />
              <span>3. Batasan Tanggung Jawab</span>
            </h2>
            <ul className="list-disc pl-5 space-y-2 text-slate-600">
              <li>
                <strong>Alat Perencanaan Mandiri:</strong> Nikahin adalah perangkat lunak bantu (*tools*) digital untuk pencatatan dan koordinasi pernikahan mandiri. Nikahin bukan Wedding Organizer (WO) fisik, agen biro jasa pernikahan, atau penyedia jasa perantara vendor.
              </li>
              <li>
                <strong>Hubungan dengan Vendor Pihak Ketiga:</strong> Segala transaksi, perjanjian, kualitas layanan, dan kesepakatan harga antara Anda dengan vendor pernikahan (gedung, katering, fotografer, dekorasi, rias) merupakan tanggung jawab langsung antara Anda dan pihak vendor terkait.
              </li>
              <li>
                <strong>Kelengkapan Syarat KUA & Catatan Sipil:</strong> Daftar berkas legal yang disediakan aplikasi bertujuan sebagai panduan umum. Persyaratan administratif resmi tetap tunduk pada ketentuan kantor KUA dan Dinas Kependudukan dan Catatan Sipil setempat.
              </li>
            </ul>
          </section>

          {/* 4. Larangan Penggunaan */}
          <section className="p-5 sm:p-6 rounded-3xl bg-white border border-slate-200/80 shadow-xs space-y-3">
            <h2 className="text-base font-bold text-slate-900">
              4. Larangan Penyalahgunaan
            </h2>
            <p className="text-slate-600">
              Saat menggunakan aplikasi Nikahin, Anda dilarang untuk:
            </p>
            <ul className="list-disc pl-5 space-y-1.5 text-slate-600">
              <li>Melakukan rekayasa balik (*reverse engineering*), dekompilasi, atau menyalin kode sumber aplikasi tanpa izin tertulis.</li>
              <li>Menggunakan aplikasi untuk menyebarkan konten yang melanggar hukum, penipuan, spam, atau materi yang merugikan orang lain.</li>
              <li>Mencoba merusak, membebani secara berlebihan, atau menyusup ke infrastruktur peladen Nikahin.</li>
            </ul>
          </section>

          {/* 5. Perubahan Ketentuan & Kontak */}
          <section className="p-5 sm:p-6 rounded-3xl bg-white border border-slate-200/80 shadow-xs space-y-2">
            <h2 className="text-base font-bold text-slate-900">
              5. Bantuan & Pertanyaan Layanan
            </h2>
            <p className="text-slate-600">
              Jika ada ketentuan yang kurang jelas atau Anda memerlukan klarifikasi lebih lanjut mengenai Syarat & Ketentuan ini, silakan hubungi tim pengembang Nikahin:
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
