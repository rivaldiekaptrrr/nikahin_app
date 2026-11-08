import type { Metadata, Viewport } from 'next';
import { Plus_Jakarta_Sans } from 'next/font/google';
import MetaPixel from '@/components/MetaPixel';
import FirebaseAnalytics from '@/components/FirebaseAnalytics';
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
  alternates: {
    canonical: 'https://getnikahin.my.id',
  },
  robots: {
    index: true,
    follow: true,
    googleBot: {
      index: true,
      follow: true,
      'max-video-preview': -1,
      'max-image-preview': 'large',
      'max-snippet': -1,
    },
  },
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
        url: '/assets/og-image.png',
        width: 1200,
        height: 630,
        alt: 'Nikahin — Aplikasi Perencanaan Pernikahan & Budget Pasangan',
        type: 'image/png',
      },
    ],
  },
  twitter: {
    card: 'summary_large_image',
    title: 'Nikahin — Aplikasi Perencanaan Pernikahan & Budget Pasangan',
    description:
      'Satu aplikasi untuk kelola anggaran, vendor, rundown, buku tamu, dan seserahan bersama pasangan secara real-time.',
    images: ['/assets/og-image.png'],
  },
  icons: {
    icon: [
      { url: '/favicon.ico' },
      { url: '/favicon-16x16.png', sizes: '16x16', type: 'image/png' },
      { url: '/favicon-32x32.png', sizes: '32x32', type: 'image/png' },
    ],
    shortcut: '/favicon.ico',
    apple: '/assets/apple-touch-icon.png',
  },
};

const jsonLdData = {
  '@context': 'https://schema.org',
  '@graph': [
    {
      '@type': 'SoftwareApplication',
      'name': 'Nikahin',
      'operatingSystem': 'Android, iOS, Web',
      'applicationCategory': 'LifestyleApplication',
      'offers': {
        '@type': 'Offer',
        'price': '49000',
        'priceCurrency': 'IDR',
        'availability': 'https://schema.org/InStock',
      },
      'aggregateRating': {
        '@type': 'AggregateRating',
        'ratingValue': '4.9',
        'reviewCount': '128',
      },
      'description':
        'Aplikasi perencanaan pernikahan lengkap untuk pasangan: anggaran, rundown, vendor, dan buku tamu sinkron real-time.',
    },
    {
      '@type': 'FAQPage',
      'mainEntity': [
        {
          '@type': 'Question',
          'name': 'Apakah pasangan harus membayar lagi secara terpisah?',
          'acceptedAnswer': {
            '@type': 'Answer',
            'text':
              'Tidak perlu. Cukup satu kali pembayaran untuk satu acara pernikahan. Setelah aktif, kamu tinggal membagikan 6 karakter kode pasangan kepada calon suami/istrimu. Akun pasangan akan langsung terhubung tanpa biaya tambahan apa pun.',
          },
        },
        {
          '@type': 'Question',
          'name': 'Bagaimana jika tanggal pernikahan kami masih tahun depan atau belum ditentukan?',
          'acceptedAnswer': {
            '@type': 'Answer',
            'text':
              'Akses akun berlaku selamanya tanpa batas waktu dan tanpa biaya langganan bulanan. Kamu bisa mencicil persiapan pernikahan kapan saja dengan tenang.',
          },
        },
        {
          '@type': 'Question',
          'name': 'Bagaimana cara memasang aplikasi Nikahin di iPhone?',
          'acceptedAnswer': {
            '@type': 'Answer',
            'text':
              'Sangat praktis tanpa perlu App Store. Cukup buka tautan aplikasi di peramban Safari, ketuk tombol Bagikan, lalu pilih Tambah ke Layar Utama (Add to Home Screen).',
          },
        },
        {
          '@type': 'Question',
          'name': 'Apakah data saya tetap aman jika berganti perangkat ponsel?',
          'acceptedAnswer': {
            '@type': 'Answer',
            'text':
              'Sangat aman. Seluruh data anggaran, vendor, rundown, dan daftar tamu tersimpan otomatis di akunmu. Masuk kembali menggunakan email yang sama di ponsel baru, dan semua data langsung sinkron.',
          },
        },
        {
          '@type': 'Question',
          'name': 'Apakah aplikasi bisa digunakan saat tidak ada sinyal internet?',
          'acceptedAnswer': {
            '@type': 'Answer',
            'text':
              'Ya, Nikahin dilengkapi dengan penyimpanan lokal offline pintar. Data yang sudah dibuka sebelumnya tetap dapat kamu lihat saat berada di lokasi pernikahan tanpa sinyal internet.',
          },
        },
        {
          '@type': 'Question',
          'name': 'Bagaimana cara pembayaran untuk membuka akses penuh?',
          'acceptedAnswer': {
            '@type': 'Answer',
            'text':
              'Nikahin mendukung pembayaran otomatis 24 jam melalui QRIS (semua e-wallet dan mobile banking), Virtual Account BCA, Mandiri, BRI, BNI, BSI, CIMB, Permata, serta GoPay dan ShopeePay.',
          },
        },
      ],
    },
  ],
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="id" className={`${jakartaSans.variable} font-sans scroll-smooth`}>
      <head>
        <script
          type="application/ld+json"
          dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLdData) }}
        />
      </head>
      <body className="min-h-screen bg-[#fff9fa] text-slate-900 antialiased selection:bg-[#ffd9e2] selection:text-[#3e001d]">
        <MetaPixel />
        <FirebaseAnalytics />
        {children}
      </body>
    </html>
  );
}
