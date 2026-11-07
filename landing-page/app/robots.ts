import type { MetadataRoute } from 'next';

export default function robots(): MetadataRoute.Robots {
  return {
    rules: [
      {
        userAgent: '*',
        allow: '/',
        disallow: ['/download'],
      },
    ],
    sitemap: 'https://getnikahin.my.id/sitemap.xml',
  };
}
