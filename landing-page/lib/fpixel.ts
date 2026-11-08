export const FB_PIXEL_ID = process.env.NEXT_PUBLIC_FACEBOOK_PIXEL_ID || '';

// Deklarasi tipe global untuk window.fbq dan window.gtag
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
    dataLayer?: unknown[];
    gtag?: (...args: unknown[]) => void;
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
 * Helper khusus untuk mencatat event interaksi unduhan ke Meta Pixel dan Firebase Analytics
 * Mencatat:
 * 1. Meta Pixel: Custom 'DownloadClick' & Standard 'Lead'
 * 2. Firebase Analytics: 'app_download_click' & 'generate_lead'
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

  // 1. Meta Pixel Tracking
  trackCustom('DownloadClick', payload);
  event('Lead', {
    content_name: `Nikahin App (${platform.toUpperCase()})`,
    content_category: 'App Download',
  });

  // 2. Firebase Analytics (GA4) Tracking
  if (typeof window !== 'undefined' && typeof window.gtag === 'function') {
    window.gtag('event', 'app_download_click', {
      platform,
      file_name: platform === 'android' ? 'nikahin.apk' : 'nikahin-ios-pwa',
      content_name: 'Nikahin Wedding Planner App',
      ...metadata,
    });
    window.gtag('event', 'generate_lead', {
      event_category: 'App Download',
      event_label: platform.toUpperCase(),
      value: 1,
    });
  }
};

/**
 * Helper khusus untuk mencatat event ketertarikan konten (ViewContent & select_content)
 */
export const trackViewContent = (metadata: Record<string, unknown> = {}) => {
  // 1. Meta Pixel
  event('ViewContent', {
    content_name: 'Nikahin Landing Page',
    content_category: 'Wedding Planner Mobile App',
    content_type: 'product',
    ...metadata,
  });

  // 2. Firebase Analytics
  if (typeof window !== 'undefined' && typeof window.gtag === 'function') {
    window.gtag('event', 'select_content', {
      content_type: 'landing_page',
      item_id: 'nikahin_landing',
      ...metadata,
    });
  }
};
