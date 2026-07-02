# Paper Resmi: Analisis Sistem dan Logic Aplikasi TechStack Hub

## Identitas Project

**Judul Aplikasi:** TechStack Hub  
**Jenis Aplikasi:** Katalog software berbasis Flutter dan Supabase  
**Platform Target:** Web, Android, dan perangkat mobile lain yang didukung Flutter  
**Anggota Tim:** Agung, Ritchy, Juan, Farrel, Unif  
**Teknologi Utama:** Flutter, Dart, Supabase, GitHub Pages, GitHub Actions  

## Abstrak

TechStack Hub adalah aplikasi katalog software yang dirancang untuk membantu pengguna mencatat, mengelola, meninjau, dan mengakses informasi perangkat lunak secara terstruktur. Aplikasi ini menyediakan autentikasi pengguna, dashboard statistik, manajemen data software, kategori, vendor, favorit, ulasan, profil pengguna, serta unggah gambar ke Supabase Storage. Dari sisi tampilan, aplikasi menggunakan tema gelap premium yang terinspirasi dari design system Spotify, dengan warna dasar hitam, teks putih, aksen hijau, kartu ringkas, animasi fade, dan opening screen dengan audio pembuka.

Sistem menggunakan Supabase sebagai backend-as-a-service untuk autentikasi, database PostgreSQL, remote procedure call untuk statistik dashboard, dan storage untuk gambar. Flutter digunakan sebagai frontend cross-platform sehingga aplikasi dapat dijalankan di browser, emulator Android, maupun smartphone. Deployment web dikonfigurasi melalui GitHub Actions ke GitHub Pages.

## 1. Latar Belakang

Perkembangan software yang semakin cepat membuat mahasiswa, developer, dan pengguna teknologi sering berhadapan dengan banyak pilihan aplikasi. Setiap aplikasi memiliki kategori, vendor, platform, model harga, rating, website, serta deskripsi yang berbeda. Tanpa sistem pencatatan yang baik, data software menjadi sulit dibandingkan dan sulit dikelola.

TechStack Hub dibuat untuk menjawab kebutuhan tersebut. Aplikasi ini berfungsi sebagai pusat katalog software yang memungkinkan pengguna menyimpan data aplikasi, mengelompokkan berdasarkan kategori, mencatat vendor pembuat, memberi rating dan ulasan, serta menyimpan software favorit. Dengan adanya fitur login, data dapat dihubungkan dengan identitas pengguna. Dengan adanya dashboard, pengguna dapat melihat ringkasan jumlah software, kategori, vendor, favorit, dan rata-rata rating.

Selain kebutuhan fungsional, project ini juga memperhatikan pengalaman pengguna. Karena aplikasi katalog harus sering dibuka dan digunakan berulang, tampilan dibuat ringan, gelap, konsisten, dan mudah dipindai. Pendekatan desain ini membantu pengguna fokus pada konten tanpa terganggu elemen visual yang terlalu ramai.

## 2. Rumusan Masalah

Rumusan masalah yang menjadi dasar pengembangan TechStack Hub adalah:

1. Bagaimana membangun aplikasi katalog software yang mendukung login dan pengelolaan data?
2. Bagaimana menyediakan fitur CRUD untuk software, kategori, dan vendor?
3. Bagaimana menampilkan informasi software secara detail, termasuk link website, rating, ulasan, dan favorit?
4. Bagaimana menghubungkan Flutter dengan Supabase sebagai backend?
5. Bagaimana membuat tampilan aplikasi mobile-friendly dan mudah digunakan?
6. Bagaimana menyiapkan project agar dapat dijalankan secara lokal dan dideploy ke GitHub Pages?

## 3. Tujuan Project

Tujuan project TechStack Hub adalah:

1. Membuat aplikasi katalog software berbasis Flutter.
2. Menyediakan autentikasi login dan register menggunakan Supabase Auth.
3. Membuat fitur CRUD untuk data software, kategori, dan vendor.
4. Menyediakan fitur favorit dan review software.
5. Menampilkan dashboard statistik untuk pengguna.
6. Menyediakan tampilan responsif dengan desain gelap premium.
7. Menyiapkan workflow deployment ke GitHub Pages.

## 4. Ruang Lingkup Sistem

Ruang lingkup sistem meliputi:

1. Autentikasi pengguna melalui email dan password.
2. Splash/opening screen dengan animasi dan audio pembuka.
3. Dashboard berisi sapaan pengguna, banner auto-scroll, statistik, dan akses cepat.
4. Manajemen software dengan fitur tambah, lihat, edit, hapus, upload gambar, dan link website.
5. Manajemen kategori dengan fitur tambah, lihat, edit, hapus.
6. Manajemen vendor dengan fitur tambah, lihat, edit, hapus, dan buka website vendor.
7. Favorit software per pengguna.
8. Review software berupa rating bintang dan komentar.
9. Profil pengguna.
10. Deployment web menggunakan GitHub Actions dan GitHub Pages.

## 5. Teknologi yang Digunakan

### 5.1 Flutter

Flutter digunakan sebagai framework utama untuk membangun antarmuka aplikasi. Keunggulan Flutter adalah satu basis kode dapat berjalan di berbagai platform seperti web, Android, iOS, Windows, macOS, dan Linux.

### 5.2 Dart

Dart digunakan sebagai bahasa pemrograman untuk semua logic frontend, state sederhana, validasi form, navigasi, pemanggilan API Supabase, dan rendering UI.

### 5.3 Supabase

Supabase digunakan sebagai backend. Komponen Supabase yang digunakan meliputi:

- Supabase Auth untuk login dan register.
- Supabase Database PostgreSQL untuk menyimpan data profil, software, kategori, vendor, favorit, dan review.
- Supabase Storage untuk upload gambar software.
- Supabase RPC untuk mengambil statistik dashboard melalui fungsi `get_dashboard_stats`.

### 5.4 GitHub Actions dan GitHub Pages

GitHub Actions digunakan untuk proses CI/CD. Workflow melakukan instalasi dependency, analisis kode, test, build Flutter Web, lalu deploy ke GitHub Pages.

### 5.5 Library Pendukung

Dependency utama:

- `supabase_flutter`: koneksi Flutter dengan Supabase.
- `flutter_dotenv`: membaca variabel environment dari `.env`.
- `image_picker`: memilih gambar dari perangkat.
- `cached_network_image`: pengelolaan image network.
- `google_fonts`: menggunakan font Inter.
- `url_launcher`: membuka website software atau vendor.

## 6. Arsitektur Sistem

Secara umum, arsitektur TechStack Hub terdiri dari tiga lapisan:

1. **Presentation Layer**
   Berisi screen dan widget Flutter, seperti login, register, dashboard, list software, detail software, kategori, vendor, favorit, dan profil.

2. **Service Layer**
   Berisi `SupabaseService`, yaitu class yang menghubungkan UI dengan Supabase. Semua operasi database, auth, storage, dan RPC dilakukan melalui service ini.

3. **Data Layer**
   Berisi model data seperti `SoftwareProduct`, `SoftwareCategory`, `Vendor`, `Review`, dan `UserProfile`.

Alur data dimulai dari interaksi pengguna di UI, kemudian UI memanggil fungsi di `SupabaseService`, lalu Supabase mengembalikan data dalam bentuk JSON. JSON tersebut dikonversi menjadi model Dart dan ditampilkan kembali ke UI.

## 7. Struktur Folder Utama

Struktur folder penting pada project:

```text
lib/
  main.dart
  models/
    category.dart
    profile.dart
    review.dart
    software_product.dart
    vendor.dart
  screens/
    add_edit_software_screen.dart
    category_list_screen.dart
    dashboard_screen.dart
    favorites_screen.dart
    login_screen.dart
    profile_screen.dart
    register_screen.dart
    software_detail_screen.dart
    software_list_screen.dart
    vendor_list_screen.dart
  services/
    opening_sound_player.dart
    opening_sound_player_stub.dart
    opening_sound_player_web.dart
    supabase_service.dart
  widgets/
    animated_card.dart
    fade_slide_in.dart
    solid_background.dart
web/
  index.html
.github/workflows/
  dart.yml
```

## 8. Analisis Logic Sistem

### 8.1 Initialisasi Aplikasi

File `main.dart` menjadi entry point aplikasi. Pada tahap awal, aplikasi:

1. Memanggil `WidgetsFlutterBinding.ensureInitialized()`.
2. Membaca file `.env` menggunakan `flutter_dotenv`.
3. Menginisialisasi Supabase menggunakan `SUPABASE_URL` dan `SUPABASE_ANON_KEY`.
4. Menjalankan `TechstackHubApp`.

Setelah aplikasi berjalan, `SplashScreen` ditampilkan terlebih dahulu selama 8 detik. Splash screen memiliki animasi teks:

- `TechStack` bertransisi menjadi `Welcome`.
- `Software Catalog & Elevated` bertransisi menjadi `To My Software`.

Audio pembuka `harudusfx.mp3` diputar saat progress opening mencapai 1 persen. Hal ini dilakukan agar timing audio mengikuti timeline visual, bukan mengikuti kecepatan loading perangkat.

### 8.2 Logic Autentikasi

Login dan register menggunakan Supabase Auth.

Pada login:

1. Pengguna mengisi email dan password.
2. Sistem memvalidasi field tidak kosong.
3. Sistem memanggil `signInWithPassword`.
4. Jika berhasil, pengguna diarahkan ke dashboard.
5. Jika gagal, sistem menampilkan snackbar error.

Pada register:

1. Pengguna mengisi nama lengkap, email, dan password.
2. Sistem memanggil `signUp`.
3. Metadata `full_name` dikirim ke Supabase.
4. Jika Supabase langsung menghasilkan session, pengguna diarahkan ke dashboard.
5. Jika email confirmation aktif, pengguna diminta login setelah registrasi.

### 8.3 Logic Routing

Routing dilakukan dengan `Navigator` dan `MaterialPageRoute`. Setelah splash screen selesai, sistem memeriksa session:

- Jika `currentSession == null`, pengguna diarahkan ke login.
- Jika session tersedia, pengguna langsung diarahkan ke dashboard.

### 8.4 Logic Dashboard

Dashboard mengambil data statistik melalui `SupabaseService.getDashboardStats()`, yang memanggil RPC `get_dashboard_stats`. Data yang ditampilkan meliputi:

- Total software.
- Total kategori.
- Total vendor.
- Total favorit.
- Rata-rata rating.

Dashboard juga membaca nama pengguna dari metadata Supabase atau tabel profil. Jika nama tidak ditemukan, sistem memakai username dari email.

Dashboard memiliki banner auto-scroll dengan gambar bertema teknologi dari Unsplash. Banner ini hanya bersifat visual dan tidak memiliki tombol palsu, sehingga tidak membingungkan pengguna.

### 8.5 Logic CRUD Software

Fitur software terdiri dari:

- Menampilkan daftar software.
- Menambah software.
- Melihat detail software.
- Mengedit software.
- Menghapus software.
- Upload gambar.
- Membuka link website software.

Pada tambah software, data form dikirim ke tabel `software_products`. Field `created_by` otomatis diisi dengan ID user yang sedang login.

Pada edit software, data dikirim ke fungsi `updateSoftware` berdasarkan ID software.

Pada hapus software, data dihapus berdasarkan ID software.

Pada upload gambar, file dipilih menggunakan `image_picker`, kemudian diupload ke bucket `software-images`. Public URL hasil upload disimpan sebagai `main_image_url`.

### 8.6 Logic Detail Software

Detail software memuat:

- Gambar utama.
- Nama software.
- Deskripsi singkat.
- Rating.
- Tipe harga.
- Deskripsi lengkap.
- Kategori.
- Vendor.
- Platform.
- Versi.
- Tombol buka website.
- Tombol favorit.
- Ulasan dan form tambah ulasan.
- Menu edit dan hapus jika software dibuat oleh user yang sedang login.

Jika `website_url` software tersedia, tombol `BUKA WEBSITE` membuka link tersebut. Jika tidak tersedia tetapi vendor memiliki website, tombol akan membuka website vendor.

### 8.7 Logic Kategori

Kategori memiliki fitur CRUD:

- Tambah kategori.
- Lihat daftar kategori.
- Edit kategori.
- Hapus kategori.
- Lihat software berdasarkan kategori.

Kategori disimpan pada tabel `software_categories` dengan field seperti `name`, `description`, `icon_name`, dan `color_hex`.

### 8.8 Logic Vendor

Vendor memiliki fitur CRUD:

- Tambah vendor.
- Lihat daftar vendor.
- Edit vendor.
- Hapus vendor.
- Buka website vendor.

Vendor disimpan pada tabel `vendors` dengan field seperti `name`, `website_url`, `country`, dan `description`.

### 8.9 Logic Favorit

Fitur favorit menyimpan hubungan antara user dan software. Ketika pengguna menekan ikon favorit pada detail software:

- Jika belum favorit, sistem menyimpan data ke tabel `favorites`.
- Jika sudah favorit, sistem menghapus data dari tabel `favorites`.

Halaman Favorit Saya menampilkan daftar software yang telah disimpan pengguna.

### 8.10 Logic Ulasan

Ulasan software terdiri dari rating bintang dan komentar. Data disimpan ke tabel `software_reviews` dengan field:

- `software_id`
- `user_id`
- `rating`
- `comment`

Setelah ulasan ditambahkan, halaman detail dimuat ulang agar data review terbaru muncul.

### 8.11 Logic Profil

Profil mengambil data dari tabel `profiles` berdasarkan ID user yang sedang login. Profil menampilkan nama lengkap, role, dan avatar jika tersedia.

### 8.12 Logic Deployment

Workflow GitHub Actions terdapat pada `.github/workflows/dart.yml`. Alurnya:

1. Checkout repository.
2. Setup Flutter stable.
3. Install dependency dengan `flutter pub get`.
4. Analyze kode dengan `flutter analyze lib test`.
5. Menjalankan test dengan `flutter test`.
6. Build Flutter Web dengan base href `/Flutter-Techstack/`.
7. Membuat `.nojekyll` dan `404.html`.
8. Upload artifact `build/web`.
9. Deploy ke GitHub Pages.

## 9. Analisis Data Model

### 9.1 SoftwareProduct

Model ini merepresentasikan data software. Field penting:

- `id`
- `name`
- `shortDescription`
- `description`
- `platform`
- `version`
- `pricingType`
- `websiteUrl`
- `mainImageUrl`
- `rating`
- `isFeatured`
- `categoryId`
- `vendorId`
- `createdBy`
- `createdAt`
- `updatedAt`
- joined field seperti `categoryName`, `vendorName`, dan `creatorName`

### 9.2 SoftwareCategory

Model kategori berisi:

- `id`
- `name`
- `description`
- `iconName`
- `colorHex`

### 9.3 Vendor

Model vendor berisi:

- `id`
- `name`
- `websiteUrl`
- `country`
- `description`

### 9.4 Review

Model review berisi:

- `id`
- `softwareId`
- `userId`
- `rating`
- `comment`
- `createdAt`

### 9.5 UserProfile

Model profil berisi:

- `id`
- `fullName`
- `role`
- `avatarUrl`
- `createdAt`

## 10. Desain UI/UX

Desain TechStack Hub menggunakan pendekatan dark premium yang terinspirasi dari Spotify. Karakteristik utama desain:

- Background hitam `#121212`.
- Surface gelap `#181818` dan `#1F1F1F`.
- Teks utama putih.
- Teks sekunder abu-abu.
- Aksen hijau `#1ED760`.
- Tombol pill.
- Card radius 8px.
- Animasi fade dan slide ringan.
- Opening screen dengan audio.
- Banner auto-scroll.
- Responsif untuk desktop dan mobile.

Desain ini dipilih karena aplikasi katalog membutuhkan fokus terhadap konten. Warna gelap membantu gambar dan data software terlihat lebih menonjol, sementara aksen hijau hanya digunakan untuk aksi utama agar tidak berlebihan.

## 11. Fitur Utama Aplikasi

Fitur utama TechStack Hub:

1. Login dan register.
2. Opening screen dengan animasi dan audio.
3. Dashboard statistik.
4. Banner auto-scroll.
5. CRUD software.
6. Upload gambar software.
7. Detail software.
8. Tombol buka website.
9. CRUD kategori.
10. CRUD vendor.
11. Favorit software.
12. Review dan rating software.
13. Profil pengguna.
14. Deployment GitHub Pages.

## 12. SWOT Analysis

### 12.1 Strengths

1. Aplikasi memiliki fitur inti lengkap: login, CRUD, favorit, review, kategori, dan vendor.
2. Backend menggunakan Supabase sehingga pengembangan lebih cepat.
3. UI modern, gelap, dan responsif.
4. Project dapat dijalankan di web dan mobile melalui Flutter.
5. Deployment sudah disiapkan menggunakan GitHub Actions dan GitHub Pages.
6. Data software lebih terstruktur karena memiliki kategori dan vendor.

### 12.2 Weaknesses

1. Aplikasi masih bergantung pada koneksi internet karena data berada di Supabase.
2. Autoplay audio pada web dapat dibatasi oleh policy browser.
3. Manajemen role pengguna belum dikembangkan secara penuh.
4. Filter dan pencarian software masih dapat dikembangkan lebih lanjut.
5. Beberapa fitur masih menggunakan state sederhana tanpa state management kompleks.

### 12.3 Opportunities

1. Dapat dikembangkan menjadi platform rekomendasi software.
2. Dapat menambahkan fitur pencarian, filter lanjutan, dan sorting.
3. Dapat menambahkan role admin untuk moderasi data.
4. Dapat dikembangkan sebagai aplikasi mobile production.
5. Dapat diintegrasikan dengan API eksternal untuk mengambil data software otomatis.

### 12.4 Threats

1. Kesalahan konfigurasi RLS Supabase dapat menghambat CRUD.
2. Jika API key atau environment salah, aplikasi tidak dapat terhubung ke backend.
3. GitHub Pages memiliki batasan untuk backend dinamis sehingga tetap membutuhkan Supabase.
4. Policy browser dapat memblok audio autoplay.
5. Jika storage atau database Supabase melebihi limit free tier, aplikasi dapat terganggu.

## 13. Pengujian

Pengujian dilakukan dengan:

1. `flutter analyze lib test` untuk memeriksa error statis.
2. `flutter test` untuk memastikan widget dasar berjalan.
3. Build web release menggunakan `flutter build web --release`.
4. Pengujian manual pada login, register, dashboard, CRUD software, kategori, vendor, favorit, review, dan buka link website.

## 14. Skenario Demo Aplikasi

Skenario demo yang dapat dilakukan saat presentasi:

1. Buka aplikasi di browser, emulator Android, atau smartphone.
2. Tampilkan opening screen dengan animasi dan audio.
3. Login menggunakan akun yang sudah tersedia.
4. Tunjukkan dashboard dan statistik.
5. Tambah data software baru.
6. Upload gambar atau gunakan gambar URL.
7. Buka detail software.
8. Klik tombol buka website.
9. Tambahkan software ke favorit.
10. Tambahkan review dan rating.
11. Buka halaman kategori dan lakukan tambah/edit kategori.
12. Buka halaman vendor dan lakukan tambah/edit vendor.
13. Logout dari aplikasi.

