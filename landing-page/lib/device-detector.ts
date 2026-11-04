export type DeviceType = 'android' | 'ios' | 'desktop';

export function detectDevice(userAgent: string): DeviceType {
  if (/Android/i.test(userAgent)) return 'android';
  if (/iPhone|iPad|iPod/i.test(userAgent)) return 'ios';
  return 'desktop';
}

