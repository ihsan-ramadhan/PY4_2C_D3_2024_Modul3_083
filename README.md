# Proyek Modul 3: Data Modeling & Dynamic Lists

**Nama:** Muhammad Ihsan Ramadhan
**NIM:** 241511083
**Kelas:** 2C - D3 Teknik Informatika

---

## Deskripsi Proyek

Aplikasi ini merupakan tahap perubahan besar dari sekadar *Counter App* menjadi sebuah *LogBook*. Fokus utama pada modul ini adalah pembuatan *Data Model*, penerapan *Reactive Programming* untuk efisiensi *rendering* UI, interaksi **CRUD** pada sebuah *List*, serta teknik *JSON Serialization* agar sekumpulan objek dapat disimpan secara permanen di dalam `SharedPreferences`.

## Fitur Utama

1. **The Daily Logger (LOTS):** Fitur CRUD lengkap yang memungkinkan pengguna untuk menambah, membaca, mengedit, dan menghapus catatan logbook.


2. **Dynamic UI Rendering:** Menggunakan `ListView.builder` yang hemat memori untuk menampilkan daftar catatan dalam bentuk `Card` dan `ListTile` secara dinamis.


3. **Reactive List Management (MOTS):** Pengelolaan *state* menggunakan `ValueNotifier` dan `ValueListenableBuilder`. UI akan langsung ke-*update* secara otomatis saat data berubah tanpa perlu memanggil `setState()` secara manual pada fungsi CRUD.


4. **Persistent JSON Storage (HOTS):** Data catatan dibungkus dalam `LogModel`, lalu di-*encode* menjadi format JSON agar bisa disimpan utuh ke memori lokal. Data tidak akan hilang meskipun aplikasi ditutup atau di-*restart*.

---

## Self-Reflection

Setelah mengerjakan Modul 3, saya menyadari pentingnya merancang fondasi arsitektur data sebelum membangun antarmuka aplikasi:

1. Sebelumnya saya hanya menyimpan tipe data tunggal seperti `String` atau `int`. Dengan membuat *class* `LogModel`, data menjadi terstandarisasi (ada judul, deskripsi, dan tanggal). Kodingan jadi jauh lebih rapi, terstruktur, dan meminimalisir *error* saat data dipanggil ke UI.


2. Saya belajar bahwa merender ulang seluruh halaman dengan `setState()` itu kurang efisien. Dengan `ValueNotifier`, aplikasi terasa lebih pintar. Layaknya analogi kurir paket, UI hanya akan bereaksi (merender ulang) tepat di bagian list yang datanya berubah. Ini membuat aplikasi berjalan lebih mulus.


3. Awalnya saya bingung bagaimana cara menyimpan `List` berisi objek ke `SharedPreferences` yang hanya menerima data primitif. Ternyata solusinya adalah menerjemahkan objek tersebut menjadi teks JSON (`jsonEncode`). Saat aplikasi dibuka kembali, teks tersebut dibongkar lagi menjadi objek (`jsonDecode`). Ini adalah teknik yang sangat berguna untuk persistensi data kompleks.



---

## Tech Stack & Tools

* **Language:** Dart
* **Framework:** Flutter

**Core Libraries:** `dart:convert` (JSON Encode/Decode), `shared_preferences` (Local Storage), `ValueNotifier` (Reactive State)
