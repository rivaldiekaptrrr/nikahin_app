/**
 * Firebase Analytics / Google Analytics 4 (GA4) Helper
 * Project ID: nikahin-wedding-app
 * Measurement ID: G-2WTR52H3DG
 */

export const GA_MEASUREMENT_ID =
  process.env.NEXT_PUBLIC_FIREBASE_MEASUREMENT_ID || 'G-2WTR52H3DG';

declare global {
  interface Window {
    dataLayer?: unknown[];
    gtag?: (...args: unknown[]) => void;
  }
}

/**
 * Mencatat kunjungan halaman (page_view) ke Firebase Analytics
 */
export const pageview = (url: string) => {
  if (typeof window !== 'undefined' && typeof window.gtag === 'function' && GA_MEASUREMENT_ID) {
    window.gtag('config', GA_MEASUREMENT_ID, {
      page_path: url,
    });
  }
};

/**
 * Merekam event kustom atau standar ke Firebase Analytics
 */
export const event = (eventName: string, params: Record<string, unknown> = {}) => {
  if (typeof window !== 'undefined' && typeof window.gtag === 'function') {
    window.gtag('event', eventName, params);
  }
};
