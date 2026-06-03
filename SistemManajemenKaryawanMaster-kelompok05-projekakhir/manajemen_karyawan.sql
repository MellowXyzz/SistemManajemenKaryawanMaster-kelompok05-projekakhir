CREATE DATABASE manajemen_karyawan;
USE manajemen_karyawan;

# I. TABEL MASTER

-- 1. Master Departemen
CREATE TABLE departemen (
id_departemen INT AUTO_INCREMENT PRIMARY KEY,
nama_departemen VARCHAR(50) NOT NULL,
lokasi_kerja VARCHAR(50) NOT NULL
);

-- 2. Master Jabatan
CREATE TABLE jabatan (
id_jabatan INT AUTO_INCREMENT PRIMARY KEY,
nama_jabatan VARCHAR(50) NOT NULL,
gaji_pokok DECIMAL(10,2) NOT NULL
);

-- 3. Master Proyek
CREATE TABLE proyek (
id_proyek INT AUTO_INCREMENT PRIMARY KEY,
nama_proyek VARCHAR(100) NOT NULL,
anggaran DECIMAL(15,2) NOT NULL,
tanggal_mulai DATE NOT NULL,
tanggal_selesai DATE NULL,
status_proyek ENUM('Perencanaan', 'Berjalan', 'Selesai') NOT NULL
);

-- 4. Master Tunjangan
CREATE TABLE aturan_kondisional (
id_aturan INT AUTO_INCREMENT PRIMARY KEY,
nama_kebijakan VARCHAR(50) NOT NULL,
jenis ENUM('Tunjangan', 'Potongan') NOT NULL,
nilai_nominal DECIMAL(10,2) NOT NULL,
keterangan TEXT
);

-- 5. Master Karyawan
CREATE TABLE karyawan (
id_karyawan INT AUTO_INCREMENT PRIMARY KEY,
nama_karyawan VARCHAR(100) NOT NULL,
jenis_kelamin ENUM('L','P') NOT NULL,
alamat VARCHAR(100),
no_telepon CHAR(12),
id_departemen INT,
id_jabatan INT,

FOREIGN KEY (id_departemen) REFERENCES departemen(id_departemen) ON DELETE RESTRICT,
FOREIGN KEY (id_jabatan) REFERENCES jabatan(id_jabatan) ON DELETE RESTRICT
);

# II. TABEL TRANSAKSI

-- 6. Transaksi Absensi
CREATE TABLE absensi (
id_absensi INT AUTO_INCREMENT PRIMARY KEY,
id_karyawan INT NOT NULL,
tanggal DATE NOT NULL,
jam_masuk TIME NULL,
jam_keluar TIME NULL,
STATUS ENUM('Hadir', 'Izin', 'Sakit', 'Alpha') NOT NULL,

FOREIGN KEY (id_karyawan) REFERENCES karyawan(id_karyawan) ON DELETE CASCADE
);

-- 7. Transaksi Penggajian
CREATE TABLE penggajian(
id_gaji INT AUTO_INCREMENT PRIMARY KEY,
id_karyawan INT NOT NULL,
id_aturan INT NOT NULL,
periode_bulan VARCHAR(20) NOT NULL, -- Format: "Mei 2026"
tunjangan_jabatan DECIMAL(10,2) DEFAULT 0.00,
potongan_absen DECIMAL(10,2) DEFAULT 0.00, -- Menampung kerugian finansial akibat Sakit/Izin/Alpha
gaji_bersih DECIMAL(10,2) NOT NULL, -- Formula: (Gaji Pokok + Tunjangan) - Potongan

FOREIGN KEY (id_karyawan) REFERENCES karyawan(id_karyawan) ON DELETE CASCADE,
FOREIGN KEY (id_aturan) REFERENCES aturan_kondisional(id_aturan) ON DELETE RESTRICT
);

