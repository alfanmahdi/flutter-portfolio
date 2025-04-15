# flutter_isar

The Iser Database adalah basis data NoSQL cepat yang dapat berjalan di berbagai platform, termasuk perangkat seluler, desktop, dan web. Tutorial ini mencakup operasi CRUD (Create, Read, Update, Delete) penting, yang menunjukkan cara menambahkan, mengubah, melihat, dan menghapus tugas dalam aplikasi.

Untuk menggunakan Isar database secara efektif dalam aplikasi Flutter, terdapat beberapa langkah demi langkah yang harus dilakukan.

## Step 1: Setting Up The Project
- Buat Proyek Flutter.
- Tambahkan Dependencies: Buka file pubspec.yaml dan tambahkan packages yang diperlukan.
- Jalankan Dependency Update: Jalankan flutter pub get untuk menginstal package baru.

## Step 2: Setting Up Isar Database
- Tentukan Model: Buat folder model di direktori lib Anda dan tentukan file todo.dart yang berisi kelas model Todo.
  - Beri anotasi pada kelas dengan @Collection() dari Isar untuk mendefinisikannya sebagai koleksi.
- Jalankan Build Runner: Gunakan flutter pub run build_runner build di terminal untuk menghasilkan file yang diperlukan untuk model.

## Step 3: Implementasi Database Service

Buat sebuah service class bernama database_service.dart di folder services.
- Buka database Isar menggunakan path_provider untuk memastikan data disimpan secara persisten.
- Buat method untuk menginisialisasi dan mengakses basis data.

## Step 4: Membangun UI

## Step 5: Implementasi Operasi CRUD
- Add To-Do: Terapkan fungsi untuk menambahkan To-Do baru menggunakan dialog.
- Read To-Dos: Muat To-Dos dari database saat halaman diinisialisasi.
- Update To-Do: Izinkan pembaruan pada To-Dos yang ada, memuat ulang daftar setelah modifikasi.
- Delete To-Do: Tambahkan fungsi untuk menghapus To-Dos dari database.

Setelah semua selesai, aplikasi dapat diuji untuk memastikan fungsionalitas telah bekerja dengan baik.