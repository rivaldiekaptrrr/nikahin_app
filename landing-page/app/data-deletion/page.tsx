import React from 'react';
import Link from 'next/link';
import Image from 'next/image';
import { ArrowLeft, AlertTriangle } from 'lucide-react';
import Footer from '@/components/Footer';
import type { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'Kebijakan Penghapusan Data | Nikahin App',
  description: 'Prosedur resmi permohonan dan penghapusan data akun pengguna di aplikasi Nikahin sesuai standar privasi Google Play dan perlindungan data pribadi.',
};

export default function DataDeletionPage() {
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
          <div className="inline-flex items-center px-3 py-1 rounded-full bg-rose-50 text-rose-700 text-xs font-bold uppercase tracking-wider mb-3 border border-rose-200">
            <span>Penghapusan Akun & Data</span>
          </div>
          <h1 className="text-3xl sm:text-4xl font-black text-slate-900 tracking-tight">
            Kebijakan Penghapusan Data Pengguna
          </h1>
        </div>

        <div className="space-y-8 text-slate-700 text-sm leading-relaxed">
          {/* Ringkasan Hak Pengguna */}
          <section className="p-5 sm:p-6 rounded-3xl bg-white border border-rose-200/60 shadow-xs">
            <h2 className="text-base font-bold text-slate-900 mb-2.5">
              Kendali Penuh Pengguna atas Data
            </h2>
            <p className="text-slate-600 leading-relaxed">
              Sesuai dengan standar perlindungan data pribadi dan kebijakan Google Play, setiap pengguna 
              aplikasi Nikahin berhak menghapus akun serta seluruh data perencanaan pernikahan yang tersimpan 
              di peladen cloud kami kapan saja. Kami menyediakan dua metode penghapusan yang mudah diikuti.
            </p>
          </section>

          {/* Cara 1: Alur Nyata di Aplikasi Flutter */}
          <section className="p-5 sm:p-6 rounded-3xl bg-white border border-slate-200/80 shadow-xs space-y-4">
            <h2 className="text-base font-bold text-slate-900">
              Metode 1: Hapus Mandiri Langsung dari Aplikasi
            </h2>
            <p className="text-slate-600">
              Bila Anda masih memiliki akses ke aplikasi Nikahin di ponsel Anda, ikuti langkah berikut:
            </p>
            <ol className="list-decimal pl-5 space-y-2 text-slate-600">
              <li>Buka aplikasi <strong>Nikahin</strong> di perangkat Anda.</li>
              <li>Pilih menu <strong>Pengaturan</strong> pada bilah navigasi bawah (ikon roda gigi).</li>
              <li>Gulir ke bagian bawah hingga menemukan bagian <strong>Zona Berbahaya</strong>.</li>
              <li>Ketuk opsi <strong>Hapus Seluruh Data Rencana</strong>.</li>
              <li>Konfirmasi tindakan pada dialog konfirmasi untuk mengosongkan seluruh anggaran, vendor, daftar tamu, rundown, dan catatan acara.</li>
              <li>Untuk keluar sepenuhnya dari sesi masuk, ketuk tombol <strong>Keluar dari Akun</strong> di bagian paling bawah.</li>
            </ol>
          </section>

          {/* Cara 2: Permohonan Lewat Halaman Kontak Resmi */}
          <section className="p-5 sm:p-6 rounded-3xl bg-white border border-slate-200/80 shadow-xs space-y-4">
            <h2 className="text-base font-bold text-slate-900">
              Metode 2: Permohonan Melalui Halaman Kontak Resmi
            </h2>
            <p className="text-slate-600">
              Bila aplikasi telah dihapus dari ponsel atau Anda mengalami kendala saat masuk akun, Anda dapat mengajukan permohonan pembersihan data secara tertulis kepada tim dukungan Nikahin:
            </p>
            <ol className="list-decimal pl-5 space-y-2 text-slate-600">
              <li>
                Buka halaman bantuan resmi Nikahin melalui tombol di bawah.
              </li>
              <li>
                Pilih saluran bantuan yang Anda inginkan (WhatsApp Customer Support atau Pesan Email).
              </li>
              <li>
                Sampaikan permohonan penghapusan akun dengan menyertakan:
                <ul className="list-disc pl-5 mt-1.5 space-y-1 text-slate-600">
                  <li>Alamat email Akun Google yang terdaftar di aplikasi Nikahin.</li>
                  <li>Nama Anda atau nama pasangan yang tercatat di profil pernikahan.</li>
                </ul>
              </li>
              <li>
                Tim dukungan kami akan segera memverifikasi kepemilikan akun dan memproses pemusnahan data secara permanen.
              </li>
            </ol>
            <div className="pt-2">
              <Link
                href="/contact"
                className="inline-flex items-center gap-2 px-5 py-2.5 rounded-xl bg-[#d81b60] hover:bg-[#c2185b] text-white font-bold text-xs shadow-xs transition-colors"
              >
                <span>Buka Halaman Kontak Resmi</span>
              </Link>
            </div>
          </section>

          {/* Rincian Data yang Dihapus */}
          <section className="p-5 sm:p-6 rounded-3xl bg-white border border-slate-200/80 shadow-xs space-y-3">
            <h2 className="text-base font-bold text-slate-900">
              Rincian Data yang Dihapus Permanen
            </h2>
            <p className="text-slate-600">
              Ketika proses penghapusan selesai, data berikut akan dimusnahkan secara permanen dari database cloud dan tidak dapat dipulihkan kembali:
            </p>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 pt-1">
              <div className="p-3.5 rounded-2xl bg-[#fff9fa] border border-slate-100 text-xs">
                <strong>Profil & Autentikasi:</strong>
                <p className="text-slate-500 mt-1">Alamat email, nama profil, dan token login Akun Google.</p>
              </div>
              <div className="p-3.5 rounded-2xl bg-[#fff9fa] border border-slate-100 text-xs">
                <strong>Anggaran Finansial:</strong>
                <p className="text-slate-500 mt-1">Rincian biaya, termin pembayaran vendor, dan catatan pengeluaran.</p>
              </div>
              <div className="p-3.5 rounded-2xl bg-[#fff9fa] border border-slate-100 text-xs">
                <strong>Daftar Tamu & RSVP:</strong>
                <p className="text-slate-500 mt-1">Nama tamu undangan, pengelompokan keluarga, dan status kehadiran.</p>
              </div>
              <div className="p-3.5 rounded-2xl bg-[#fff9fa] border border-slate-100 text-xs">
                <strong>Rundown & Panitia:</strong>
                <p className="text-slate-500 mt-1">Susunan jadwal acara akad/resepsi dan catatan tugas panitia keluarga.</p>
              </div>
            </div>
          </section>

          {/* Jangka Waktu Pemrosesan */}
          <section className="p-5 sm:p-6 rounded-3xl bg-white border border-slate-200/80 shadow-xs space-y-3">
            <h2 className="text-base font-bold text-slate-900">
              Waktu Pemrosesan Permohonan
            </h2>
            <p className="text-slate-600 leading-relaxed">
              Permohonan penghapusan data yang dikirimkan melalui layanan bantuan akan diselesaikan dalam waktu <strong>maksimal 7 hari kerja</strong> sejak permohonan diverifikasi. Anda akan menerima pesan konfirmasi setelah database berhasil dibersihkan.
            </p>
            <div className="p-4 rounded-2xl bg-amber-50/70 border border-amber-200/80 flex items-start gap-3 text-xs text-amber-900 mt-3">
              <AlertTriangle className="w-4 h-4 text-amber-600 shrink-0 mt-0.5" />
              <span>
                <strong>Catatan Penting:</strong> Tindakan penghapusan data bersifat permanen dan tidak dapat dibatalkan. Jika akun Anda sedang terhubung dengan akun pasangan, tautan kedua akun akan otomatis terputus demi menjaga keamanan data.
              </span>
            </div>
          </section>
        </div>
      </main>

      <Footer />
    </div>
  );
}