-- 8. Transaksi Proyek Karyawan
CREATE TABLE proyek_karyawan (
id_proyek_karyawan INT AUTO_INCREMENT PRIMARY KEY,
id_karyawan INT NOT NULL,
id_proyek INT NOT NULL,
peran_proyek VARCHAR(50) NOT NULL,
tanggal_bergabung DATE NOT NULL,

FOREIGN KEY (id_karyawan) REFERENCES karyawan(id_karyawan) ON DELETE CASCADE,
FOREIGN KEY (id_proyek) REFERENCES proyek(id_proyek) ON DELETE CASCADE
);

# insert tabel master
-- tabel departemen
INSERT INTO departemen (nama_departemen, lokasi_kerja) VALUES
('HRD', 'Gedung A - Jakarta'),
('Keuangan', 'Gedung A - Jakarta'),
('IT Support', 'Gedung B - Bandung'),
('Pemasaran', 'Gedung A - Jakarta'),
('Operasional', 'Gedung C - Surabaya'),
('Produksi', 'Pabrik Sidoarjo'),
('Logistik', 'Gudang Bekasi'),
('Legal', 'Gedung A - Jakarta'),
('Customer Service', 'Gedung B - Bandung'),
('Riset & Desain', 'Gedung B - Bandung'),
('Quality Control', 'Pabrik Sidoarjo');

-- tabel jabatan
INSERT INTO jabatan (nama_jabatan, gaji_pokok) VALUES
('Direktur', 15000000),
('Manajer', 12000000),
('Supervisor', 9000000),
('Staff Senior', 8000000),
('Staff', 6000000),
('Admin', 5000000),
('Programmer', 8500000),
('System Analyst', 9500000),
('HR Officer', 6500000),
('Marketing Officer', 7000000),
('Operator Pabrik', 4800000);

-- tabel proyek
INSERT INTO proyek (nama_proyek, anggaran, tanggal_mulai, tanggal_selesai, status_proyek) VALUES
('Website Perusahaan', 50000000, '2026-01-10', '2026-04-10', 'Selesai'),
('Aplikasi Mobile V1', 80000000, '2026-01-15', '2026-06-15', 'Berjalan'),
('Sistem Absensi Biometrik', 30000000, '2026-02-01', '2026-05-01', 'Selesai'),
('ERP Internal Phase 1', 150000000, '2026-02-10', '2026-12-31', 'Berjalan'),
('Digital Marketing Campaign', 40000000, '2026-02-15', '2026-04-15', 'Selesai'),
('Renovasi Lab Produksi', 100000000, '2026-03-01', '2026-08-01', 'Berjalan'),
('Upgrade Server Cloud', 60000000, '2026-03-05', '2026-05-05', 'Selesai'),
('CRM System Deployment', 70000000, '2026-03-10', '2026-09-10', 'Berjalan'),
('Data Warehouse Big Data', 120000000, '2026-03-15', '2026-11-15', 'Berjalan'),
('AI Chatbot Customer Service', 90000000, '2026-04-01', '2026-10-01', 'Berjalan'),
('E-Commerce Integration', 85000000, '2026-04-05', '2026-08-05', 'Perencanaan');

-- tabel aturan_kondisional
INSERT INTO aturan_kondisional (nama_kebijakan, jenis, nilai_nominal, keterangan) VALUES
('Uang Makan Harian', 'Tunjangan', 25000, 'Diberikan per hari hadir'),
('Tunjangan Transport', 'Tunjangan', 30000, 'Diberikan per hari hadir'),
('Potongan Alpha', 'Potongan', 200000, 'Potongan per hari jika tidak hadir tanpa keterangan'),
('Potongan Izin', 'Potongan', 50000, 'Potongan tunjangan harian jika izin'),
('Potongan Sakit', 'Potongan', 0, 'Sakit dengan surat dokter tidak dipotong gaji pokok'),
('Insentif Lembur per Jam', 'Tunjangan', 50000, 'Dihitung dari kelebihan jam kerja harian'),
('BPJS Kesehatan', 'Potongan', 150000, 'Potongan wajib bulanan flat'),
('BPJS Ketenagakerjaan', 'Potongan', 200000, 'Potongan wajib bulanan flat'),
('Bonus Proyek Selesai', 'Tunjangan', 1000000, 'Bonus performa penyelesaian proyek'),
('Tunjangan Pulsa Komunikasi', 'Tunjangan', 100000, 'Khusus divisi marketing dan IT external'),
('Potongan Keterlambatan', 'Potongan', 25000, 'Terlambat masuk di atas 15 menit');