Jika laptop tidak memadai untuk emulator Android, demo dapat menggunakan browser atau smartphone.

## 15. Kesimpulan

TechStack Hub adalah aplikasi katalog software yang menggabungkan fitur CRUD, autentikasi, dashboard, favorit, review, kategori, vendor, dan deployment web. Sistem ini memanfaatkan Flutter untuk frontend dan Supabase untuk backend sehingga pengembangan lebih cepat dan fleksibel. Dari sisi UI/UX, aplikasi mengutamakan tampilan gelap, responsif, dan fokus pada konten. Secara keseluruhan, TechStack Hub sudah memenuhi kebutuhan dasar aplikasi katalog software dengan login dan CRUD, serta masih memiliki peluang besar untuk dikembangkan menjadi sistem rekomendasi software yang lebih lengkap.

## 16. Penjelasan Tambahan untuk Presentasi

Bagian ini ditambahkan sebagai materi pendukung apabila dosen meminta penjelasan lebih rinci di luar demo aplikasi.

### 16.1 Alasan Pemilihan Teknologi

Flutter dipilih karena mampu menghasilkan aplikasi multi-platform dari satu basis kode. Dalam konteks presentasi, hal ini menguntungkan karena aplikasi dapat didemokan melalui browser, emulator Android, ataupun smartphone. Supabase dipilih karena menyediakan backend siap pakai yang sudah mencakup autentikasi, database PostgreSQL, storage, dan RPC. GitHub Pages dipilih sebagai media deployment karena cocok untuk aplikasi web statis hasil build Flutter.

### 16.2 Diagram Alur Sistem

```text
User
  |
  v
Flutter UI
  |
  v
SupabaseService
  |
  +--> Supabase Auth
  +--> Supabase Database
  +--> Supabase Storage
  +--> Supabase RPC
```

Penjelasan:

1. User melakukan aksi pada UI, misalnya login, tambah software, edit kategori, atau tambah review.
2. UI Flutter memanggil fungsi pada `SupabaseService`.
3. `SupabaseService` mengirim request ke Supabase.
4. Supabase mengembalikan data.
5. Data dikonversi menjadi model Dart dan ditampilkan kembali ke user.

### 16.3 Pembagian Komponen Sistem

| Komponen | Fungsi |
|---|---|
| `main.dart` | Entry point aplikasi, inisialisasi Supabase, theme global, splash screen |
| `SupabaseService` | Pusat logic koneksi ke database, auth, storage, dan RPC |
| `models/` | Representasi data seperti software, kategori, vendor, review, profil |
| `screens/` | Halaman UI seperti login, dashboard, software, kategori, vendor |
| `widgets/` | Komponen reusable seperti animated card, fade slide, background |
| `.github/workflows/dart.yml` | Workflow build dan deploy ke GitHub Pages |

### 16.4 Detail Alur Opening Screen

Opening screen berjalan selama 8 detik. Teks `TechStack` bertransisi menjadi `Welcome`, sedangkan `Software Catalog & Elevated` bertransisi menjadi `To My Software`. Sound `harudusfx.mp3` diputar saat progress animasi mencapai 1 persen. Dengan pendekatan ini, waktu mulai sound tidak bergantung pada cepat-lambatnya perangkat, tetapi mengikuti timeline animasi Flutter.

### 16.5 Detail Alur Login dan Register

Pada login, user memasukkan email dan password. Sistem memanggil Supabase Auth melalui `signInWithPassword`. Jika berhasil, user diarahkan ke dashboard. Jika gagal, snackbar error ditampilkan.

Pada register, user memasukkan nama lengkap, email, dan password. Nama lengkap dikirim sebagai metadata `full_name`. Jika Supabase langsung mengembalikan session, user diarahkan ke dashboard. Jika email confirmation aktif, user diminta login setelah registrasi.

