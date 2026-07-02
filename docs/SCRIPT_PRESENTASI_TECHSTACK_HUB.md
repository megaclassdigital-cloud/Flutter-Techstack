# Script Presentasi TechStack Hub

## Slide 1 - Pembuka

Selamat pagi/siang Bapak/Ibu dosen dan teman-teman semua.  
Kami dari kelompok TechStack Hub akan mempresentasikan project aplikasi kami yang berjudul **TechStack Hub**.

Anggota kelompok kami adalah:

- Agung
- Ritchy
- Juan
- Farrel
- Unif

TechStack Hub adalah aplikasi katalog software yang dibuat menggunakan Flutter dan Supabase. Aplikasi ini mendukung login, register, CRUD data, favorit, review, kategori, vendor, dan dashboard.

## Slide 2 - Latar Belakang

Latar belakang dari project ini adalah banyaknya aplikasi atau software yang digunakan dalam kegiatan belajar, kerja, dan pengembangan project. Setiap software memiliki fungsi, kategori, vendor, platform, harga, website, dan rating yang berbeda.

Masalahnya, data software sering tidak terdokumentasi dengan rapi. Jika ingin membandingkan software, mencari link website, atau melihat vendor pembuatnya, pengguna harus mencari secara manual.

Karena itu kami membuat TechStack Hub sebagai aplikasi untuk menyimpan dan mengelola data software secara lebih terstruktur.

## Slide 3 - Tujuan Aplikasi

Tujuan aplikasi ini adalah:

1. Membuat katalog software yang mudah digunakan.
2. Menyediakan fitur login dan register.
3. Menyediakan CRUD software.
4. Menyediakan CRUD kategori dan vendor.
5. Menyediakan fitur favorit dan review.
6. Menampilkan dashboard statistik.
7. Membuat tampilan yang modern, responsif, dan bisa digunakan di web maupun mobile.

## Slide 4 - Teknologi yang Digunakan

Project ini menggunakan beberapa teknologi utama:

- **Flutter** untuk membangun tampilan aplikasi.
- **Dart** sebagai bahasa pemrograman.
- **Supabase** sebagai backend untuk auth, database, dan storage.
- **GitHub Actions** untuk build otomatis.
- **GitHub Pages** untuk deployment web.

Library pendukung yang kami gunakan antara lain:

- `supabase_flutter`
- `flutter_dotenv`
- `image_picker`
- `google_fonts`
- `cached_network_image`
- `url_launcher`

## Slide 5 - Gambaran Sistem

Secara sederhana, alur sistemnya seperti ini:

1. User membuka aplikasi.
2. Aplikasi menampilkan opening screen dengan animasi dan sound.
3. Jika belum login, user diarahkan ke halaman login.
4. Jika sudah login, user langsung masuk ke dashboard.
5. Di dashboard, user bisa melihat statistik dan masuk ke menu software, kategori, vendor, favorit, dan profil.
6. Semua data disimpan dan diambil dari Supabase.

## Slide 6 - Fitur Login dan Register

Fitur login dan register menggunakan Supabase Auth.

Pada register, user mengisi nama lengkap, email, dan password. Nama lengkap dikirim sebagai metadata `full_name`.

Pada login, user mengisi email dan password. Jika data benar, user masuk ke dashboard. Jika salah, aplikasi menampilkan pesan error.

Session login juga dicek saat splash screen. Jadi jika user sudah pernah login, aplikasi bisa langsung masuk ke dashboard.

## Slide 7 - Opening Screen

Aplikasi memiliki opening screen selama 8 detik. Opening ini menampilkan animasi:

- `TechStack` berubah menjadi `Welcome`
- `Software Catalog & Elevated` berubah menjadi `To My Software`

Selain itu, ada audio pembuka dari file `harudusfx.mp3`. Logic audio dipatok pada progress 1 persen dari animasi opening, agar timing-nya lebih konsisten di desktop maupun mobile.

## Slide 8 - Dashboard

Dashboard adalah halaman utama setelah login.

Di dashboard terdapat:

- Sapaan user, misalnya "Halo Agung, Selamat datang di Tech Stack Hub."
- Banner auto-scroll.
- Statistik total software, kategori, vendor, favorit, dan rata-rata rating.
- Menu akses cepat ke software, favorit, kategori, dan vendor.

Data statistik diambil dari Supabase menggunakan fungsi RPC `get_dashboard_stats`.

## Slide 9 - CRUD Software

Fitur utama aplikasi adalah CRUD software.

User dapat:

- Melihat daftar software.
- Menambah software baru.
- Mengedit software.
- Menghapus software.
- Upload gambar software.
- Mengisi website software.
- Memilih kategori.
- Memilih vendor.

Saat user menambah software, sistem otomatis mengisi field `created_by` dengan ID user yang sedang login.

## Slide 10 - Detail Software

Pada halaman detail software, user bisa melihat:

- Gambar software.
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
- Favorit.
- Review.

Jika software memiliki website, tombol `BUKA WEBSITE` akan membuka link software. Jika software tidak memiliki website tetapi vendor memiliki website, tombol akan membuka website vendor.

## Slide 11 - Fitur Favorit

Fitur favorit digunakan untuk menyimpan software yang dianggap penting oleh user.

Jika user menekan ikon favorit di halaman detail, data akan disimpan ke tabel `favorites`. Jika ditekan lagi atau dihapus dari halaman favorit, data favorit akan dihapus.

Dengan fitur ini, user dapat mengakses software penting dengan lebih cepat.

## Slide 12 - Fitur Review dan Rating

User dapat memberikan review pada software.

Review terdiri dari:

- Rating bintang dari 1 sampai 5.
- Komentar.

Data review disimpan ke tabel `software_reviews`. Setelah review ditambahkan, halaman detail akan memuat ulang data agar review baru langsung tampil.

## Slide 13 - CRUD Kategori

Aplikasi juga memiliki CRUD kategori.

User dapat:

- Menambah kategori.
- Melihat daftar kategori.
- Mengedit kategori.
- Menghapus kategori.
- Melihat software berdasarkan kategori.

Kategori membantu data software menjadi lebih terstruktur, misalnya kategori Development, Design, Productivity, AI, dan sebagainya.

## Slide 14 - CRUD Vendor

Selain kategori, aplikasi juga menyediakan CRUD vendor.

User dapat:

- Menambah vendor.
- Melihat daftar vendor.
- Mengedit vendor.
- Menghapus vendor.
- Membuka website vendor.

Vendor berguna untuk mengetahui perusahaan atau pembuat software, misalnya Microsoft, Google, Adobe, dan lainnya.

## Slide 15 - Desain UI/UX

Desain aplikasi menggunakan tema gelap premium yang terinspirasi dari Spotify.

Ciri-ciri desainnya:

- Background hitam.
- Teks putih.
- Aksen hijau.
- Card gelap.
- Tombol pill.
- Animasi fade dan slide.
- Layout responsif untuk mobile dan desktop.

Tujuan desain ini adalah agar pengguna fokus pada isi data software dan aplikasi tetap nyaman digunakan.

## Slide 16 - Struktur Logic

Logic utama aplikasi berada di `SupabaseService`.

Service ini menangani:

- Ambil data software.
- Tambah software.
- Edit software.
- Hapus software.
- Ambil kategori dan vendor.
- CRUD kategori dan vendor.
- Favorit.
- Review.
- Profil.
- Upload gambar.
- Statistik dashboard.

Dengan service ini, kode UI menjadi lebih rapi karena akses database dikumpulkan di satu tempat.

## Slide 17 - SWOT Analysis

### Strengths

Kekuatan aplikasi ini adalah fiturnya cukup lengkap. Sudah ada login, CRUD software, CRUD kategori, CRUD vendor, favorit, review, dashboard, dan upload gambar. Selain itu, aplikasi bisa berjalan di web dan mobile karena menggunakan Flutter.

### Weaknesses

Kelemahannya adalah aplikasi masih bergantung pada internet dan Supabase. Selain itu fitur pencarian dan filter lanjutan belum dikembangkan secara maksimal. Autoplay audio juga bisa dipengaruhi kebijakan browser.

### Opportunities

Peluangnya, aplikasi ini bisa dikembangkan menjadi platform rekomendasi software. Ke depan bisa ditambah fitur pencarian, sorting, role admin, API eksternal, dan rekomendasi berdasarkan rating.

### Threats

Ancamannya adalah jika konfigurasi Supabase salah, fitur CRUD bisa gagal. Selain itu, limit free tier Supabase dan kebijakan browser terhadap audio juga bisa memengaruhi penggunaan aplikasi.

## Slide 18 - Demo Aplikasi

Untuk demo, alurnya sebagai berikut:

1. Buka aplikasi.
2. Tampilkan opening screen.
3. Login menggunakan akun yang sudah disiapkan.
4. Masuk ke dashboard.
5. Tampilkan statistik dashboard.
6. Buka daftar software.
7. Tambah software baru.
8. Buka detail software.
9. Klik tombol buka website.
10. Tambahkan software ke favorit.
11. Tambahkan review.
12. Buka kategori dan demonstrasikan CRUD kategori.
13. Buka vendor dan demonstrasikan CRUD vendor.
14. Logout.

Demo dapat dilakukan menggunakan browser, emulator Android, atau smartphone. Jika laptop kurang kuat untuk emulator, demo bisa dilakukan melalui smartphone atau browser.

## Slide 19 - Deployment

Untuk deployment web, kami menggunakan GitHub Actions dan GitHub Pages.

Workflow melakukan:

1. Checkout repository.
2. Setup Flutter.
3. Install dependency.
4. Analyze kode.
5. Test.
6. Build web.
7. Upload artifact.
8. Deploy ke GitHub Pages.

Base href disesuaikan dengan nama repository, yaitu `/Flutter-Techstack/`.

## Slide 20 - Kesimpulan

Kesimpulannya, TechStack Hub adalah aplikasi katalog software berbasis Flutter dan Supabase yang mendukung login, CRUD, dashboard, favorit, review, kategori, dan vendor.

Aplikasi ini dibuat untuk membantu pengguna mengelola data software secara rapi, mudah dicari, dan mudah dibandingkan.

Project ini juga sudah disiapkan untuk demo melalui web, emulator Android, atau smartphone, serta dapat dideploy menggunakan GitHub Pages.

Terima kasih. Kami siap menerima pertanyaan.

## Catatan Untuk Presenter

Hal yang perlu disiapkan sebelum presentasi:

1. Akun login demo.
2. Minimal 2-3 data software.
3. Minimal 2 kategori.
4. Minimal 2 vendor.
5. Koneksi internet stabil.
6. Browser atau smartphone untuk demo.
7. Jika menggunakan emulator, pastikan laptop kuat dan emulator sudah dibuka sebelum presentasi.

## Lanjutan Detail Presentasi

Bagian ini dapat dipakai sebagai pegangan tambahan agar presentasi lebih lancar dan siap menghadapi pertanyaan dosen.

## Pembagian Pembicara yang Disarankan

Pembagian ini dapat disesuaikan:

- Agung: pembuka, nama anggota, latar belakang, tujuan.
- Ritchy: desain UI/UX, opening screen, dashboard.
- Juan: teknologi, Supabase, database, logic sistem.
- Farrel: demo login, CRUD software, favorit, review.
- Unif: CRUD kategori, CRUD vendor, SWOT, deployment, kesimpulan.

## Rundown Presentasi Jumat

Estimasi total: 10 sampai 15 menit.

| Waktu | Materi | Pembicara |
|---|---|---|
| 0:00 - 1:00 | Pembuka dan nama anggota | Agung |
| 1:00 - 2:30 | Latar belakang dan tujuan | Agung |
| 2:30 - 4:00 | Teknologi dan gambaran sistem | Juan |
| 4:00 - 5:30 | UI/UX dan dashboard | Ritchy |
| 5:30 - 9:00 | Demo login dan CRUD software | Farrel |
| 9:00 - 10:30 | Demo kategori, vendor, favorit, review | Farrel / Unif |
| 10:30 - 12:00 | SWOT | Unif |
| 12:00 - 13:00 | Deployment dan kesimpulan | Unif |
| 13:00 - selesai | Tanya jawab | Semua anggota |

## Script Demo Rinci

### Bagian 1 - Membuka Aplikasi

Kalimat:

"Sekarang kami akan masuk ke demo aplikasi. Saat aplikasi dibuka, sistem menampilkan opening screen dengan animasi teks dan audio pembuka."

Tindakan:

1. Buka aplikasi.
2. Tampilkan opening screen.
3. Tunggu sampai masuk ke halaman login atau dashboard.

Catatan:

Jika browser memblok autoplay audio, jelaskan bahwa browser tertentu membutuhkan interaksi user untuk memutar audio.

### Bagian 2 - Login

Kalimat:

"Untuk masuk ke aplikasi, user harus login menggunakan email dan password. Authentikasi ini terhubung dengan Supabase Auth."

Tindakan:

1. Isi email demo.
2. Isi password demo.
3. Klik tombol login.
4. Tunjukkan dashboard.

### Bagian 3 - Dashboard

Kalimat:

"Setelah login, user masuk ke dashboard. Di sini terdapat sapaan sesuai user, banner auto-scroll, statistik, dan akses cepat."