-- tabel karyawan
INSERT INTO karyawan (nama_karyawan, jenis_kelamin, alamat, no_telepon, id_departemen, id_jabatan) VALUES
('Andi Pratama', 'L', 'Jakarta', '081111111111', 1, 5),
('Budi Santoso', 'L', 'Jakarta', '081111111112', 2, 2),
('Citra Lestari', 'P', 'Bandung', '081111111113', 3, 7),
('Dewi Anggraini', 'P', 'Jakarta', '081111111114', 4, 10),
('Eko Saputra', 'L', 'Surabaya', '081111111115', 5, 3),
('Fajar Nugroho', 'L', 'Sidoarjo', '081111111116', 6, 11),
('Gina Putri', 'P', 'Bekasi', '081111111117', 7, 6),
('Hendra Wijaya', 'L', 'Jakarta', '081111111118', 8, 4),
('Intan Sari', 'P', 'Bandung', '081111111119', 9, 6),
('Joko Susilo', 'L', 'Bandung', '081111111120', 10, 8),
('Kartika Dewi', 'P', 'Sidoarjo', '081111111121', 11, 4);

# insert tabel transaksi
-- tabel absensi
INSERT INTO absensi (id_karyawan, tanggal, jam_masuk, jam_keluar, STATUS) VALUES
(1, '2026-05-01', '08:00:00', '17:00:00', 'Hadir'),
(2, '2026-05-01', '07:55:00', '17:00:00', 'Hadir'),
(3, '2026-05-01', NULL, NULL, 'Izin'), -- Izin: Jam kosong, gaji dipotong sebagian
(4, '2026-05-01', '08:10:00', '17:00:00', 'Hadir'),
(5, '2026-05-01', NULL, NULL, 'Sakit'), -- Sakit: Gaji pokok aman
(6, '2026-05-01', '07:45:00', '17:00:00', 'Hadir'),
(7, '2026-05-01', NULL, NULL, 'Alpha'), -- Alpha: Potongan berat
(8, '2026-05-01', '08:00:00', '17:00:00', 'Hadir'),
(9, '2026-05-01', '08:02:00', '17:00:00', 'Hadir'),
(10, '2026-05-01', NULL, NULL, 'Izin'),
(11, '2026-05-01', '07:50:00', '17:00:00', 'Hadir'),
(1, '2026-05-02', '08:00:00', '17:00:00', 'Hadir'),
(2, '2026-05-02', '08:00:00', '17:00:00', 'Hadir'),
(3, '2026-05-02', '08:15:00', '17:00:00', 'Hadir'),
(4, '2026-05-02', NULL, NULL, 'Alpha'),
(5, '2026-05-02', '08:00:00', '17:00:00', 'Hadir'),
(6, '2026-05-02', '07:50:00', '17:00:00', 'Hadir'),
(7, '2026-05-02', '08:00:00', '17:00:00', 'Hadir'),
(8, '2026-05-02', NULL, NULL, 'Sakit'),
(9, '2026-05-02', '08:05:00', '17:00:00', 'Hadir');