### 16.6 Detail Hak Akses Data

Pada software, field `created_by` digunakan untuk menyimpan ID user pembuat data. Saat halaman detail dibuka, aplikasi membandingkan `created_by` dengan `currentUserId`. Jika sama, menu edit dan hapus ditampilkan. Jika berbeda, user tetap dapat melihat detail, memberi favorit, dan memberi review, tetapi tidak dapat mengedit data milik user lain.

### 16.7 Detail Demo yang Disarankan

Durasi ideal demo adalah 5 sampai 8 menit.

| Waktu | Aktivitas |
|---|---|
| 0:00 - 0:30 | Buka aplikasi dan tampilkan opening screen |
| 0:30 - 1:00 | Login |
| 1:00 - 1:45 | Jelaskan dashboard dan statistik |
| 1:45 - 3:00 | Tambah software |
| 3:00 - 4:00 | Detail software, website, favorit, review |
| 4:00 - 5:00 | CRUD kategori |
| 5:00 - 6:00 | CRUD vendor |
| 6:00 - 7:00 | Logout dan kesimpulan |

### 16.8 Contoh Data Demo

Contoh data software:

| Field | Contoh |
|---|---|
| Nama | Figma |
| Deskripsi Singkat | Tool desain UI/UX berbasis cloud |
| Platform | Web, Desktop |
| Versi | Latest |
| Tipe Harga | Freemium |
| Website | https://figma.com |
| Kategori | Design |
| Vendor | Figma |

Contoh kategori:

- Development
- Design
- Productivity
- Artificial Intelligence

Contoh vendor:

- Google
- Microsoft
- Adobe
- Figma

### 16.9 Pembagian Peran Anggota

Pembagian ini dapat disesuaikan dengan kontribusi asli masing-masing anggota.

| Anggota | Peran |
|---|---|
| Agung | Pembuka, latar belakang, koordinasi presentasi |
| Ritchy | Penjelasan desain UI/UX dan dashboard |
| Juan | Penjelasan logic sistem, database, Supabase |
| Farrel | Demo fitur CRUD, favorit, dan review |
| Unif | SWOT, deployment, dan kesimpulan |

### 16.10 Potensi Pertanyaan Dosen dan Jawaban

**Mengapa menggunakan Flutter?**  
Karena Flutter memungkinkan aplikasi berjalan di web dan mobile dengan satu basis kode, sehingga demo dapat dilakukan melalui browser, emulator Android, atau smartphone.

**Mengapa menggunakan Supabase?**  
Supabase menyediakan autentikasi, database PostgreSQL, storage, dan RPC dalam satu platform, sehingga backend dapat dibuat lebih cepat.

**Apa fitur CRUD utama aplikasi?**  
CRUD tersedia pada software, kategori, dan vendor. Selain itu ada fitur favorit dan review.

**Bagaimana aplikasi membedakan user?**  
Aplikasi membaca `currentUserId` dari Supabase Auth. ID ini dipakai pada data software, favorit, review, dan profil.

**Apa kelemahan aplikasi?**  
Aplikasi masih bergantung pada internet dan Supabase. Fitur pencarian dan filter lanjutan juga masih dapat dikembangkan.

**Bagaimana deployment dilakukan?**  
Deployment dilakukan melalui GitHub Actions. Workflow menjalankan analyze, test, build web, lalu deploy folder `build/web` ke GitHub Pages.

### 16.11 Checklist Sebelum Presentasi

1. Pastikan akun demo bisa login.
2. Pastikan Supabase aktif.
3. Siapkan data software, kategori, dan vendor.
4. Pastikan koneksi internet stabil.
5. Buka aplikasi sebelum giliran presentasi.
6. Jika laptop tidak kuat menjalankan emulator, gunakan browser atau smartphone.
7. Pastikan fitur CRUD yang akan didemokan tidak terhalang policy RLS Supabase.
