# Maestro MCP Tools Reference & Integration Protocol

Dokumentasi detail spesifikasi pemanggilan tool **Maestro MCP (Model Context Protocol)** yang digunakan oleh AI Assistant untuk berinteraksi dengan perangkat secara terprogram.

---

## 🛠️ Daftar Tools MCP Maestro

### 1. `list_devices`
Mengembalikan daftar semua perangkat yang terhubung (HP fisik via ADB, emulator lokal, dan browser).
- **Argumen**: `{}` (tanpa argumen)
- **Contoh Respon**:
  ```json
  {
    "devices": [
      {
        "device_id": "fd338270",
        "name": "23049PCD8G",
        "platform": "android",
        "type": "physical",
        "connected": true
      },
      {
        "device_id": "chromium",
        "name": "Chromium Web Browser",
        "platform": "web",
        "type": "browser",
        "connected": false
      }
    ]
  }
  ```

---

### 2. `inspect_screen`
Mengambil pohon hirarki UI (*view hierarchy / accessibility tree*) layar aktif perangkat.
- **Argumen**:
  - `device_id` *(opsional)*: ID perangkat spesifik (misal `"fd338270"`).
- **Kegunaan**:
  - Membaca teks, ID, status enable/disable, dan bounding box tombol di layar sebelum melakukan tap atau input teks.

---

### 3. `take_screenshot`
Mengambil gambar visual layar perangkat secara real-time.
- **Argumen**:
  - `device_id` *(opsional)*: ID perangkat target.
- **Hasil**: File gambar tersimpan di artifact directory yang dapat dilihat langsung oleh AI/pengguna.

---

### 4. `run`
Mengeksekusi skrip Flow YAML Maestro atau perintah inline.
- **Argumen**:
  - `path` *(opsional)*: Path ke file `.yaml` (misal `".maestro/01_onboarding_demo_flow.yaml"`).
  - `flow` *(opsional)*: String isi skrip YAML inline jika tidak ingin membuat file terlebih dahulu.
  - `device_id` *(opsional)*: ID perangkat target.
- **Contoh Pemanggilan**:
  ```json
  {
    "path": ".maestro/01_onboarding_demo_flow.yaml",
    "device_id": "fd338270"
  }
  ```

---

### 5. `open_maestro_viewer`
Memulai dan membuka server Maestro Viewer di `http://127.0.0.1:9999/`.
- **Kegunaan**: Memberikan tampilan web interaktif untuk debugging flow Maestro secara langsung.

---

### 6. Cloud Testing Suite Tools
* **`list_cloud_devices`**: Menampilkan daftar model perangkat di server cloud Maestro.
* **`run_on_cloud`**: Mengirim file APK dan folder flow ke Maestro Cloud.
* **`get_cloud_run_status`**: Memeriksa progres status eksekusi cloud (RUNNING, PASSED, FAILED).
* **`describe_cloud_run`**: Menampilkan detail log dan rekaman video hasil cloud run.
