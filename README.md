# ⚡ Speed Drill Kata Panjang (>15 Huruf)

Aplikasi latihan kecepatan mengetik (typing speed drill) khusus untuk kata-kata monster dan kata panjang ($\ge$ 15 huruf) dari KBBI dan istilah dunia.

Aplikasi ini dibangun murni menggunakan **HTML5, CSS3, dan Vanilla JavaScript (Client-Side)** tanpa memerlukan server backend (No Go / No Node needed).

---

## ✨ Fitur Unggulan

- **🎯 Target Kata Monster**: Latihan kata dengan panjang 16 hingga 85 huruf (misal *Taumatawhakatangihangakoauauotamateaturipukakapikimaungahoronukupokaiwhenuakitanatahu*, *Pneumonoultramicroscopicsilicovolcanoconiosis*, dll).
- **📚 3.684+ Katalog Kata KBBI**: Dilengkapi dataset `words.json` lengkap dengan pencarian real-time, filter kategori panjang (16-19, 20-29, 30-50, 50+ huruf), dan pengurutan instan.
- **⏱️ Stopwatch Presisi**: Perhitungan waktu milidetik saat karakter pertama diketik.
- **📊 Metrik Real-time**: Kecepatan Karakter per Detik (CPS), Perkiraan Words Per Minute (WPM), Akurasi (%), dan Penghitung Typo.
- **🔊 Mechanical Keyboard Synthesizer**: Suara ketik mekanik ("thock") dan suara error otomatis via Web Audio API tanpa membutuhkan file audio eksternal.
- **👑 Rekor Pribadi (Personal Best)**: Tersimpan otomatis di `localStorage` per masing-masing kata.
- **✍️ Mode Kustom**: Dukungan memasukkan kata sendiri untuk dilatih.
- **📱 Responsif & Ramah Sentuh**: Input overlay transparan yang mendukung virtual keyboard di perangkat mobile (Android & iOS).

---

## 📁 Struktur File

```text
typing-long/
├── index.html        # Seluruh aplikasi (UI, style CSS, dan logika JS)
├── words.json        # Dataset 3.684 kata panjang KBBI (94 KB)
├── .gitignore        # Konfigurasi file yang diabaikan git
└── README.md         # Dokumentasi proyek
```

---

## 🚀 Cara Menjalankan Secara Lokal

Karena aplikasi ini membaca file `words.json` via `fetch()`, jalankan melalui server lokal sederhana (agar tidak terblokir oleh aturan CORS `file:///` di beberapa browser):

### Opsi 1: VS Code Live Server
Cukup klik kanan pada `index.html` lalu pilih **"Open with Live Server"**.

### Opsi 2: Menggunakan PHP (Laragon)
Jika menggunakan Laragon, letakkan folder ini di `C:\laragon\www\typing-long` lalu buka di browser:
```text
http://localhost/typing-long/
```
Atau jalankan PHP built-in server dari dalam folder:
```bash
php -S localhost:8080
```
Lalu buka: `http://localhost:8080`

### Opsi 3: Menggunakan Python
```bash
python -m http.server 8080
```
Lalu buka: `http://localhost:8080`

---

## 🌐 Deploy Gratis (GitHub Pages / Vercel / Netlify)

Aplikasi ini dapat di-hosting 100% gratis selamanya:

### 1. GitHub Pages
1. Buat repository baru di GitHub (misal `typing-long`).
2. Masukkan seluruh file di folder ini ke repo:
   ```bash
   git init
   git add .
   git commit -m "Initial commit typing-long standalone"
   git branch -M main
   git remote add origin https://github.com/USERNAME/REPO_NAME.git
   git push -u origin main
   ```
3. Buka **Settings** repository GitHub $\rightarrow$ **Pages** $\rightarrow$ Pilih branch `main` / root $\rightarrow$ **Save**.
4. Website Anda langsung online di `https://USERNAME.github.io/REPO_NAME/`!

### 2. Vercel / Netlify
Tinggal hubungkan repository GitHub ke dashboard Vercel / Netlify, lalu klik **Deploy** tanpa perlu konfigurasi build command apapun.

---

## 📄 Lisensi
MIT License. Bebas dikembangkan dan dimodifikasi.
