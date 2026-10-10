# Nikahin App - Design Direction (DESIGN.md)

Dokumen ini mendefinisikan identitas visual, kepribadian merek, palet warna, tipografi, dan prinsip estetika untuk antarmuka web dan mobile Nikahin App.

---

## 1. Identitas & Persona Merek
- **Produk**: Nikahin App — Aplikasi Perencanaan & Pengelolaan Anggaran Pernikahan.
- **Audiens**: Calon pengantin, keluarga, dan panitia pernikahan di Indonesia yang membutuhkan ketenangan, kejelasan anggaran, dan koordinasi yang elegan.
- **Karakter Visual**: *Warm Editorial Wedding* — Anggun, tenang, hangat, terpercaya, dan berbudaya, bukan aplikasi tech/SaaS gelap berlampu neon.

---

## 2. Palet Warna (Palette)
Palet dirancang untuk menghadirkan kehangatan kertas undangan pernikahan fisik yang mewah:

| Token | Nilai Hex | Peran / Penggunaan |
|---|---|---|
| `--bg-base` | `#FAF7F2` | Latar utama (Warm Alabaster / Ivory) |
| `--bg-surface` | `#FFFFFF` | Permukaan kartu / kontainer utama |
| `--bg-subtle` | `#F3EEE7` | Kontras lembut untuk section pelengkap |
| `--border-warm` | `#E8DFD5` | Garis tepi bertekstur tenang |
| `--text-primary` | `#1C1917` | Tipografi utama (Warm Charcoal) |
| `--text-secondary` | `#57534E` | Tipografi sekunder / deskripsi |
| `--text-muted` | `#78716C` | Metadata, caption, dan petunjuk form |
| `--primary-rose` | `#9F1239` | Aksen utama (Deep Rose / Burgundy), melambangkan cinta & kesungguhan |
| `--primary-hover` | `#881337` | Hover state untuk tombol utama |
| `--accent-gold` | `#B45309` | Aksen sekunder (Warm Amber / Muted Gold) |
| `--success` | `#15803D` | Status berhasil / checklist tervalidasi |
| `--error` | `#B91C1C` | Status peringatan / error |

---

## 3. Tipografi (Typography)
- **Display & Judul Utama (H1, H2)**:
  - Font: `'Playfair Display', serif`
  - Karakter: Anggun, klasik, proporsional, mencerminkan nuansa kartu undangan pernikahan berkelas.
- **Sub-judul & Teks Fungsional**:
  - Font: `'Plus Jakarta Sans', sans-serif`
  - Karakter: Bersih, mudah dibaca, kontras tinggi, ergonomis untuk scanning cepat.
- **Hierarki Skala**:
  - H1: `2.25rem` (36px) – `2.75rem` (44px), tracking `-0.02em`
  - H2: `1.75rem` (28px), tracking `-0.01em`
  - H3: `1.25rem` (20px), font-weight `600`
  - Body: `0.9375rem` (15px) – `1rem` (16px), line-height `1.6`
  - Small / Meta: `0.8125rem` (13px), line-height `1.5`

---

## 4. Bentuk, Elevasi, dan Tekstur (Shape & Elevation)
- **Radii**: 
  - Kontainer & Kartu: `16px` (tidak menggunakan pill raksasa untuk kartu).
  - Tombol & Input: `10px` – `12px` (proporsional dan tegas).
- **Elevasi / Bayangan**:
  - Flat base dengan border lembut (`1px solid var(--border-warm)`).
  - Bayangan hanya digunakan pada elevasi riil (misal dropdown menu atau kartu utama melayang): `0 8px 24px -4px rgba(28, 25, 23, 0.06), 0 2px 6px -1px rgba(28, 25, 23, 0.04)`.
  - Dilarang menggunakan diffuse neon glow atau bayangan kabur ungu/cyan di seluruh elemen.

---

## 5. Dials & Parameter Liveliness (Antislop Filter)
- **ENERGY**: 2 (Tenang, elegan, stabil)
- **RHYTHM**: 2 (Struktur terukur dengan whitespace organik)
- **MOTION**: 1 (Mikro-transisi halus `150ms - 200ms ease`, tidak ada animasi perpetual yang mengganggu pembaca)
