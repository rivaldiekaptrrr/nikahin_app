---
name: local-knowledge-sync
description: Use when syncing knowledge between local repository and MCP Memory, initializing workspace on a new machine, or recording new architectural decisions, schemas, and project discoveries.
---

# 🔄 Local-First Knowledge Sync (Local-First Knowledge Synchronization)

Skill ini mengatur tata cara sinkronisasi pengetahuan arsitektur, parameter teknis, dan aturan bisnis antara berkas lokal [`.agents/knowledge_graph.json`](file:///c:/Rivaldi/nikahin_app/.agents/knowledge_graph.json) dan server **MCP Memory**.

---

## 🎯 Mengapa Harus Local-First?

1. **Database MCP Bersifat Mesin-Lokal**: Database server MCP Memory tersimpan di direktori lokal komputer saat ini. Jika Anda berpindah laptop, berganti komputer, atau menjalankan kloning baru, memori MCP pada mesin baru tersebut awalnya kosong.
2. **Git Repository sebagai Single Source of Truth (SSOT)**: Berkas [`.agents/knowledge_graph.json`](file:///c:/Rivaldi/nikahin_app/.agents/knowledge_graph.json) di-commit ke Git. Dengan demikian, pengetahuan proyek selalu berpindah bersama kode dan dapat dibaca di mesin manapun.
3. **Aturan Emas**:
   * **Saat Menulis (Write Flow)**: Tulis ke berkas lokal [`.agents/knowledge_graph.json`](file:///c:/Rivaldi/nikahin_app/.agents/knowledge_graph.json) terlebih dahulu → baru sinkronkan ke MCP Memory komputer saat ini → siap di-commit ke Git.
   * **Saat Membaca / Inisialisasi di Mesin Baru (Read Flow)**: Baca berkas lokal [`.agents/knowledge_graph.json`](file:///c:/Rivaldi/nikahin_app/.agents/knowledge_graph.json) → daftarkan ke MCP Memory mesin tersebut.

---

## 📋 Kapan Skill Ini Digunakan (Trigger Conditions)

Aktifkan skill ini ketika:
1. **Memulai Sesi di Komputer Baru**: Pertama kali menjalankan tugas di lingkungan/mesin baru atau setelah melakukan `git clone` / `git pull`.
2. **Pengecekan Memori Awal**: Pengguna menanyakan apakah proyek sudah terdaftar di memori MCP.
3. **Menemukan Modul / Arsitektur Baru**: Terdapat tabel SQLite baru, alur otentikasi baru, state provider baru, atau integrasi backend baru.
4. **Instruksi Pengguna**: Pengguna meminta untuk "ingat ini", "catat ke memory", atau "simpan konfigurasi ini".

---

## 🛠️ MCP Memory Tools Reference

MCP Memory diakses melalui `call_mcp_tool` dengan parameter `ServerName: "memory"`:

| Tool Name | Kegunaan | Parameter Utama |
|---|---|---|
| `read_graph` | Membaca seluruh graph di mesin saat ini | `{}` |
| `search_nodes` | Mencari node berdasarkan kata kunci | `query` (string) |
| `create_entities` | Mendaftarkan entitas baru | `entities: [{ name, entityType, observations }]` |
| `create_relations` | Menghubungkan relasi antar-entitas (active voice) | `relations: [{ from, to, relationType }]` |
| `add_observations` | Menambahkan fakta baru pada entitas yang sudah ada | `observations: [{ entityName, contents: [] }]` |
| `delete_observations`| Menghapus observasi yang sudah usang | `deletions: [{ entityName, observations: [] }]` |

---

## 🚀 Prosedur Kerja Standar

### Alur 1: Inisialisasi / Bootstrap di Komputer Baru (Read & Hydrate)

Lakukan alur ini jika memori MCP belum memuat entitas Nikahin App:

1. **Periksa Memori MCP**:
   Panggil `read_graph` pada MCP Memory.
   ```json
   // ServerName: "memory", ToolName: "read_graph"
   {}
   ```
2. **Verifikasi Keberadaan Entitas Proyek**:
   Cari apakah entitas `Nikahin_App_Core` sudah terdaftar.
3. **Jika Belum Terdaftar**:
   * Baca berkas lokal [`.agents/knowledge_graph.json`](file:///c:/Rivaldi/nikahin_app/.agents/knowledge_graph.json).
   * Jalankan `create_entities` dengan payload `entities` dari berkas lokal.
   * Jalankan `create_relations` dengan payload `relations` dari berkas lokal.
4. **Konfirmasi**:
   Laporkan kepada pengguna bahwa memori MCP di komputer saat ini telah berhasil disinkronkan dari berkas lokal.

---

### Alur 2: Pencatatan Pengetahuan Baru (Local-First Write)

Lakukan alur ini setiap kali ada pengetahuan baru yang perlu disimpan:

1. **Langkah 1: Perbarui Berkas Lokal Terlebih Dahulu (Local-First)**
   * Buka berkas [`.agents/knowledge_graph.json`](file:///c:/Rivaldi/nikahin_app/.agents/knowledge_graph.json).
   * Tambahkan entitas baru, relasi baru, atau sisipkan observasi baru ke dalam JSON.
   * Simpan berkas tersebut.
2. **Langkah 2: Sinkronkan ke MCP Memory Komputer Aktif**
   * Jika menambahkan entitas baru: panggil `create_entities`.
   * Jika menambahkan relasi baru: panggil `create_relations`.
   * Jika hanya menambah observasi baru: panggil `add_observations`.
3. **Langkah 3: Konfirmasi & Siap Git**
   * Laporkan kepada pengguna bahwa berkas lokal sudah diperbarui dan memori komputer aktif telah tersinkronisasi.
   * Berkas lokal sekarang otomatis masuk dalam `git status` dan siap di-commit sehingga komputer lain nantinya juga menerima pembaruan ini setelah `git pull`.

---

## ⚠️ Kesalahan Umum yang Harus Dihindari

| Kesalahan | Dampak Buruk | Tindakan yang Benar |
|---|---|---|
| Hanya update MCP Memory tanpa edit file lokal | Perubahan hilang saat pindah komputer atau clone baru | **WAJIB** perbarui `.agents/knowledge_graph.json` terlebih dahulu |
| Hanya edit file lokal tanpa eksekusi MCP Memory | Sesi AI saat ini tidak mengenali pengetahuan baru tersebut | Jalankan tool MCP Memory tepat setelah menyimpan file lokal |
| Observasi terlalu umum / tidak informatif | Memori tidak bernilai guna untuk sesi berikutnya | Tulis detail teknis: nama file, class, fungsi, konstanta, atau alur state |
| Format LaTeX mentah pada teks deskripsi | Melanggar standar format respon bersih | Gunakan simbol Unicode bersih (`→`, `•`, dsb.) |

---

## 🔍 Checklist Verifikasi
- [ ] Berkas [`.agents/knowledge_graph.json`](file:///c:/Rivaldi/nikahin_app/.agents/knowledge_graph.json) berisi JSON yang valid dan terformat rapi.
- [ ] Entitas, observasi, dan relasi yang ditambahkan sudah selaras antara file lokal dan MCP Memory.
- [ ] Tidak ada entitas duplikat di MCP Memory.
