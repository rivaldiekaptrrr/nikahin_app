import type { Metadata, Viewport } from 'next';
import { Plus_Jakarta_Sans } from 'next/font/google';
import './globals.css';

const jakartaSans = Plus_Jakarta_Sans({
  subsets: ['latin'],
  weight: ['400', '500', '600', '700', '800'],
  variable: '--font-jakarta',
  display: 'swap',
});

export const viewport: Viewport = {
  themeColor: '#D81B60',
  width: 'device-width',
  initialScale: 1,
  maximumScale: 5,
};

export const metadata: Metadata = {
  metadataBase: new URL('https://getnikahin.my.id'),
  title: {
    default: 'Nikahin — Aplikasi Perencanaan Pernikahan & Budget Pasangan',
    template: '%s | Nikahin App',
  },
  description:
    'Rencanakan hari bahagia berdua lebih tenang dan rapi. Satu aplikasi untuk anggaran, termin vendor, rundown, buku tamu, dan seserahan yang tersinkronisasi real-time.',
  keywords: [
    'wedding planner indonesia',
    'aplikasi pernikahan',
    'kalkulator anggaran nikah',
    'rundown pernikahan',
    'buku tamu digital',
    'nikahin app',
    'checklist kua',
    'aplikasi pengantin',
  ],
  authors: [{ name: 'Nikahin Team' }],
  creator: 'Nikahin App',
  openGraph: {
    type: 'website',
    locale: 'id_ID',
    url: 'https://getnikahin.my.id',
    title: 'Nikahin — Aplikasi Perencanaan Pernikahan & Budget Pasangan',
    description:
      'Satu aplikasi untuk kelola anggaran, vendor, rundown, buku tamu, dan seserahan bersama pasangan secara real-time.',
    siteName: 'Nikahin',
    images: [
      {
        url: '/assets/nikahin-symbol-master-512.png',
        width: 512,
        height: 512,
        alt: 'Logo Nikahin',
      },
    ],
  },
  twitter: {
    card: 'summary_large_image',
    title: 'Nikahin — Aplikasi Perencanaan Pernikahan & Budget Pasangan',
    description:
      'Satu aplikasi untuk kelola anggaran, vendor, rundown, buku tamu, dan seserahan bersama pasangan secara real-time.',
    images: ['/assets/nikahin-symbol-master-512.png'],
  },
  icons: {
    icon: '/favicon.ico',
    shortcut: '/favicon.ico',
    apple: '/assets/apple-touch-icon.png',
  },
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="id" className={`${jakartaSans.variable} font-sans scroll-smooth`}>
      <body className="min-h-screen bg-[#fff9fa] text-slate-900 antialiased selection:bg-[#ffd9e2] selection:text-[#3e001d]">
        {children}
      </body>
    </html>
  );
}
