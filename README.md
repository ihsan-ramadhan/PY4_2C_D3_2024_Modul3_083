# Proyek Modul 2: Authentication & Navigation

**Nama:** Muhammad Ihsan Ramadhan
**NIM:** 241511083
**Kelas:** 2C - D3 Teknik Informatika

---

## Deskripsi Proyek

Aplikasi ini adalah versi upgrade dari *LogBook App* sebelumnya. Fokus utama pada modul ini adalah implementasi **Authentication**, manajemen navigasi antar halaman (*Routing*), dan **Data Persistence** menggunakan `SharedPreferences`. Aplikasi kini memiliki alur kerja yang lengkap mulai dari *Onboarding*, *Login*, hingga pencatatan data yang tersimpan permanen di memori perangkat.

## Fitur Utama

1. **Login Gatekeeper (LOTS):** Sistem autentikasi dengan validasi input, fitur *Show/Hide Password*, dukungan *Multiple Users*, dan sistem keamanan (tombol terkunci 10 detik jika salah password 3x).
2. **Persistent History (HOTS):** Data angka dan riwayat aktivitas disimpan secara lokal. Data tidak akan hilang/reset ke 0 walau aplikasi ditutup.
3. **Visual Onboarding:** Halaman pengenalan aplikasi menggunakan *Carousel Slider* bergambar dengan indikator halaman.
4. **Welcome Banner:** Menampilkan sapaan personal ("Selamat Pagi/Siang/Sore/Malem") di halaman utama berdasarkan waktu login pengguna.

---

## Self-Reflection
Setelah mengerjakan Modul 2, saya menyadari bahwa *Logic* saja tidak cukup, *Experience* juga penting:

1. **Persistensi Data:**
Tanpa `SharedPreferences`, aplikasi terasa seperti kosong karena datanya selalu hilang saat di tutup. Dengan adanya `SharedPreferences`, aplikasi terasa hidup. Pengguna bisa menutup aplikasi dengan tenang tanpa takut kehilangan progres mereka.
2. **Keamanan Navigasi:**
Saya belajar perbedaan fatal antara `push` biasa dan `pushAndRemoveUntil`. Fitur ini sangat penting untuk *Logout*. Tanpanya, pengguna bisa menekan tombol "Back" di HP dan kembali masuk ke halaman tanpa login. Fungsi ini memastikan keamanan aplikasi terjaga dengan memutus akses ke halaman sebelumnya.
3. **Personalisasi:**
Kemampuan mengirim data antar halaman (dari Login ke Counter) memungkinkan aplikasi menyapa pengguna dengan nama mereka. Sentuhan kecil seperti ini, ditambah dengan *Welcome Banner* berdasarkan waktu, membuat aplikasi terasa lebih ramah dan interaktif.

---

## Tech Stack & Tools

* **Language:** Dart
* **Framework:** Flutter
