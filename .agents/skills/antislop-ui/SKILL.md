---
name: antislop-ui
description: "UI and visual skill for antislop. Use when building or editing any interface: color, layout, components, motion."
---

# antislop-ui: Visual & UI Quality Rules

Panduan spesifik untuk elemen UI visual: warna, layout, tipografi, komponen, dan interaksi.

## 1. Warna & Visual
- **Gradien Generik**: Jangan gunakan gradien biru-ke-ungu atau radial neon glow di background tanpa keterkaitan brand. Ambil palet dari `DESIGN.md`.
- **Glassmorphism Berlebih**: Maksimal 1-2 elemen dengan backdrop blur jika benar-benar ada hubungan foreground/background riil. Permukaan lainnya gunakan warna solid.
- **Radius Berlebih**: Jangan jadikan semua elemen berbentuk pill (pil lonjong). Gunakan skala radius yang proporsional.
- **Bayangan Halus Ekstrem**: Bayangan hanya sebagai penanda elevasi riil, bukan agar seluruh halaman terasa mengambang tak bertanah.
- **Glow Dimana-mana**: Dilarang meletakkan glow pada tombol, badge, kartu, dan teks secara serempak.

## 2. Layout & Komposisi
- **Bukan Template Monoton**: Jangan susun section hanya karena "template AI biasanya begini". Struktur halaman harus mengikuti cerita dan kebutuhan nyata pengguna.
- **Kartu Identik Berulang**: Variasikan hierarki sesuai bobot fitur riil. Tidak semua teks harus dipaksa masuk ke dalam kotak kartu.
- **Tipografi Berhierarki**: Gunakan kontras ukuran, bobot font, dan spasi yang terukur. Jangan gunakan huruf kapital ber-tracking renggang (tracked uppercase) di setiap judul.
