# Membuat Trigger 1 untuk mengisi pembayaran
DELIMITER $$
CREATE TRIGGER isi_pembayaran BEFORE INSERT ON pesanan
FOR EACH ROW
BEGIN
    INSERT INTO pembayaran (nokuitansi, tanggal, jumlah, ke, status_pembayaran, cash, pesanan_id)
    VALUES (CONCAT('K-', NEW.id), NOW(), NEW.total, 1, 'belum_lunas', 0, NEW.id);
END $$
DELIMITER ;

# Membuat Trigger 2 untuk mengubah status pembayaran
DELIMITER $$
CREATE TRIGGER ubah_status_pembayaran BEFORE UPDATE ON pembayaran
FOR EACH ROW
BEGIN
    IF NEW.cash > 0 AND NEW.status_pembayaran = 'belum_lunas' THEN
        SET NEW.status_pembayaran = 'lunas';
    END IF;
END $$
DELIMITER ;

# Untuk menguji trigger pertama, lakukan perintah INSERT pada tabel pesanan
INSERT INTO pesanan (tanggal, total, pelanggan_id)
VALUES 
(NOW(), 100000, 1);

# Memeriksa Tabel pesanan, apakah data sudah masuk
SELECT * FROM pesanan;

# Memeriksa Tabel Pembayaran , mengecek apakah status_pembayaran dengan keterangan 'belum_lunas'
SELECT * FROM pembayaran;

# Untuk menguji trigger kedua, lakukan perintah UPDATE pada tabel pembayaran dengan nilai kolom cash yang sama dengan nilai kolom jumlah
UPDATE pembayaran SET cash = 100000 WHERE id = 1;

# Periksa kembali tabel pembayaran, apakah status_pembayaran sudah berubah dengan keterangan 'lunas'
SELECT * FROM pembayaran;
