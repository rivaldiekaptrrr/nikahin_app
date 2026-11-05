import React from 'react';
import Link from 'next/link';
import Image from 'next/image';
import { ArrowLeft, Trash2, Smartphone, Mail, AlertTriangle, CheckCircle2, Clock } from 'lucide-react';
import Footer from '@/components/Footer';
import type { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'Kebijakan Penghapusan Data | Nikahin App',
  description: 'Prosedur resmi permohonan dan penghapusan data akun pengguna di aplikasi Nikahin sesuai standar privasi Google Play dan perlindungan data pribadi.',
};

export default function DataDeletionPage() {
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
          <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-rose-50 text-rose-700 text-xs font-bold uppercase tracking-wider mb-3 border border-rose-200">
            <Trash2 className="w-3.5 h-3.5 text-rose-600" />
            <span>Penghapusan Akun & Data</span>
          </div>
          <h1 className="text-3xl sm:text-4xl font-black text-slate-900 tracking-tight">
            Kebijakan Penghapusan Data Pengguna
          </h1>
          <p className="text-xs sm:text-sm text-slate-500 mt-2 font-medium">
            Terakhir diperbarui: {lastUpdated}
          </p>
        </div>

        <div className="space-y-8 text-slate-700 text-sm leading-relaxed">
          {/* Ringkasan Hak Pengguna */}
          <section className="p-5 sm:p-6 rounded-3xl bg-white border border-rose-200/60 shadow-xs">
            <h2 className="text-base font-bold text-slate-900 mb-2.5">
              Hak Kendali Penuh atas Data Anda
            </h2>
            <p className="text-slate-600">
              Sesuai dengan komitmen perlindungan privasi dan kebijakan Data Safety Google Play Store, 
              pengguna Nikahin memiliki hak penuh untuk meminta penghapusan akun serta seluruh data 
              perencanaan pernikahan pribadi secara permanen dari server cloud kami kapan saja.
            </p>
          </section>

          {/* Opsi 1: Hapus Mandiri dari Aplikasi */}
          <section className="p-5 sm:p-6 rounded-3xl bg-white border border-slate-200/80 shadow-xs space-y-4">
            <div className="flex items-center gap-3">
              <div className="w-9 h-9 rounded-xl bg-[#ffd9e2]/50 text-[#d81b60] flex items-center justify-center font-bold">
                <Smartphone className="w-5 h-5" />
              </div>
              <h2 className="text-base font-bold text-slate-900">
                Cara 1: Penghapusan Mandiri Langsung dari Aplikasi (Instan)
              </h2>
            </div>
            <p className="text-slate-600">
              Anda dapat menghapus data Anda secara mandiri langsung dari ponsel Anda tanpa perlu menunggu persetujuan admin:
            </p>
            <ol className="list-decimal pl-5 space-y-2 text-slate-600">
              <li>Buka aplikasi <strong>Nikahin</strong> di perangkat Anda.</li>
              <li>Masuk ke menu <strong>Pengaturan</strong> (ikon roda gigi di pojok kanan bawah).</li>
              <li>Gulir ke bagian <strong>Akun & Keamanan</strong>, lalu pilih <strong>Hapus Akun & Data</strong>.</li>
              <li>Baca peringatan konfirmasi, lalu konfirmasi penghapusan.</li>
              <li>Sistem akan otomatis menghapus sesi login, membersihkan cache penyimpanan lokal ponsel, dan menjadwalkan pembersihan permanen data cloud Anda.</li>
            </ol>
          </section>

          {/* Opsi 2: Pengajuan Tertulis via Email / WhatsApp */}
          <section className="p-5 sm:p-6 rounded-3xl bg-white border border-slate-200/80 shadow-xs space-y-4">
            <div className="flex items-center gap-3">
              <div className="w-9 h-9 rounded-xl bg-[#fdf0de] text-[#ad1457] flex items-center justify-center font-bold">
                <Mail className="w-5 h-5" />
              </div>
              <h2 className="text-base font-bold text-slate-900">
                Cara 2: Permohonan Melalui Email / Layanan Bantuan
              </h2>
            </div>
            <p className="text-slate-600">
              Jika Anda sudah menghapus aplikasi dari ponsel atau mengalami kendala akses masuk, Anda dapat mengajukan permohonan penghapusan data secara tertulis kepada tim pengembang:
            </p>
            <div className="p-4 rounded-2xl bg-slate-50 border border-slate-200 space-y-2 text-xs sm:text-sm">
              <p><strong>Kirim email ke:</strong> <a href="mailto:rivaldiekaputr@gmail.com" className="text-[#d81b60] underline">rivaldiekaputr@gmail.com</a></p>
              <p><strong>Subjek Email:</strong> Permohonan Hapus Data Akun Nikahin</p>
              <p><strong>Informasi yang Wajib Disertakan:</strong></p>
              <ul className="list-disc pl-5 space-y-1 text-slate-600">
                <li>Alamat email Google yang terdaftar di aplikasi Nikahin.</li>
                <li>Nama Anda atau nama pasangan yang terdaftar di akun.</li>
                <li>Pernyataan konfirmasi bahwa Anda ingin menghapus seluruh data secara permanen.</li>
              </ul>
            </div>
          </section>

          {/* Rincian Data yang Dihapus */}
          <section className="p-5 sm:p-6 rounded-3xl bg-white border border-slate-200/80 shadow-xs space-y-3">
            <h2 className="text-base font-bold text-slate-900 flex items-center gap-2">
              <CheckCircle2 className="w-4 h-4 text-emerald-600" />
              <span>Rincian Data yang Dihapus Secara Permanen</span>
            </h2>
            <p className="text-slate-600">
              Setelah proses penghapusan selesai, data berikut akan dimusnahkan secara permanen dari server Cloud Firestore dan tidak dapat dipulihkan kembali:
            </p>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 pt-1">
              <div className="p-3 rounded-2xl bg-[#fff9fa] border border-slate-100 text-xs">
                <strong>Data Profil & Akun:</strong>
                <p className="text-slate-500 mt-1">Nama lengkap, email, foto profil, dan kredensial autentikasi Google.</p>
              </div>
              <div className="p-3 rounded-2xl bg-[#fff9fa] border border-slate-100 text-xs">
                <strong>Catatan Keuangan:</strong>
                <p className="text-slate-500 mt-1">Total anggaran, termin DP, riwayat pengeluaran, dan status pembayaran vendor.</p>
              </div>
              <div className="p-3 rounded-2xl bg-[#fff9fa] border border-slate-100 text-xs">
                <strong>Daftar Tamu & RSVP:</strong>
                <p className="text-slate-500 mt-1">Nama tamu, kategori VIP/keluarga, jumlah undangan, dan konfirmasi kehadiran.</p>
              </div>
              <div className="p-3 rounded-2xl bg-[#fff9fa] border border-slate-100 text-xs">
                <strong>Susunan Acara & Panitia:</strong>
                <p className="text-slate-500 mt-1">Rundown acara akad/resepsi, pembagian seragam, dan daftar tugas PIC.</p>
              </div>
            </div>
          </section>

          {/* Waktu Proses & Peringatan */}
          <section className="p-5 sm:p-6 rounded-3xl bg-white border border-slate-200/80 shadow-xs space-y-3">
            <h2 className="text-base font-bold text-slate-900 flex items-center gap-2">
              <Clock className="w-4 h-4 text-[#d81b60]" />
              <span>Jangka Waktu Pemrosesan (SLA)</span>
            </h2>
            <p className="text-slate-600">
              Permohonan penghapusan data yang diajukan melalui email/bantuan akan diproses dan diselesaikan dalam jangka waktu <strong>maksimal 7 (tujuh) hari kerja</strong> sejak permohonan diverifikasi. Anda akan menerima email konfirmasi ketika pembersihan database selesai.
            </p>
            <div className="p-4 rounded-2xl bg-amber-50/70 border border-amber-200/80 flex items-start gap-3 text-xs text-amber-900 mt-3">
              <AlertTriangle className="w-4 h-4 text-amber-600 shrink-0 mt-0.5" />
              <span>
                <strong>Perhatian:</strong> Tindakan penghapusan akun bersifat final dan tidak dapat dibatalkan. Jika Anda dan pasangan masih terhubung melalui kode pasangan (*Couple Sync*), tautan akun pasangan akan otomatis terputus.
              </span>
            </div>
          </section>
        </div>
      </main>

      <Footer />
    </div>
  );
}
