import React from 'react';
import Image from 'next/image';
import ScrollReveal from './ScrollReveal';
import { Star, Heart, MapPin } from 'lucide-react';

interface Testimonial {
  couple: string;
  city: string;
  role: string;
  quote: string;
  highlight: string;
  avatar: string;
}

const TESTIMONIALS: Testimonial[] = [
  {
    couple: 'Rama & Sinta',
    city: 'Jakarta Selatan',
    role: 'Menikah Januari 2027',
    quote:
      'Nggak ada lagi drama lupa bayar DP gedung atau katering. Begitu salah satu bayar, catatan pengeluaran langsung terupdate di HP pasangan.',
    highlight: 'Bujet Selalu Sinkron',
    avatar:
      'https://images.unsplash.com/photo-1583939003579-730e3918a45a?auto=format&fit=crop&w=160&h=160&q=80',
  },
  {
    couple: 'Dimas & Dinda',
    city: 'Bandung',
    role: 'Menikah Maret 2027',
    quote:
      'Susunan acaranya detail sampai ke penanggung jawab tiap sesi. Pas kami cetak PDF buat panitia keluarga, semuanya langsung paham alurnya.',
    highlight: 'Buku Panduan PDF',
    avatar:
      'https://images.unsplash.com/photo-1621600411688-4be93cd68504?auto=format&fit=crop&w=160&h=160&q=80',
  },
  {
    couple: 'Fajar & Anisa',
    city: 'Surabaya',
    role: 'Menikah November 2026',
    quote:
      'Daftar syarat KUA-nya runtut banget. Kami yang awalnya bingung urus berkas nikah jadi tenang karena tinggal centang satu per satu.',
    highlight: 'Urus KUA Lancar',
    avatar:
      'https://images.unsplash.com/photo-1519741497674-611481863552?auto=format&fit=crop&w=160&h=160&q=80',
  },
  {
    couple: 'Rezky & Maya',
    city: 'Yogyakarta',
    role: 'Menikah Desember 2026',
    quote:
      'Tampilannya cantik dan bebas pilih tema. Yang paling kami suka, bayarnya cuma sekali di awal tanpa kepikiran langganan bulanan.',
    highlight: 'Tema Sesuai Selera',
    avatar:
      'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?auto=format&fit=crop&w=160&h=160&q=80',
  },
  {
    couple: 'Gilang & Tiara',
    city: 'Semarang',
    role: 'Menikah Februari 2027',
    quote:
      'Buku tamu digitalnya sangat ngebantu pas resepsi. Daftar tamu dan amplop langsung terekap rapi tanpa perlu hitung manual.',
    highlight: 'Buku Tamu Rapi',
    avatar:
      'https://images.unsplash.com/photo-1465495976277-4387d4b0b4c6?auto=format&fit=crop&w=160&h=160&q=80',
  },
];

export default function TestimonialMarquee() {
  // Duplikasi daftar agar animasi marquee berjalan mulus tanpa jeda
  const marqueeItems = [...TESTIMONIALS, ...TESTIMONIALS];

  return (
    <section className="pt-2 pb-10 sm:pt-6 sm:pb-16 md:pt-8 md:pb-20 relative overflow-hidden bg-gradient-to-b from-transparent via-stone-100/50 to-transparent">
      <div className="max-w-6xl mx-auto px-4 sm:px-6 mb-3 sm:mb-6">
        <ScrollReveal>
          <div className="text-center max-w-xl mx-auto">
            <h2 className="text-xs sm:text-sm md:text-base font-medium text-stone-600 tracking-tight flex items-center justify-center gap-1.5">
              <Heart className="w-3.5 h-3.5 fill-[#d81b60] text-[#d81b60] shrink-0" />
              <span>Cerita nyata dari pasangan yang sudah menikah</span>
            </h2>
          </div>
        </ScrollReveal>
      </div>

      {/* Infinite Marquee Track with Fade Gradient Edges - Pause on Hover & Focus (WCAG 2.2.2) */}
      <div 
        role="region" 
        aria-label="Pita ulasan pengalaman nyata pasangan pengantin"
        className="relative w-full overflow-hidden [mask-image:linear-gradient(to_right,transparent,black_10%,black_90%,transparent)] group"
      >
        <div className="animate-marquee group-hover:[animation-play-state:paused] group-focus-within:[animation-play-state:paused] flex gap-4 sm:gap-5 py-2 sm:py-3">
          {marqueeItems.map((item, idx) => (
            <div
              key={`${item.couple}-${idx}`}
              className="w-[280px] sm:w-[350px] shrink-0 rounded-2xl bg-white border border-[#1f1b16]/8 p-4 sm:p-6 shadow-[0_4px_20px_-6px_rgba(28,25,23,0.06)] hover:border-amber-400/40 transition-all flex flex-col justify-between select-none"
            >
              <div>
                {/* Header: Star Rating & Highlight Badge */}
                <div className="flex items-center justify-between mb-3.5">
                  <div className="flex items-center gap-1 text-amber-500">
                    {[...Array(5)].map((_, i) => (
                      <Star key={i} className="w-3.5 h-3.5 fill-amber-400 text-amber-500" />
                    ))}
                  </div>
                  <span className="text-[10px] font-semibold text-[#831843] bg-[#fce7ef] px-2.5 py-0.5 rounded-full">
                    {item.highlight}
                  </span>
                </div>

                {/* Testimonial Quote */}
                <p className="text-xs sm:text-sm text-stone-700 leading-relaxed font-normal italic mb-5">
                  &ldquo;{item.quote}&rdquo;
                </p>
              </div>

              {/* Author Footer with Couple Profile Photo */}
              <div className="pt-3.5 border-t border-stone-100 flex items-center justify-between gap-2.5">
                <div className="flex items-center gap-2.5 min-w-0">
                  <div className="relative w-9 h-9 sm:w-10 sm:h-10 rounded-full overflow-hidden shrink-0 ring-2 ring-stone-200/90 shadow-2xs bg-stone-100">
                    <Image
                      src={item.avatar}
                      alt={`Foto profil pasangan ${item.couple}`}
                      fill
                      sizes="40px"
                      className="object-cover object-center"
                    />
                  </div>
                  <div className="min-w-0">
                    <h4 className="text-xs sm:text-sm font-semibold text-stone-900 truncate">
                      {item.couple}
                    </h4>
                    <div className="flex items-center gap-1 text-[11px] text-stone-500 mt-0.5">
                      <MapPin className="w-3 h-3 text-stone-400 shrink-0" aria-hidden="true" />
                      <span className="truncate">{item.city}</span>
                    </div>
                  </div>
                </div>
                <span className="text-[10px] font-medium text-stone-400 text-right shrink-0">
                  {item.role}
                </span>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}

