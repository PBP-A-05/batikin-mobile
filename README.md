
# Explore Batik & Javanese Culture at your phone with Batikin! 👘🕌

## Nama Anggota

- **Adelya Amanda** (2306165616)
- **Daanish Inayat Rahman** (2306213136)
- **Mirfak Naufal Pratama Putra** (2306244961)
- **Nawaetuna** (2306245762)
- **Nisrina Kamilya Nisyya** (2306275456)

---

## Filosofi Batikin: Menjembatani Pecinta Budaya dan Pendatang Baru

Batikin hadir untuk menghubungkan para pecinta budaya Jawa dan pendatang baru yang ingin mengenal keindahan batik serta produk budaya Jawa lainnya. Dengan nama yang terinspirasi dari "batik" dan "kain," aplikasi ini mencerminkan komitmen kami untuk memperkenalkan tekstil tradisional Indonesia kepada dunia.  

Kami percaya bahwa budaya bukan hanya untuk dikenang, tetapi juga untuk dilestarikan dan dihargai. Dengan Batikin, kami menghubungkan semua kalangan untuk menjelajahi, belajar, dan merasakan kekayaan budaya Indonesia, dimulai dari batik.

---

## Deskripsi Aplikasi

**Batikin** adalah sebuah aplikasi web yang membantu pengguna menemukan produk budaya Jawa di Yogyakarta, seperti batik, blangkon, dan keris. Selain itu, Batikin memudahkan pengguna untuk berpartisipasi dalam workshop batik dan mengeksplorasi budaya Jawa secara lebih mendalam.  

**Fitur utama aplikasi ini:**
- **Pencarian Produk:** Temukan beragam produk budaya sesuai keinginan.
- **Workshop Batik:** Pesan workshop membatik dengan ulasan dari peserta sebelumnya.
- **Eksplorasi Motif:** Pelajari beragam motif dan gaya batik serta produk budaya Jawa lainnya.
- **Lokasi Wisata Budaya:** Temukan kampung batik dan pusat produk budaya Jawa di Yogyakarta.

---

## Manfaat

1. **Penemuan Produk Budaya:** Mempermudah pengguna menemukan dan membeli produk batik serta perlengkapan budaya Jawa lainnya.
2. **Eksplorasi Budaya:** Menyediakan informasi mengenai motif, gaya batik, hingga workshop budaya.
3. **Fitur Berbasis Lokasi:** Memungkinkan pengguna menemukan tempat wisata budaya seperti kampung batik.
4. **Mendukung UMKM Lokal:** Membantu mempromosikan produk otentik Yogyakarta kepada lebih banyak orang.

---

## Daftar Modul

### 👨🏻‍💻 **User Profile & Authentication**  
_Dikerjakan oleh Daanish Inayat Rahman_  
- **Deskripsi:** Halaman yang menampilkan informasi pengguna dan fitur autentikasi (login, register).  
- **Fitur Utama:**  
  - Melihat dan mengedit profil pengguna.  
  - Menambah, mengubah, dan menghapus alamat pengiriman.  

### 🛒 **Shopping**  
_Dikerjakan oleh Adelya Amanda_  
- **Deskripsi:** Fitur belanja untuk membeli produk budaya Jawa.  
- **Fitur Utama:**  
  - Jelajahi berbagai produk budaya.  
  - Tambahkan produk ke keranjang belanja.  

### 💬 **Comment & Review**  
_Dikerjakan oleh Mirfak Naufal Pratama Putra_  
- **Deskripsi:** Fitur bagi pengguna untuk memberikan komentar dan ulasan pada produk.  
- **Fitur Utama:**  
  - Memberikan komentar.  
  - Memberikan skor ulasan.  

### ❤️ **Wishlist**  
_Dikerjakan oleh Nawaetuna_  
- **Deskripsi:** Fitur untuk menyimpan produk favorit ke dalam wishlist.  
- **Fitur Utama:**  
  - Tambahkan produk ke wishlist.  
  - Kelola wishlist pengguna.  

### 🧥 **Booking Workshop Batik**  
_Dikerjakan oleh Nisrina Kamilya Nisyya_  
- **Deskripsi:** Memesan workshop batik di kampung batik Yogyakarta.  
- **Fitur Utama:**  
  - Pesan workshop berdasarkan lokasi dan ulasan.  
  - Lihat jadwal workshop yang telah dipesan.  

---

## Role Pengguna

### 👤 **Guest**  
- Melihat daftar produk budaya.  
- Tidak dapat memberikan komentar, review, atau memasukkan produk ke wishlist.  

### 🔑 **Logged-in User**  
- Memiliki semua hak akses Guest.  
- Memberikan komentar dan ulasan.  
- Menambahkan produk ke wishlist.  
- Membeli produk dan memesan workshop.  

---

## Alur Pengintegrasian dengan Web Service  

### Langkah Integrasi
1. **Mendefinisikan Model:** Membuat model data yang akan dipakai untuk memanggil layanan web menggunakan metode `toJson()` dan `fromJson()`.  
2. **Menambahkan Dependensi:** Menambahkan pustaka seperti `axios` di aplikasi dan memastikan konektivitas HTTP diatur dalam konfigurasi proyek web.  
3. **Pemanggilan API:** Melakukan fetch data dari endpoint API menggunakan metode POST, GET, DELETE, PUT, atau lainnya yang disediakan layanan API. Dalam aplikasi berbasis Dart/Flutter, gunakan Future data type untuk menangani operasi asynchronous pada pemanggilan API.
4. **Dekode Data JSON:** Data yang diterima dari API didekode menjadi format JSON.  
5. **Konversi ke Model:** Data dalam JSON dikonversi ke model yang sesuai untuk aplikasi.  
6. **Menampilkan Data:** Data yang telah dikonversi menjadi model kemudian ditampilkan secara dinamis pada aplikasi. Dalam Dart/Flutter, data Future dapat ditampilkan menggunakan widget FutureBuilder untuk merender konten saat data berhasil dimuat.

Langkah-langkah ini memastikan aplikasi terintegrasi dengan API secara lancar dan memanfaatkan data eksternal untuk memperkaya pengalaman pengguna.

---

## Berita Acara
Laporan lengkap mengenai progress pengerjaan kelompok:  
[**Berita Acara PBP A.05**](https://docs.google.com/spreadsheets/d/1FHoXxDSGmiw7mO7gQiTH2vkq0Wm6oxjo/edit?gid=1741683645#gid=1741683645)  

## Deployment  

Tautan aplikasi akan diperbarui setelah rilis:  
[**Tautan Deployment Aplikasi Batikin**]
