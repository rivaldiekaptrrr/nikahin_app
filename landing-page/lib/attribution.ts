const STORAGE_KEY = 'nikahin_attribution_v1';
const TTL_MS = 30 * 24 * 60 * 60 * 1000; // 30 hari

export interface StoredAttribution {
  promoCode: string | null;
  ref: string | null;
  utmSource: string | null;
  utmMedium: string | null;
  utmCampaign: string | null;
  capturedAt: number;
}

export function getPublicBackendUrl(): string {
  return process.env.NEXT_PUBLIC_BACKEND_URL || 'https://track-it-backend-sand.vercel.app';
}

export function captureUrlAttribution(): StoredAttribution | null {
  if (typeof window === 'undefined') return null;

  const params = new URLSearchParams(window.location.search);
  const rawPromo = params.get('promo') || params.get('voucher');
  const rawRef = params.get('ref');
  const utmSource = params.get('utm_source');
  const utmMedium = params.get('utm_medium');
  const utmCampaign = params.get('utm_campaign');

  const promoCode = rawPromo ? rawPromo.trim().toUpperCase() : null;
  const ref = rawRef ? rawRef.trim().toLowerCase() : null;

  if (promoCode || ref || utmSource) {
    const payload: StoredAttribution = {
      promoCode,
      ref,
      utmSource: utmSource?.trim() || null,
      utmMedium: utmMedium?.trim() || null,
      utmCampaign: utmCampaign?.trim() || null,
      capturedAt: Date.now(),
    };
    try {
      window.localStorage.setItem(STORAGE_KEY, JSON.stringify(payload));
      window.dispatchEvent(new CustomEvent('nikahin:promo-updated', { detail: payload }));
    } catch {
      // Ignore storage quota errors
    }
    return payload;
  }

  return getStoredAttribution();
}

export function getStoredAttribution(): StoredAttribution | null {
  if (typeof window === 'undefined') return null;
  try {
    const raw = window.localStorage.getItem(STORAGE_KEY);
    if (!raw) return null;
    const parsed = JSON.parse(raw) as StoredAttribution;
    if (!parsed.capturedAt || Date.now() - parsed.capturedAt > TTL_MS) {
      window.localStorage.removeItem(STORAGE_KEY);
      return null;
    }
    return parsed;
  } catch {
    return null;
  }
}

export function appendPromoToUrl(baseUrl: string): string {
  const attr = getStoredAttribution();
  if (!attr?.promoCode && !attr?.ref) return baseUrl;

  try {
    const target = new URL(baseUrl);
    if (attr.promoCode) target.searchParams.set('promo', attr.promoCode);
    if (attr.ref) target.searchParams.set('ref', attr.ref);
    if (attr.utmSource) target.searchParams.set('utm_source', attr.utmSource);
    return target.toString();
  } catch {
    return baseUrl;
  }
}
