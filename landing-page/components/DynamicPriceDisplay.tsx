'use client';

import React, { useEffect, useState } from 'react';
import { getPublicBackendUrl, getStoredAttribution } from '@/lib/attribution';

interface PromoResponse {
  valid: boolean;
  code?: string;
  discountAmount: number;
  finalPrice: number;
  message?: string;
}

interface PublicPricingResponse {
  defaultPrice: number;
  promo: PromoResponse | null;
}

function formatRp(amount: number): string {
  return `Rp ${amount.toLocaleString('id-ID')}`;
}

export default function DynamicPriceDisplay() {
  const [pricing, setPricing] = useState<PublicPricingResponse>({
    defaultPrice: 99000,
    promo: null,
  });

  useEffect(() => {
    let active = true;

    const loadPricing = async () => {
      try {
        const attr = getStoredAttribution();
        const promoQuery = attr?.promoCode ? `?promo=${encodeURIComponent(attr.promoCode)}` : '';
        const res = await fetch(`${getPublicBackendUrl()}/api/public-pricing${promoQuery}`);
        if (!res.ok) return;
        const data = (await res.json()) as PublicPricingResponse;
        if (active && typeof data.defaultPrice === 'number') {
          setPricing(data);
        }
      } catch {
        // Fallback aman ke harga default Rp 99.000 jika jaringan bermasalah
      }
    };

    loadPricing();
    const handler = () => loadPricing();
    window.addEventListener('nikahin:promo-updated', handler);
    return () => {
      active = false;
      window.removeEventListener('nikahin:promo-updated', handler);
    };
  }, []);

  const hasValidPromo = pricing.promo?.valid === true && pricing.promo.finalPrice < pricing.defaultPrice;

  return (
    <div className="pb-6 mb-8 border-b border-stone-200/80">
      {hasValidPromo && pricing.promo?.code ? (
        <>
          <div className="flex flex-wrap items-baseline gap-x-3 gap-y-1">
            <span className="text-3xl sm:text-4xl md:text-5xl font-extrabold text-stone-900 tracking-tight tabular-nums">
              {formatRp(pricing.promo.finalPrice)}
            </span>
            <span className="text-base sm:text-lg font-semibold text-amber-700">
              / selamanya
            </span>
          </div>
          <p className="mt-2.5 text-sm font-medium text-emerald-700">
            Kode promo <span className="font-bold">{pricing.promo.code}</span> aktif — langsung hemat{' '}
            {formatRp(pricing.promo.discountAmount)} saat aktivasi di aplikasi.
          </p>
        </>
      ) : (
        <>
          <div className="flex flex-wrap items-baseline gap-x-3 gap-y-1">
            <span className="text-3xl sm:text-4xl md:text-5xl font-extrabold text-stone-900 tracking-tight">
              Sekali Aktivasi Berdua
            </span>
            <span className="text-base sm:text-lg font-semibold text-amber-700">
              / selamanya
            </span>
          </div>
          <p className="mt-2.5 text-xs sm:text-sm text-stone-600">
            Cek akun <span className="font-semibold text-stone-800">Threads &amp; Instagram</span> resmi Nikahin untuk mendapatkan kode promo diskon spesial sebelum aktivasi.
          </p>
        </>
      )}
    </div>
  );
}
