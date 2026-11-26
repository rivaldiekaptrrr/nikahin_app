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
  const activePrice = hasValidPromo ? pricing.promo!.finalPrice : pricing.defaultPrice;

  return (
    <div className="pb-6 mb-8 border-b border-stone-200/80">
      <div className="flex flex-wrap items-baseline gap-x-3 gap-y-1">
        {hasValidPromo && (
          <>
            <span className="sr-only">Harga normal:</span>
            <span className="text-lg sm:text-xl font-semibold text-stone-400 line-through decoration-rose-500 decoration-2">
              {formatRp(pricing.defaultPrice)}
            </span>
          </>
        )}
        <span className="sr-only">Harga aktivasi sekali bayar:</span>
        <span className="text-4xl sm:text-5xl md:text-6xl font-extrabold text-stone-900 tracking-tight tabular-nums">
          {formatRp(activePrice)}
        </span>
        <span className="text-base sm:text-lg font-semibold text-amber-700">
          / selamanya
        </span>
      </div>

      {hasValidPromo && pricing.promo?.code ? (
        <p className="mt-2.5 text-sm font-medium text-emerald-700">
          Kode promo <span className="font-bold">{pricing.promo.code}</span> aktif — hemat{' '}
          {formatRp(pricing.promo.discountAmount)} dari harga normal.
        </p>
      ) : (
        <p className="mt-2.5 text-xs sm:text-sm text-stone-600">
          Ikuti akun <span className="font-semibold text-stone-800">Threads &amp; Instagram</span> resmi Nikahin untuk mendapatkan kode promo diskon khusus.
        </p>
      )}
    </div>
  );
}
