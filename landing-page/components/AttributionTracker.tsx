'use client';

import { useEffect } from 'react';
import { captureUrlAttribution } from '@/lib/attribution';

/**
 * Menangkap parameter ?promo=, ?ref=, dan UTM pada URL kunjungan pertama
 * dan menyimpannya ke localStorage secara senyap.
 */
export default function AttributionTracker() {
  useEffect(() => {
    captureUrlAttribution();
  }, []);

  return null;
}
