'use client';

import React, { useState } from 'react';
import { ChevronDown, HelpCircle } from 'lucide-react';

interface FaqItem {
  q: string;
  a: string;
}

export default function FaqAccordion() {
  const [openIdx, setOpenIdx] = useState<number | null>(0);

  const faqs: FaqItem[] = [
    {
      q: 'Apakah pasangan harus membayar lagi secara terpisah?',
      a: 'Tidak perlu. Cukup satu kali pembayaran untuk satu acara pernikahan. Setelah aktif, kamu tinggal membagikan 6 karakter kode pasangan kepada calon suami/istrimu. Akun pasangan akan langsung terhubung tanpa biaya tambahan apa pun.',
    },
    {
      q: 'Bagaimana jika tanggal pernikahan kami masih tahun depan atau belum ditentukan?',
      a: 'Akses akun berlaku selamanya tanpa batas waktu dan tanpa biaya langganan bulanan. Kamu bisa mencicil persiapan pernikahan kapan saja dengan tenang.',
    },
    {
      q: 'Bagaimana cara memasang aplikasi Nikahin di iPhone?',
      a: 'Sangat praktis tanpa perlu App Store. Cukup buka tautan aplikasi di peramban Safari, ketuk tombol "Bagikan" (ikon kotak dengan panah ke atas), lalu pilih "Tambah ke Layar Utama" (Add to Home Screen). Ikon Nikahin akan langsung muncul di layar utama iPhone kamu dan bisa dibuka kapan pun seperti aplikasi biasa.',
    },
    {
      q: 'Apakah data saya tetap aman jika berganti perangkat ponsel?',
      a: 'Sangat aman. Seluruh data anggaran, vendor, rundown, dan daftar tamu tersimpan otomatis di akunmu. Kamu cukup masuk kembali menggunakan email yang sama di ponsel baru, dan semua data akan langsung sinkron seketika.',
    },
    {
      q: 'Apakah aplikasi bisa digunakan saat tidak ada sinyal internet?',
      a: 'Ya, Nikahin dilengkapi dengan penyimpanan lokal pintar. Data yang sudah dibuka sebelumnya tetap dapat kamu lihat dan baca saat berada di lokasi pernikahan tanpa sinyal internet.',
    },
    {
      q: 'Bagaimana cara pembayaran untuk membuka akses penuh?',
      a: 'Nikahin mendukung pembayaran otomatis 24 jam melalui QRIS (bisa dari semua e-wallet dan mobile banking), Virtual Account BCA, Mandiri, BRI, BNI, BSI, CIMB, Permata, serta GoPay dan ShopeePay.',
    },
  ];

  return (
    <section id="faq" className="py-20 md:py-28 bg-[#fff9fa]/50 border-t border-slate-200/60">
      <div className="max-w-4xl mx-auto px-4 sm:px-6">
        <div className="text-center max-w-xl mx-auto mb-14">
          <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-[#fdf0de] text-[#ad1457] text-xs font-bold uppercase tracking-wider mb-3">
            <HelpCircle className="w-3.5 h-3.5" />
            <span>Tanya Jawab</span>
          </div>
          <h2 className="text-3xl sm:text-4xl font-extrabold text-slate-900 tracking-tight">
            Pertanyaan yang Sering Diajukan
          </h2>
          <p className="text-slate-600 text-sm sm:text-base mt-2.5">
            Jawaban lengkap untuk keraguan calon pengantin seputar aplikasi dan lisensi Nikahin.
          </p>
        </div>

        {/* Accordion List */}
        <div className="space-y-3.5">
          {faqs.map((faq, idx) => {
            const isOpen = openIdx === idx;
            return (
              <div
                key={idx}
                className="rounded-2xl bg-white border border-slate-200/80 shadow-xs overflow-hidden transition-colors"
              >
                <button
                  onClick={() => setOpenIdx(isOpen ? null : idx)}
                  className="w-full flex items-center justify-between p-5 sm:p-6 text-left text-sm sm:text-base font-bold text-slate-900 hover:text-[#d81b60] transition-colors focus:outline-none"
                >
                  <span>{faq.q}</span>
                  <ChevronDown
                    className={`w-5 h-5 text-slate-400 shrink-0 ml-4 transition-transform duration-200 ${
                      isOpen ? 'rotate-180 text-[#d81b60]' : ''
                    }`}
                  />
                </button>

                {isOpen && (
                  <div className="px-5 sm:px-6 pb-6 text-xs sm:text-sm text-slate-600 leading-relaxed border-t border-slate-100 pt-3">
                    {faq.a}
                  </div>
                )}
              </div>
            );
          })}
        </div>
      </div>
    </section>
  );
}

