-- RESET DATABASE
-- ============================
DROP DATABASE IF EXISTS warung;
CREATE DATABASE warung;

USE warung;

-- TABEL PELANGGAN
-- ============================
CREATE TABLE Pelanggan (
                           Kode     VARCHAR(5) PRIMARY KEY,
                           Nama     VARCHAR(50),
                           Gender   VARCHAR(10),
                           Alamat   VARCHAR(100),
                           Kota     VARCHAR(50)
);

-- TABEL PRODUK
-- ============================
CREATE TABLE Produk (
                        Kode    VARCHAR(5) PRIMARY KEY,
                        Nama    VARCHAR(50),
                        Satuan  VARCHAR(20),
                        Stok    INT,
                        Harga   INT
);

-- TABEL PENJUALAN
-- ============================
CREATE TABLE Penjualan (
                           Tgl_Jual DATE,
                           No_Jual  VARCHAR(5),
                           KodePelanggan VARCHAR(5),
                           KodeProduk    VARCHAR(5),
                           Jumlah   INT,
                           FOREIGN KEY (KodePelanggan) REFERENCES Pelanggan(Kode),
                           FOREIGN KEY (KodeProduk) REFERENCES Produk(Kode)
);

-- INSERT DATA PELANGGAN
-- ============================
INSERT INTO Pelanggan (Kode, Nama, Gender, Alamat, Kota) VALUES
                                                             ('PLG01','Mohamad','Pria','Priok','Jakarta'),
                                                             ('PLG02','Naufal','Pria','Cilincing','Jakarta'),
                                                             ('PLG03','Atila','Pria','Bojongsong','Bandung'),
                                                             ('PLG04','Tsalsa','Wanita','Buah Batu','Bandung'),
                                                             ('PLG05','Damay','Wanita','Gubeng','Surabaya'),
                                                             ('PLG06','Tsaniy','Pria','Darmo','Surabaya'),
                                                             ('PLG07','Nabila','Wanita','Lebak Bulus','Jakarta');

-- INSERT DATA PRODUK
-- ============================
INSERT INTO Produk (Kode, Nama, Satuan, Stok, Harga) VALUES
                                                         ('P001','Indomie','Bungkus',10,3000),
                                                         ('P002','Roti','Pcs',3,18000),
                                                         ('P003','Kecap','Botol',8,4700),
                                                         ('P004','Saos Tomat','Botol',4,6000),
                                                         ('P005','Bihun','Bungkus',5,3500),
                                                         ('P006','Sikat Gigi','Pak',5,15000),
                                                         ('P007','Pasta Gigi','Pak',7,12000),
                                                         ('P008','Saos Sambal','Botol',5,7300);

-- INSERT DATA PENJUALAN
-- ============================
INSERT INTO Penjualan (Tgl_Jual, No_Jual, KodePelanggan, KodeProduk, Jumlah) VALUES
                                                                                 ('2025-09-08','J001','PLG03','P001',2),
                                                                                 ('2025-09-08','J001','PLG03','P003',1),
                                                                                 ('2025-09-08','J001','PLG03','P004',1),
                                                                                 ('2025-09-08','J002','PLG07','P006',3),
                                                                                 ('2025-09-08','J002','PLG07','P007',1),
                                                                                 ('2025-09-09','J003','PLG02','P001',5),
                                                                                 ('2025-09-09','J003','PLG02','P004',2),
                                                                                 ('2025-09-09','J003','PLG02','P008',2),
                                                                                 ('2025-09-09','J003','PLG02','P003',1),
                                                                                 ('2025-09-10','J004','PLG05','P002',3),
                                                                                 ('2025-09-10','J004','PLG05','P004',2),
                                                                                 ('2025-09-10','J004','PLG05','P008',2),
                                                                                 ('2025-09-10','J004','PLG05','P006',2),
                                                                                 ('2025-09-10','J004','PLG05','P007',1);

-- QUERY LAPORAN PENJUALAN
-- ============================
SELECT
    pj.Tgl_Jual,
    pj.No_Jual,
    pl.Nama AS Nama_Pelanggan,
    pr.Nama AS Nama_Produk,
    pj.Jumlah,
    pr.Harga,
    (pj.Jumlah * pr.Harga) AS Total
FROM Penjualan pj
         JOIN Pelanggan pl ON pj.KodePelanggan = pl.Kode
         JOIN Produk pr ON pj.KodeProduk = pr.Kode
ORDER BY pj.Tgl_Jual, pj.No_Jual;

-- PROCEDUR PENCARIAN PENJUALAN
-- ============================
DELIMITER //
CREATE PROCEDURE CariJumlahProduk(IN pKodeProduk VARCHAR(5))
BEGIN
SELECT
    pr.Nama AS Nama_Produk,
    SUM(pj.Jumlah) AS Total_Terjual
FROM Penjualan pj
         JOIN Produk pr ON pj.KodeProduk = pr.Kode
WHERE pj.KodeProduk = pKodeProduk
GROUP BY pr.Nama;

-- PROCEDURE CARI JUMLAH PRODUK
-- ============================
DELIMITER $$

CREATE PROCEDURE CariJumlahProduk(IN pKodeProduk VARCHAR(5))
BEGIN
SELECT
    pr.Nama AS Nama_Produk,
    SUM(pj.Jumlah) AS Total_Terjual
FROM Penjualan pj
         JOIN Produk pr ON pj.KodeProduk = pr.Kode
WHERE pj.KodeProduk = pKodeProduk
GROUP BY pr.Nama;
END $$

-- PROCEDURE CARI JUMLAH PELANGGAN
-- ============================
CREATE PROCEDURE CariJumlahPelanggan(IN pKodePelanggan VARCHAR(5))
BEGIN
SELECT
    pl.Nama AS Nama_Pelanggan,
    SUM(pj.Jumlah * pr.Harga) AS Total_Belanja
FROM Penjualan pj
         JOIN Pelanggan pl ON pj.KodePelanggan = pl.Kode
         JOIN Produk pr ON pj.KodeProduk = pr.Kode
WHERE pj.KodePelanggan = pKodePelanggan
GROUP BY pl.Nama;
END $$

DELIMITER ;

-- PEMANGGILAN PROCEDURE
-- ============================
-- Total belanja pelanggan "Naufal" (PLG02)
CALL CariJumlahPelanggan('PLG02');

