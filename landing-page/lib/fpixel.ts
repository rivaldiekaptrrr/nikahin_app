export const FB_PIXEL_ID = process.env.NEXT_PUBLIC_FACEBOOK_PIXEL_ID || '';

// Deklarasi tipe global untuk window.fbq
declare global {
  interface Window {
    fbq?: ((...args: unknown[]) => void) & {
      callMethod?: (...args: unknown[]) => void;
      queue?: unknown[];
      loaded?: boolean;
      version?: string;
      push?: (...args: unknown[]) => void;
    };
    _fbq?: unknown;
  }
}

/**
 * Memicu event PageView standar Meta Pixel
 */
export const pageview = () => {
  if (typeof window !== 'undefined' && window.fbq) {
    window.fbq('track', 'PageView');
  }
};

/**
 * Memicu Standard Event Meta Pixel
 * Contoh: 'ViewContent', 'Lead', 'Contact', 'CompleteRegistration'
 */
export const event = (name: string, options: Record<string, unknown> = {}) => {
  if (typeof window !== 'undefined' && window.fbq) {
    window.fbq('track', name, options);
  }
};

/**
 * Memicu Custom Event Meta Pixel
 * Contoh: 'DownloadClick', 'ScanQrClick'
 */
export const trackCustom = (name: string, options: Record<string, unknown> = {}) => {
  if (typeof window !== 'undefined' && window.fbq) {
    window.fbq('trackCustom', name, options);
  }
};

/**
 * Helper khusus untuk mencatat event interaksi unduhan (DownloadClick & Lead)
 * Memancarkan baik Custom Event 'DownloadClick' maupun Standard Event 'Lead' untuk optimasi iklan Meta
 */
export const trackDownloadClick = (
  platform: 'android' | 'ios' | 'pwa',
  metadata: Record<string, unknown> = {}
) => {
  const payload = {
    platform,
    content_name: 'Nikahin Wedding Planner App',
    content_category: 'App Download',
    timestamp: new Date().toISOString(),
    ...metadata,
  };

  // 1. Custom event spesifik untuk pelacakan internal
  trackCustom('DownloadClick', payload);

  // 2. Standard event Meta 'Lead' agar mudah dipetakan sebagai conversion event di Meta Ads Manager
  event('Lead', {
    content_name: `Nikahin App (${platform.toUpperCase()})`,
    content_category: 'App Download',
  });
};

/**
 * Helper khusus untuk mencatat event ketertarikan konten (ViewContent)
 */
export const trackViewContent = (metadata: Record<string, unknown> = {}) => {
  event('ViewContent', {
    content_name: 'Nikahin Landing Page',
    content_category: 'Wedding Planner Mobile App',
    content_type: 'product',
    ...metadata,
  });
};

