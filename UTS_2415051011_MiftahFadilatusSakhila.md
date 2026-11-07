# DOKUMENTASI PROJECT UJIAN TENGAH SEMESTER (UTS)
## MATAKULIAH PEMROGRAMAN MOBILE

**Aplikasi:** MuncakGear (Rental Fasilitas Mendaki & Alat Outdoor)  
**Program Studi:** S1 Pendidikan Teknik Informatika - Universitas Pendidikan Ganesha  

---

### Data Mahasiswa & Dosen
- **Nama Mahasiswa:** Miftah Fadilatus Sakhila
- **NIM:** 2415051011
- **Kelas:** PTI 5A
- **Dosen Pengampu:** Dr. Ir. I Ketut Resika Arthana, S.T., M.Kom
- **Teaching Assistant:** Made Yuda Sadewa, S.Pd.
- **Repository GitHub:** [https://github.com/emip0525/flutter_uts_miftah](https://github.com/emip0525/flutter_uts_miftah)
- **Nama Branch:** `main`

---

### 1. Deskripsi & Ruang Lingkup Project
Aplikasi **MuncakGear** dibuat untuk memberikan solusi digital bagi persewaan perlengkapan alam bebas dan kegiatan mendaki gunung. Pengguna dapat:
- Melihat informasi perkiraan cuaca puncak gunung secara langsung via REST API Open-Meteo.
- Menjelajahi katalog alat outdoor dengan filter kategori dan pencarian instan.
- Membaca detail spesifikasi teknis (material, kapasitas, berat, rating tahan air).
- Menyimpan peralatan ke daftar wishlist (favorit).
- Melakukan pemesanan sewa peralatan gunung dengan form terverifikasi.
- Mengelola data penyewaan (CRUD: Create, Read, Update, Delete) yang tersimpan ke database backend Supabase / PostgreSQL.

---

### 2. Implementasi Arsitektur Perangkat Lunak
Aplikasi dibangun menggunakan **Layered Architecture** dengan alur data satu arah:
1. **Presentation Layer (Screens & Widgets):** Berisi 8 screen fungsional dan 8 widget reusable yang responsif terhadap ukuran layar compact (< 600px) dan wide (≥ 600px).
2. **State Management Layer (Providers):** Menggunakan `Provider` dan `ChangeNotifier` untuk mengelola state data, loading, error, serta shared state (Wishlist dan Filter).
3. **Repository Layer:** Mengabstraksi sumber data sehingga antarmuka tidak berinteraksi langsung dengan API atau database.
4. **Data Source / Service Layer:**
   - `ApiService`: Mengakses Open-Meteo REST API (`GET`) dan parsing JSON ke model Dart.
   - `DatabaseService`: Mengakses Supabase PostgreSQL client untuk operasi `insert`, `select`, `update`, dan `delete` tabel `rental_bookings`.

---

### 3. Daftar Screen Fungsional (Total 10 Screen)
1. **HomeScreen (Beranda):** Banner promosi, widget cuaca REST API real-time, kategori cepat, rekomendasi alat outdoor terpopuler, tombol tambah alat.
2. **CatalogScreen (Katalog):** Grid alat responsif (2 kolom di HP, 3-4 kolom di layar lebar), search bar instan, filter kategori, sorting harga & rating, tombol Tambah Alat Baru.
3. **GearDetailScreen (Detail Produk):** Foto hero, badge kategori, rating, kartu tarif & deposit, tabel spesifikasi teknis, daftar fitur, tombol favorit, tombol Edit Alat, tombol sewa sekarang.
4. **AddGearScreen (Form Tambah Alat Outdoor):** Form input alat baru ke katalog (nama, merk, kategori, tarif sewa/hari, uang jaminan, jumlah stok, deskripsi, spesifikasi).
5. **EditGearScreen (Form Ubah Data Alat Outdoor):** Form untuk mengubah informasi alat, tarif sewa, deposit, status ketersediaan stok, dan deskripsi produk.
6. **CreateRentalScreen (Form Tambah Sewa):** Form validasi nama penyewa, nomor WhatsApp, pemilihan alat, date picker tanggal mulai, counter durasi sewa, kalkulasi total otomatis, dan tombol simpan ke database.
7. **EditRentalScreen (Form Ubah Data Sewa):** Form untuk mengubah nama penyewa, nomor HP, durasi sewa (disertai penyesuaian total biaya), catatan, serta perubahan status sewa (Aktif, Selesai, Dibatalkan).
8. **RentalListScreen (Kelola Transaksi Sewa):** Menampilkan ringkasan statistik (Total Sewa, Aktif, Selesai, Pendapatan), filter status, daftar kartu sewa, tombol edit, dan tombol hapus dengan konfirmasi dialog.
9. **FavoritesScreen (Wishlist):** Menampilkan peralatan yang difavoritkan pengguna, tombol hapus dari favorit, dan tombol aksi sewa langsung.
10. **ProfileScreen (Profil Pengembang):** Menampilkan identitas mahasiswa (Nama, NIM, Kelas), informasi akademik, detail arsitektur aplikasi, dialog skema database, dan tombol sinkronisasi API.

---

### 4. Spesifikasi Integrasi REST API & Database
- **REST API:** Open-Meteo REST API (HTTP GET)
  - URL: `https://api.open-meteo.com/v1/forecast?latitude=-8.411&longitude=115.312&current_weather=true`
  - Model: `MountainWeather`
  - Fitur: Menampilkan suhu, kecepatan angin, kondisi cuaca, dan rekomendasi keselamatan pendakian.
- **Backend Database:** Supabase PostgreSQL
  - Tabel: `rental_bookings`
  - Primary Key: `id` (UUID / String)
  - Fields: `student_id`, `customer_name`, `customer_phone`, `gear_id`, `gear_name`, `rental_days`, `start_date`, `return_date`, `total_price`, `note`, `status`, `created_at` (13 field).
  - Operasi CRUD: Lengkap (Create, Read, Update, Delete dengan AlertDialog konfirmasi).

---

### 5. Hasil Pengujian (Automated Testing)
Seluruh pengujian unit (*Unit Tests*) dan widget (*Widget Tests*) telah dijalankan dan lulus 100%:
- `OutdoorGear JSON parsing and copyWith test`: **PASS**
- `RentalBooking JSON serialization test (Database CRUD model)`: **PASS**
- `MountainWeather Open-Meteo REST API JSON parsing test`: **PASS**
- `Formatters test (Indonesian Rupiah and Date)`: **PASS**
- `App smoke test - verifies branding and navigation destinations`: **PASS**
- `dart analyze`: **0 Issues found (Clean Code)**

---

*Disusun oleh Miftah Fadilatus Sakhila (2415051011) - UTS Pemrograman Mobile PTI 5A.*