-- Tabel penggajian
INSERT INTO penggajian (id_karyawan, id_aturan, periode_bulan, tunjangan_jabatan, potongan_absen, gaji_bersih) VALUES
(1, 1, 'Mei 2026', 500000, 0, 6500000),
(2, 2, 'Mei 2026', 1500000, 0, 13500000),
(3, 3, 'Mei 2026', 750000, 50000, 9200000), -- Terpotong karena Izin
(4, 4, 'Mei 2026', 600000, 200000, 7400000), -- Terpotong karena Alpha
(5, 5, 'Mei 2026', 1000000, 0, 10000000), -- Sakit, tidak ada potongan gaji pokok
(6, 6, 'Mei 2026', 400000, 0, 5200000),
(7, 7, 'Mei 2026', 300000, 200000, 5100000), -- Terpotong karena Alpha
(8, 8, 'Mei 2026', 800000, 0, 8800000),
(9, 9, 'Mei 2026', 300000, 0, 5300000),
(10, 1, 'Mei 2026', 900000, 50000, 10350000), -- Terpotong karena Izin
(11, 2, 'Mei 2026', 800000, 0, 8800000),
(1, 9, 'Juni 2026', 500000, 0, 6500000),
(2, 8,'Juni 2026', 1500000, 0, 13500000),
(3, 7, 'Juni 2026', 750000, 0, 9250000),
(4, 6, 'Juni 2026', 600000, 0, 7600000),
(5, 5, 'Juni 2026', 1000000, 0, 10000000),
(6, 4, 'Juni 2026', 400000, 0, 5200000),
(7, 3, 'Juni 2026', 300000, 0, 5300000),
(8, 2, 'Juni 2026', 800000, 0, 8800000),
(9, 1, 'Juni 2026', 300000, 0, 5300000);

INSERT INTO proyek_karyawan (id_karyawan, id_proyek, peran_proyek, tanggal_bergabung) VALUES
(3, 1, 'UI/UX Designer', '2026-01-10'),
(7, 1, 'QA Tester', '2026-01-15'),
(3, 2, 'Lead Mobile Dev', '2026-01-15'),
(10, 2, 'System Analyst', '2026-01-20'),
(11, 3, 'Project Owner', '2026-02-01'),
(1, 4, 'Business Analyst', '2026-02-10'),
(8, 4, 'Legal Advisor', '2026-02-10'),
(4, 5, 'Marketing Spec', '2026-02-15'),
(5, 6, 'Site Manager', '2026-03-01'),
(6, 6, 'Supervisor Field', '2026-03-01'),
(3, 7, 'DevOps Engineer', '2026-03-05'),
(10, 8, 'Solution Architect', '2026-03-10'),
(4, 8, 'CRM Consultant', '2026-03-12'),
(10, 9, 'Data Engineer', '2026-03-15'),
(3, 10, 'AI Specialist', '2026-04-01'),
(9, 10, 'Support Admin', '2026-04-01'),
(1, 2, 'Project Coordinator', '2026-02-01'),
(2, 4, 'Financial Auditor', '2026-02-15'),
(5, 3, 'Technical Support', '2026-02-05'),
(11, 6, 'Quality Auditor', '2026-03-10');

# DML

-- Kasus 1: Mengubah data alamat dan nomor telepon karyawan tertentu
UPDATE karyawan SET alamat = 'Bandung Barat', no_telepon = '081222222222'
WHERE id_karyawan = 3;

-- Kasus 2: Menaikkan anggaran proyek yang berstatus 'Berjalan' sebesar 10%
UPDATE proyek SET anggaran = anggaran * 1.10
WHERE status_proyek = 'Berjalan';

-- kasus 3: Menghapus riwayat absensi tertentu yang salah input
DELETE FROM absensi WHERE id_absensi = 7;

-- kasus 4: Menghapus data karyawan yang mengundurkan diri
DELETE FROM karyawan WHERE id_karyawan = 4;

# Query SELECT (Single Table)

-- kasus 5: Menampilkan daftar jabatan yang memiliki gaji pokok di atas Rp 7.000.000, diurutkan dari yang terbesar
SELECT nama_jabatan, gaji_pokok
FROM jabatan
WHERE gaji_pokok > 7000000
ORDER BY gaji_pokok DESC;

-- kasus 6: Menghitung total anggaran yang dikeluarkan perusahaan untuk semua proyek yang sudah 'Selesai'
SELECT SUM(anggaran) AS total_anggaran_selesai
FROM proyek
WHERE status_proyek = 'Selesai';

