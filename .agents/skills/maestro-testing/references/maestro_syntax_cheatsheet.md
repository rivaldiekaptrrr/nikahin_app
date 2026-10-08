# Maestro Flow YAML Syntax & Command Cheatsheet

Referensi lengkap seluruh perintah, selektor, assertions, gesture, dan JavaScript runtime yang didukung oleh Maestro.

---

## 1. Header Configurations

Didefinisikan di bagian paling atas file sebelum tanda pemisah `---`:

```yaml
appId: com.nikahin.app                 # (Wajib) Package name Android atau Bundle ID iOS
name: "Nama Pengujian Lengkap"          # (Opsional) Nama kustom pengujian
tags:                                  # (Opsional) Tag kategori pengujian
  - smoke-test
  - regression
env:                                   # (Opsional) Variabel environment
  USER_EMAIL: "test@nikahin.app"
  BASE_URL: "https://nikahin.app"
jsEngine: graaljs                      # (Opsional) graaljs atau rhino
onFlowStart:                           # (Opsional) Hook sebelum flow mulai
  - runScript: "./scripts/setup.js"
onFlowComplete:                        # (Opsional) Hook setelah flow selesai
  - runScript: "./scripts/teardown.js"
---
```

---

## 2. Aplikasi & State Lifecycle

```yaml
# Membuka aplikasi
- launchApp:
    appId: "com.nikahin.app"           # (Opsional) Override appId
    clearState: true                   # Menghapus cache & state lokal sebelum buka
    clearKeychain: true                # Reset iOS keychain
    stopApp: true                      # Menghentikan proses app sebelumnya
    permissions:
      notifications: allow             # allow, deny, unset
      camera: allow
      all: allow

# Menghentikan aplikasi
- stopApp: "com.nikahin.app"

# Memberikan izin aplikasi
- setPermissions:
    permissions:
      camera: allow
      location: deny
```

---

## 3. Assertions (Verifikasi Layar)

```yaml
# 1. Assert Visible Sederhana
- assertVisible: "Nikahin"

# 2. Assert Visible dengan Atribut Detail
- assertVisible:
    text: "Simpan"
    id: "btn_save"                     # Accessibility ID / Key
    index: 0                           # Elemen ke-0 jika ada duplikasi teks
    enabled: true                      # Pastikan tombol aktif/bisa diklik
    focused: false
    selected: true
    optional: false                    # Jika true, test tidak gagal bila elemen tidak ada
    label: "Verifikasi tombol simpan aktif"

# 3. Assert Not Visible
- assertNotVisible: "Loading..."

# 4. Assert JavaScript Expression
- assertTrue: "output.balance >= 0"
- assertTrue:
    condition: "document.title !== ''"
    label: "Pastikan judul tidak kosong"
```

---

## 4. Gestures & Interaksi Layar

```yaml
# 1. Tap Elemen
- tapOn: "Masuk"
- tapOn:
    id: "submit_button"
    point: "50%, 80%"                  # Koordinat relatif (X, Y)

# 2. Double Tap & Long Press
- doubleTapOn: "Foto Profil"
- longPressOn: "Item Anggaran"

# 3. Input & Hapus Teks
- inputText: "Budi Santoso"
- eraseText: 10                        # Hapus 10 karakter
- eraseText                            # Hapus seluruh teks di input aktif
- hideKeyboard                         # Tutup keyboard virtual

# 4. Tombol Navigasi / Tombol Fisik
- back                                 # Tombol Back Android
- pressKey: "Enter"                    # Enter, Backspace, VolumeUp, VolumeDown, Home, Lock

# 5. Scrolling
- scroll                               # Scroll sekali ke bawah
- scrollUntilVisible:
    element: "Batas Total Anggaran"
    direction: DOWN                    # UP, DOWN, LEFT, RIGHT
    timeout: 10000                     # Maksimal waktu scroll (ms)
    speed: 50                          # Kecepatan scroll (0-100)

# 6. Swiping
- swipe:
    direction: LEFT                    # Geser layar ke kiri
    duration: 400
- swipe:
    start: "90%, 50%"                  # Dari kanan layar
    end: "10%, 50%"                    # Ke kiri layar
    duration: 500
```

---

## 5. Control Flow (Pengulangan & Logika)

```yaml
# 1. Repeat N Kali
- repeat:
    times: 3
    commands:
      - tapOn: "Lanjut"
      - assertVisible: "Indikator Halaman"

# 2. Repeat While Element Visible
- repeat:
    while:
      visible: "Tambah Item"
    commands:
      - tapOn: "Tambah Item"

# 3. Conditional Flow (When)
- runFlow:
    when:
      visible: "Login Google"
    commands:
      - tapOn: "Login Google"

# 4. Subflow File
- runFlow:
    file: "common/login_subflow.yaml"
    env:
      EMAIL: "admin@nikahin.app"

# 5. Retry on Failure
- retry:
    maxRetries: 2
    commands:
      - tapOn: "Muat Ulang"
```

---

## 6. JavaScript Evaluation & API Testing

```yaml
# 1. Evaluasi Script Inline
- evalScript: ${output.now = Date.now()}
- evalScript: ${output.randomGuest = "Tamu " + Math.floor(Math.random() * 1000)}

# 2. Jalankan File JS Eksternal
- runScript:
    file: "scripts/generate_token.js"
    env:
      ROLE: "USER"

# 3. HTTP Request di JS
# Di dalam script JS:
# const res = http.get('https://api.nikahin.app/status');
# output.status = json(res.body).status;
```
