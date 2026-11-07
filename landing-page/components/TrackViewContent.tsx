'use client';

import { useEffect } from 'react';
import { trackViewContent } from '@/lib/fpixel';

export default function TrackViewContent() {
  useEffect(() => {
    trackViewContent({
      page: 'Home Landing Page',
      title: 'Nikahin - Perencana Pernikahan Bersama Pasangan',
    });
  }, []);

  return null;
}