Tindakan:

1. Tunjuk sapaan user.
2. Tunjuk banner.
3. Tunjuk total software.
4. Tunjuk total kategori.
5. Tunjuk total vendor.
6. Tunjuk favorit dan rating.

### Bagian 4 - CRUD Software

Kalimat:

"Fitur utama aplikasi ini adalah CRUD software. User dapat menambah, melihat, mengedit, dan menghapus data software."

Tindakan:

1. Klik Jelajahi Software.
2. Klik tombol tambah.
3. Isi nama software.
4. Isi deskripsi singkat.
5. Isi platform dan versi.
6. Pilih tipe harga.
7. Isi website.
8. Pilih kategori.
9. Pilih vendor.
10. Pilih gambar jika diperlukan.
11. Klik simpan.
12. Tunjukkan software baru muncul di daftar.

### Bagian 5 - Detail Software, Website, Favorit, dan Review

Kalimat:

"Pada halaman detail, user dapat melihat informasi lengkap software, membuka website, menyimpan ke favorit, dan memberi review."

Tindakan:

1. Klik salah satu software.
2. Tunjukkan detail software.
3. Klik tombol `BUKA WEBSITE`.
4. Klik ikon favorit.
5. Pilih rating.
6. Isi komentar.
7. Klik kirim ulasan.

### Bagian 6 - CRUD Kategori

Kalimat:

"Kategori digunakan untuk mengelompokkan software agar data lebih terstruktur."

Tindakan:

1. Kembali ke dashboard.
2. Masuk ke menu Kategori.
3. Klik tambah kategori.
4. Isi nama dan deskripsi.
5. Simpan.
6. Edit kategori.
7. Buka kategori untuk melihat software berdasarkan kategori.

### Bagian 7 - CRUD Vendor

Kalimat:

"Vendor digunakan untuk menyimpan informasi perusahaan atau pembuat software."

Tindakan:

1. Kembali ke dashboard.
2. Masuk ke menu Vendor.
3. Klik tambah vendor.
4. Isi nama vendor.
5. Isi website.
6. Isi negara dan deskripsi.
7. Simpan.
8. Klik ikon buka website.
9. Edit vendor jika perlu.

### Bagian 8 - Logout

Kalimat:

"Terakhir, user dapat logout dari aplikasi untuk mengakhiri session."

Tindakan:

1. Kembali ke dashboard.
2. Klik logout.
3. Tunjukkan halaman login.

## Pertanyaan yang Mungkin Muncul

### Jika ditanya: Kenapa memilih Flutter?

Jawaban:

"Karena Flutter memungkinkan satu project berjalan di web dan mobile. Jadi aplikasi ini fleksibel untuk demo di browser, emulator, atau smartphone."

### Jika ditanya: Kenapa memilih Supabase?

Jawaban:

"Karena Supabase sudah menyediakan auth, database PostgreSQL, storage, dan RPC. Dengan begitu kami tidak perlu membuat server manual dari awal."

### Jika ditanya: Apakah aplikasi ini sudah CRUD?

Jawaban:

"Sudah. CRUD tersedia pada software, kategori, dan vendor. Selain itu ada fitur favorit dan review."

### Jika ditanya: Apa peran login?

Jawaban:

"Login digunakan agar data dapat dikaitkan dengan user. Software memiliki pembuat, favorit terhubung dengan user, dan review juga menyimpan user yang memberi rating."

### Jika ditanya: Bagaimana deployment web?

Jawaban:

"Deployment menggunakan GitHub Actions. Saat kode di-push ke branch main, workflow menjalankan analyze, test, build web, lalu deploy ke GitHub Pages."

### Jika ditanya: Apa pengembangan berikutnya?

Jawaban:

"Pengembangan berikutnya adalah fitur pencarian, filter lanjutan, sorting, role admin, serta rekomendasi software berdasarkan rating dan kategori."

## Checklist Final Sebelum Presentasi

1. Akun demo sudah siap.
2. Password akun demo sudah dicatat.
3. Supabase URL dan key sudah benar.
4. Data software minimal 2 item.
5. Data kategori minimal 2 item.
6. Data vendor minimal 2 item.
7. Internet stabil.
8. Browser sudah dibuka.
9. Jika memakai smartphone, link aplikasi sudah disiapkan.
10. Jika memakai emulator, emulator sudah dinyalakan sebelum presentasi.
11. Anggota sudah tahu bagian bicara masing-masing.
12. Data demo yang akan dihapus sudah bukan data penting.
