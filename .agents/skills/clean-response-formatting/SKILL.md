---
name: clean-response-formatting
description: Panduan penulisan respon pesan dan dokumentasi yang bersih, profesional, dan bebas dari sintaks raw LaTeX mentah (seperti $\rightarrow$, \$, math blocks).
---

# ✍️ Standar Format Respon & Dokumentasi Bersih (Clean Response Formatting)

Skill ini menetapkan standar wajib dalam penulisan pesan respon percakapan, ringkasan, dan dokumentasi pada proyek **Nikahin App** agar tidak menghasilkan format mentah (*raw LaTeX/unrendered syntax*).

---

## 🚫 1. Hal yang DILARANG Keras
1. **DILARANG menggunakan sintaks LaTeX math mode** (`$...$`, `$$...$$`, `\rightarrow`, `\leftarrow`, `\times`, `\ge`, `\le`) untuk teks alur, diagram alir, opsi, atau percakapan biasa.
   - ❌ *Contoh Buruk*: `Opsi C: Terapkan alur (Paywall $\rightarrow$ Modal $\rightarrow$ Instruksi)`
   - ❌ *Contoh Buruk*: `Waktu kompilasi $\le$ 10 detik`
2. **DILARANG meninggalkan teks atau placeholder mentah** yang tidak ter-render dengan baik di Markdown standar.

---

## ✅ 2. Standar Penulisan yang WAJIB Digunakan
Gunakan karakter **Unicode murni** atau format **Markdown native**:

| Kebutuhan | ❌ Hindari (LaTeX Mentah) | ✅ Gunakan (Unicode / Markdown Bersih) |
| :--- | :--- | :--- |
| **Panah Alur / Flow** | `$\rightarrow$` atau `\rightarrow` | `→` atau `->` |
| **Panah Bolak-balik** | `$\leftrightarrow$` | `↔` atau `<->` |
| **Simbol Centang** | `\checkmark` | `✓` atau `✅` |
| **Simbol Silang** | `\times` | `×` atau `❌` |
| **Perbandingan** | `$\ge$`, `$\le$` | `>=`, `<=`, `≥`, `≤` |
| **Pemisah / Dash** | `---` di tengah kalimat | `—` (em-dash) atau `-` |
| **Peluru Poin** | `$\bullet$` | `•` atau `-` |

---

## 📝 3. Contoh Penerapan

### A. Alur / Flow Proses
- **Salah**: `Login $\rightarrow$ Bayar $\rightarrow$ Setup Profil $\rightarrow$ Dashboard`
- **Benar**: `Login → Bayar → Setup Profil → Dashboard`

### B. Daftar Pilihan / Opsi
- **Salah**: `1. Opsi A: Migrasi ke Core API $\rightarrow$ Sukses`
- **Benar**: `1. **Opsi A**: Migrasi ke Core API → Sukses`

---

## 🎯 4. Checklist Kualitas Respon
- [ ] Tidak ada tanda dollar ganda atau tunggal (`$...$`) yang membungkus teks non-matematika.
- [ ] Semua panah menggunakan simbol Unicode `→` yang bersih.
- [ ] Tautan file menggunakan format clickable GitHub Markdown `[nama_file](file:///path/to/file)`.
- [ ] Bahasa yang digunakan ramah, profesional, ringkas, dan jelas dalam Bahasa Indonesia.