-- kasus 7: Mengetahui jumlah karyawan berdasarkan jenis kelaminnya
SELECT jenis_kelamin, COUNT(*) AS jumlah_karyawan
FROM karyawan
GROUP BY jenis_kelamin;

# Join Antar Tabel (Multi Table)

-- kasus 8: Menampilkan nama karyawan, nama departemennya, dan nama jabatannya (Hubungan 3 Tabel Master)
SELECT
k.id_karyawan,
k.nama_karyawan,
d.nama_departemen,
j.nama_jabatan
FROM karyawan k
JOIN departemen d ON k.id_departemen = d.id_departemen
JOIN jabatan j ON k.id_jabatan = j.id_jabatan;

-- kasus 9: Laporan absensi harian yang menampilkan nama karyawan dan departemennya (Hubungan Tabel Transaksi ke Master)
SELECT
a.tanggal,
k.nama_karyawan,
d.nama_departemen,
a.status AS status_kehadiran
FROM absensi a
JOIN karyawan k ON a.id_karyawan = k.id_karyawan
JOIN departemen d ON k.id_departemen = d.id_departemen
ORDER BY a.tanggal DESC, k.nama_karyawan ASC;

# Subquery

-- kasus 10: Manampilkan Menampilkan data karyawan yang mendapatkan gaji bersih tertinggi di bulan Mei 2026 (Subquery di klausul WHERE)
SELECT id_karyawan, periode_bulan, gaji_bersih
FROM penggajian
WHERE periode_bulan = 'Mei 2026'
AND gaji_bersih = (SELECT MAX(gaji_bersih) FROM penggajian WHERE periode_bulan = 'Mei 2026');

-- Kasus 11: Menampilkan daftar karyawan yang tidak terdaftar di proyek mana pun saat ini
SELECT id_karyawan, nama_karyawan
FROM karyawan
WHERE id_karyawan NOT IN (SELECT DISTINCT id_karyawan FROM proyek_karyawan);

-- Kasus 3: Menampilkan nama jabatan beserta gaji pokoknya, khusus untuk jabatan yang nilai gajinya di atas rata-rata gaji pokok seluruh jabatan di perusahaan
SELECT nama_jabatan, gaji_pokok
FROM jabatan
WHERE gaji_pokok > (SELECT AVG(gaji_pokok) FROM jabatan);

# View Profil Karyawan
CREATE VIEW v_profil_karyawan AS
SELECT
k.id_karyawan,
k.nama_karyawan,
k.jenis_kelamin,
k.no_telepon,
d.nama_departemen,
d.lokasi_kerja,
j.nama_jabatan,
j.gaji_pokok
FROM karyawan k
JOIN departemen d ON k.id_departemen = d.id_departemen
JOIN jabatan j ON k.id_jabatan = j.id_jabatan;

# View Rekap Slip Gaji & Kebijakan
CREATE OR REPLACE VIEW v_rekap_penggajian AS
SELECT
g.id_gaji,
g.periode_bulan,
k.nama_karyawan,
j.nama_jabatan,
j.gaji_pokok,
g.tunjangan_jabatan,
g.potongan_absen,
ag.nama_kebijakan AS kebijakan_terkait,
ag.jenis AS jenis_kebijakan,
g.gaji_bersih
FROM penggajian g
JOIN karyawan k ON g.id_karyawan = k.id_karyawan
JOIN jabatan j ON k.id_jabatan = j.id_jabatan
JOIN aturan_gaji ag ON g.id_aturan = ag.id_aturan;

# View Alokasi Tim & Peran Proyek
CREATE VIEW v_alokasi_proyek AS
SELECT
p.nama_proyek,
p.anggaran,
p.status_proyek,
k.nama_karyawan,
d.nama_departemen,
pk.peran_proyek,
pk.tanggal_bergabung
FROM proyek_karyawan pk
JOIN karyawan k ON pk.id_karyawan = k.id_karyawan
JOIN departemen d ON k.id_departemen = d.id_departemen
JOIN proyek p ON pk.id_proyek = p.id_proyek;