# MuncakGear - Rental Fasilitas Mendaki & Alat Outdoor

> **Project Ujian Tengah Semester (UTS) - Pemrograman Mobile**  
> Program Studi S1 Pendidikan Teknik Informatika - Universitas Pendidikan Ganesha (Undiksha)

---

## 👤 Identitas Mahasiswa & Project

| Informasi | Detail |
| :--- | :--- |
| **Nama Lengkap** | Miftah Fadilatus Sakhila |
| **NIM** | 2415051011 |
| **Kelas** | PTI 5A |
| **Mata Kuliah** | Pemrograman Mobile |
| **Dosen Pengampu** | Dr. Ir. I Ketut Resika Arthana, S.T., M.Kom |
| **Teaching Assistant** | Made Yuda Sadewa, S.Pd. |
| **Tema Project** | Penyewaan Fasilitas Mendaki & Alat Outdoor |
| **Nama Aplikasi** | **MuncakGear** |
| **Repository GitHub** | [https://github.com/emip0525/flutter_uts_miftah](https://github.com/emip0525/flutter_uts_miftah) |
| **Branch Utama** | `main` |

---

## 📱 Deskripsi Aplikasi

**MuncakGear** adalah aplikasi mobile berbasis Flutter yang dirancang untuk mempermudah para pendaki dan pecinta kegiatan alam terbuka dalam menyewa perlengkapan berkemah dan pendakian standar ekspedisi (tenda badai, ransel carrier, sleeping bag goose down, kompor ultralight, perlengkapan masak, sepatu bot trekking gore-tex, hingga headlamp waterproof).

Aplikasi mengintegrasikan arsitektur bersih (*layered architecture*), state management berbasis **Provider & ChangeNotifier**, integrasi **REST API (GET)** untuk memantau cuaca puncak gunung secara *real-time* dan katalog perlengkapan, serta integrasi **Database PostgreSQL / Supabase** dengan operasi penuh **CRUD (Create, Read, Update, Delete)** yang dilengkapi *confirmation dialog* dan penyimpanan persisten.

---

## ✨ Fitur-Fitur Utama Aplikasi

1. **Dashboard & Beranda Interaktif**:
   - Ringkasan banner promosi pendakian.
   - Widget cuaca puncak gunung *real-time* via REST API Open-Meteo.
   - Filter cepat kategori perlengkapan.
   - Rekomendasi perlengkapan populer berbasis grid responsif.
2. **Katalog Perlengkapan Outdoor (Responsive Grid)**:
   - Pencarian instan (*live search*) berdasarkan nama alat, merk, atau deskripsi.
   - Filter multi-kategori (Tenda, Carrier, Sleeping Bag, Alat Masak, Penerangan, Sepatu, Aksesoris).
   - Pengurutan data (Terpopuler, Rating Tertinggi, Harga Termurah, Harga Tertinggi).
   - Indikator ketersediaan stok produk.
3. **Detail Perlengkapan & Spesifikasi Lengkap**:
   - *Collapsible image appbar* dengan efek gradasi.
   - Rating dan jumlah ulasan pendaki.
   - Tabel spesifikasi teknis mendalam (kapasitas, berat, material, daya tahan air).
   - Daftar fitur & keunggulan alat.
   - Tombol toggle favorit / wishlist dengan *feedback* SnackBar.
   - Navigasi langsung sewa alat (*passing data* produk terpilih).
4. **Form Reservasi Sewa Baru (Create Data + Validasi)**:
   - Form input nama penyewa dan nomor WhatsApp/HP aktif.
   - *Date Picker* interaktif untuk menentukan tanggal mulai sewa.
   - Pengaturan durasi sewa (hari) dengan *stepper* counter.
   - Perhitungan otomatis tanggal pengembalian dan kalkulasi total biaya sewa + uang jaminan (*security deposit*).
   - Validasi formulir (*Form validation*) dengan pesan error yang jelas.
5. **Manajemen & Kelola Transaksi Sewa (Database CRUD)**:
   - **Read**: Menampilkan seluruh riwayat transaksi sewa dari database.
   - **Statistik Transaksi**: Total penyewaan, sewa berstatus Aktif, Selesai, dan total estimasi pendapatan.
   - **Filter Status**: Filter cepat transaksi berdasarkan status (Semua, Aktif, Selesai, Dibatalkan).
   - **Update**: Edit data sewa, nomor telepon, durasi sewa, catatan, dan perubahan status transaksi.
   - **Delete**: Penghapusan data transaksi sewa dengan **AlertDialog Konfirmasi Hapus** untuk mencegah penghapusan tidak disengaja.
6. **Wishlist & Peralatan Favorit (Shared State)**:
   - Menyimpan perlengkapan yang disukai pengguna.
   - Terhubung secara *shared state* lintas screen (Katalog, Detail, Beranda, Wishlist).
   - Disimpan secara lokal dan persisten.
7. **Profil Mahasiswa & Informasi Akademik**:
   - Kartu identitas mahasiswa pengembang (Nama, NIM, Kelas, Kampus).
   - Detail mata kuliah dan dosen pengampu.
   - Dialog informasi skema database PostgreSQL Supabase.
   - Tombol sinkronisasi ulang REST API dan database backend.

---

## 🏗️ Arsitektur Aplikasi (Layered Clean Architecture)

Aplikasi mengikuti prinsip pemisahan tanggung jawab (*separation of concerns*) yang ketat:

```
UI (Screens & Widgets) 
       ↓ 
State Management (Providers) 
       ↓ 
Repositories (Data Layer Abstraction) 
       ↓ 
Services & Data Sources (REST API & Supabase DB)
```

### Struktur Direktori Project:
```
lib/
├── config/
│   └── app_constants.dart          # Konstanta aplikasi, warna tema, konfigurasi API & Supabase
├── models/
│   ├── outdoor_gear.dart           # Model Dart untuk katalog alat outdoor
│   ├── rental_booking.dart         # Model Dart untuk transaksi rental (CRUD DB)
│   └── mountain_weather.dart       # Model Dart untuk respons REST API cuaca gunung
├── services/
│   ├── api_service.dart            # Service HTTP GET REST API (Open-Meteo & JSON Catalog)
│   └── database_service.dart       # Service Supabase PostgreSQL + Local Storage Fallback
├── repositories/
│   ├── gear_repository.dart        # Repositori katalog perlengkapan
│   └── rental_repository.dart      # Repositori operasi CRUD database rental
├── providers/
│   ├── gear_provider.dart          # State provider katalog, pencarian, filter, dan cuaca
│   ├── rental_provider.dart        # State provider data rental CRUD dan statistik
│   └── favorite_provider.dart      # Shared state wishlist & favorit pengguna
├── theme/
│   └── app_theme.dart              # Material 3 earth-tone outdoor theme
├── utils/
│   └── formatters.dart             # Formatter mata uang Rupiah (IDR) dan tanggal
├── widgets/
│   ├── gear_card.dart              # Reusable widget kartu produk katalog
│   ├── status_badge.dart           # Reusable badge status transaksi rental
│   ├── custom_text_field.dart      # Reusable text field form dengan validasi
│   ├── mountain_weather_card.dart  # Reusable card informasi cuaca live REST API
│   ├── responsive_layout.dart      # Reusable responsive layout builder & grid helper
│   ├── loading_state.dart          # Reusable loading indicator dengan pesan
│   ├── error_state.dart            # Reusable error handling widget dengan tombol retry
│   └── empty_state.dart            # Reusable empty state view
├── screens/
│   ├── main_navigation_screen.dart # Navigasi utama (NavigationBar di Compact & NavigationRail di Wide)
│   ├── home_screen.dart            # Dashboard beranda aplikasi
│   ├── catalog_screen.dart         # Screen katalog alat outdoor dengan filter & search
│   ├── gear_detail_screen.dart     # Screen detail spesifikasi perlengkapan
│   ├── create_rental_screen.dart   # Screen form tambah transaksi sewa (Create)
│   ├── edit_rental_screen.dart     # Screen form ubah data sewa (Update)
│   ├── rental_list_screen.dart     # Screen kelola daftar sewa & konfirmasi hapus (Read & Delete)
│   ├── favorites_screen.dart       # Screen daftar wishlist favorit
│   └── profile_screen.dart         # Screen identitas pengembang UTS & info teknis
└── main.dart                       # Entry point aplikasi & MultiProvider setup
```

---

## 🌐 Integrasi REST API & Backend Database

### 1. REST API
- **Sumber API Cuaca**: Open-Meteo REST API (`https://api.open-meteo.com/v1/forecast?latitude=-8.411&longitude=115.312&current_weather=true`).
- **Operasi**: `GET`
- **Model**: `MountainWeather`
- **Fungsi**: Mengambil data temperatur (°C), kecepatan angin (km/h), dan kode cuaca puncak gunung secara langsung, kemudian mengonversinya menjadi status keamanan pendakian (*Aman Mendaki*, *Waspada Angin Kencang*, atau *Hujan/Badai*).
- **Penanganan State**: Memiliki *Loading State*, *Error State* dengan tombol coba lagi (*retry*), dan *Content State*.

### 2. Backend Database
- **Platform**: Supabase (PostgreSQL).
- **Tabel Utama**: `rental_bookings` (13 field data termasuk Primary Key).
- **Skema Database**:
  ```sql
  CREATE TABLE rental_bookings (
      id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
      student_id VARCHAR(50) DEFAULT '2415051011' NOT NULL,
      customer_name VARCHAR(100) NOT NULL,
      customer_phone VARCHAR(30) NOT NULL,
      gear_id VARCHAR(50) NOT NULL,
      gear_name VARCHAR(150) NOT NULL,
      rental_days INTEGER NOT NULL CHECK (rental_days > 0),
      start_date VARCHAR(50) NOT NULL,
      return_date VARCHAR(50) NOT NULL,
      total_price NUMERIC(12, 2) NOT NULL CHECK (total_price >= 0),
      note TEXT,
      status VARCHAR(30) DEFAULT 'Aktif' NOT NULL,
      created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
  );
  ```
- **Operasi CRUD**:
  - **Create**: Penambahan data sewa baru via form tervalidasi.
  - **Read**: Pengambilan dan penampilan seluruh data sewa aktif, selesai, dan dibatalkan.
  - **Update**: Pembaruan nama pelanggan, nomor telepon, durasi sewa, total tarif, dan status.
  - **Delete**: Penghapusan data sewa dengan modal konfirmasi dialog (*AlertDialog*).
- **Keamanan Credential**: Hanya menggunakan *anon public key* yang aman untuk aplikasi klien, tidak menyimpan *service_role secret key*.

---

## 📐 Tata Letak Responsif (Responsive Layout)

Aplikasi memiliki minimal 2 kondisi tata letak adaptif:
1. **Compact Mode (Lebar layar < 600px - Smartphone)**:
   - Navigasi bawah menggunakan Material 3 `NavigationBar`.
   - Grid katalog menggunakan 2 kolom kartu produk.
   - Tata letak detail produk vertikal satu kolom.
2. **Wide Mode (Lebar layar ≥ 600px - Tablet & Desktop)**:
   - Navigasi berpindah secara otomatis menjadi `NavigationRail` di sisi kiri layar.
   - Grid katalog bertransformasi menjadi 3 hingga 4 kolom secara proporsional.
   - Tata letak komponen menyesuaikan ruang horizontal tanpa menghasilkan `RenderFlex overflow`.

---

## 📊 Matriks Pemenuhan Spesifikasi UTS

| No | Komponen Spesifikasi | Ketentuan Minimum | Status Implementasi | Keterangan |
| :---: | :--- | :---: | :---: | :--- |
| 1 | Screen Fungsional | ≥ 6 Screen | ✅ **Terpenuhi (8 Screen)** | Home, Catalog, Detail, Create, Edit, Rental List, Wishlist, Profile |
| 2 | Dart Models | ≥ 2 Model | ✅ **Terpenuhi (3 Model)** | `OutdoorGear`, `RentalBooking`, `MountainWeather` |
| 3 | Reusable Widgets | ≥ 3 Widget | ✅ **Terpenuhi (8 Widget)** | `GearCard`, `StatusBadge`, `CustomTextField`, `MountainWeatherCard`, `ResponsiveLayout`, `LoadingState`, `ErrorState`, `EmptyState` |
| 4 | Kondisi Responsif | ≥ 2 Kondisi | ✅ **Terpenuhi** | Compact (< 600px) & Wide (≥ 600px) menggunakan `MediaQuery` & `LayoutBuilder` |
| 5 | REST API Integration | Minimal 1 (GET) | ✅ **Terpenuhi** | Open-Meteo Live Summit Weather API & Gear Catalog REST API |
| 6 | Backend Database | Minimal 1 | ✅ **Terpenuhi** | Supabase PostgreSQL + Local Persistence Sync |
| 7 | Field Tabel Database | ≥ 4 field + PK | ✅ **Terpenuhi (13 Field)** | `id`, `student_id`, `customer_name`, `customer_phone`, `gear_id`, `gear_name`, `rental_days`, `start_date`, `return_date`, `total_price`, `note`, `status`, `created_at` |
| 8 | Operasi CRUD Database | 4 Operasi Penuh | ✅ **Terpenuhi** | Create, Read, Update, Delete dengan konfirmasi dialog |
| 9 | State Management | Provider/ekuivalen | ✅ **Terpenuhi** | `Provider` + `ChangeNotifier` (`GearProvider`, `RentalProvider`, `FavoriteProvider`) |
| 10 | Multi-screen Navigation | Wajib | ✅ **Terpenuhi** | List → Detail, Passing Data ke Form, IndexedStack & NavigationBar/Rail |
| 11 | Form & Validasi | Minimal 1 Form | ✅ **Terpenuhi (2 Form)** | Form Sewa Baru (`CreateRentalScreen`) & Form Edit Data (`EditRentalScreen`) |
| 12 | User Feedback | SnackBar/Dialog | ✅ **Terpenuhi** | SnackBar, AlertDialog Konfirmasi Hapus, Date Picker |
| 13 | Handling State | Loading, Error, Empty | ✅ **Terpenuhi** | Dikelola pada setiap layer Provider dan Widget |
| 14 | Git Meaningful Commits | ≥ 16 Commit | ✅ **Terpenuhi (16 Commit)** | Mengikuti milestone 1-16 sesuai lembar soal UTS |

---

## 📜 Riwayat Milestone Commit Git

Berikut adalah 16 milestone commit bertahap yang telah diimplementasikan:

```
* Finalize UTS mobile application (Milestone 16)
* Improve UI and responsive behavior (Milestone 15)
* Add loading and error handling (Milestone 14)
* Add interaction and user feedback (Milestone 13)
* Implement delete data feature (Milestone 12)
* Implement update data feature (Milestone 11)
* Implement create data feature (Milestone 10)
* Integrate backend database (Milestone 9)
* Integrate REST API (Milestone 8)
* Implement application state management (Milestone 7)
* Add application data models (Milestone 6)
* Add application navigation (Milestone 5)
* Implement responsive layouts (Milestone 4)
* Build initial application UI (Milestone 3)
* Setup project architecture and folders (Milestone 2)
* Initialize Flutter UTS project (Milestone 1)
```

---

## 🚀 Panduan Menjalankan Project

### 1. Prasyarat
- Flutter SDK versi 3.13 atau yang lebih baru.
- Dart SDK versi 3.13+.
- Android Studio / VS Code dengan ekstensi Flutter & Dart.

### 2. Langkah Menjalankan
1. Clone repository GitHub:
   ```bash
   git clone https://github.com/emip0525/flutter_uts_miftah.git
   cd flutter_uts_miftah
   ```
2. Pasang seluruh dependensi:
   ```bash
   flutter pub get
   ```
3. Jalankan pengujian otomatis (*unit & widget tests*):
   ```bash
   flutter test
   ```
4. Jalankan aplikasi pada emulator atau perangkat fisik:
   ```bash
   flutter run
   ```
5. Untuk membangun file APK:
   ```bash
   flutter build apk --debug
   # atau
   flutter build apk --release
   ```

---

*Project Ujian Tengah Semester (UTS) - Pemrograman Mobile - Dibuat dengan dedikasi oleh Miftah Fadilatus Sakhila (2415051011).*
