-- =============================================================
--  BÀI TẬP 03 - CỬA HÀNG ĐIỆN THOẠI
--  Chạy file này trong SSMS (New Query -> Execute)
--  Tương thích SQL Server 2008 R2 trở lên và LocalDB
-- =============================================================
IF DB_ID(N'PhoneStoreDB') IS NULL
    CREATE DATABASE PhoneStoreDB;
GO
USE PhoneStoreDB;
GO

-- Xóa bảng cũ nếu chạy lại script (xóa bảng con trước)
IF OBJECT_ID(N'dbo.tblChiTietHoaDon', N'U') IS NOT NULL DROP TABLE dbo.tblChiTietHoaDon;
IF OBJECT_ID(N'dbo.tblHoaDon', N'U')        IS NOT NULL DROP TABLE dbo.tblHoaDon;
IF OBJECT_ID(N'dbo.tblDienThoai', N'U')     IS NOT NULL DROP TABLE dbo.tblDienThoai;
GO

-- Bảng điện thoại cửa hàng đang bán
CREATE TABLE dbo.tblDienThoai (
    MaDT    NVARCHAR(10)  NOT NULL CONSTRAINT PK_tblDienThoai PRIMARY KEY,
    TenDT   NVARCHAR(100) NOT NULL,
    MoTa    NVARCHAR(500) NULL,
    Gia     DECIMAL(18,0) NOT NULL CONSTRAINT CK_tblDienThoai_Gia CHECK (Gia >= 0),
    HinhAnh NVARCHAR(255) NULL       -- tên file ảnh trong wwwroot/images của API
);

-- Bảng hóa đơn (mỗi lần khách bấm Thanh toán = 1 hóa đơn)
CREATE TABLE dbo.tblHoaDon (
    MaHD         INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_tblHoaDon PRIMARY KEY,
    NgayLap      DATETIME      NOT NULL CONSTRAINT DF_tblHoaDon_NgayLap DEFAULT (GETDATE()),
    TenKhachHang NVARCHAR(100) NULL,
    TongTien     DECIMAL(18,0) NOT NULL
);

-- Bảng chi tiết hóa đơn (các điện thoại trong 1 hóa đơn)
CREATE TABLE dbo.tblChiTietHoaDon (
    MaHD    INT           NOT NULL,
    MaDT    NVARCHAR(10)  NOT NULL,
    SoLuong INT           NOT NULL CONSTRAINT CK_tblChiTietHoaDon_SoLuong CHECK (SoLuong > 0),
    DonGia  DECIMAL(18,0) NOT NULL,
    CONSTRAINT PK_tblChiTietHoaDon PRIMARY KEY (MaHD, MaDT),
    CONSTRAINT FK_tblChiTietHoaDon_tblHoaDon    FOREIGN KEY (MaHD) REFERENCES dbo.tblHoaDon(MaHD) ON DELETE CASCADE,
    CONSTRAINT FK_tblChiTietHoaDon_tblDienThoai FOREIGN KEY (MaDT) REFERENCES dbo.tblDienThoai(MaDT)
);
GO

-- Dữ liệu mẫu
INSERT INTO dbo.tblDienThoai (MaDT, TenDT, MoTa, Gia, HinhAnh) VALUES
 (N'DT01', N'iPhone Air', N'Màu Xanh Da Trời, khung titan siêu mỏng chỉ 5,64 mm. Màn hình OLED 6,5 inch, chip A19 Pro, camera Fusion 48MP, camera trước 18MP Center Stage, chỉ dùng eSIM.', 31990000, N'dt01.png'),
 (N'DT02', N'iPhone 16', N'Màu Xanh Lưu Ly. Màn hình Super Retina XDR 6,1 inch, chip A18, camera chính Fusion 48MP và camera góc siêu rộng 12MP, có nút Camera Control và nút Tác Vụ.', 19990000, N'dt02.png'),
 (N'DT03', N'iPhone 15 Pro Max', N'Màu Titan Đen, khung titan. Màn hình Super Retina XDR 6,7 inch, chip A17 Pro, camera chính 48MP kèm camera tele zoom quang học 5x, cổng USB-C chuẩn USB 3.', 27990000, N'dt03.png'),
 (N'DT04', N'iPhone X', N'Màu Xám Không Gian, khung thép không gỉ, mặt lưng kính. Màn hình OLED Super Retina 5,8 inch tràn viền, chip A11 Bionic, camera kép 12MP, mở khóa Face ID, sạc không dây.', 5990000, N'dt04.png'),
 (N'DT05', N'Samsung Galaxy A17 5G', N'Màu Xanh Navy. Màn hình Super AMOLED 6,7 inch 90Hz dạng giọt nước, chip Exynos 1330, 3 camera sau 50MP + 5MP + 2MP, camera trước 13MP, pin 5000 mAh.', 5490000, N'dt05.png'),
 (N'DT06', N'Samsung Galaxy Z Fold8 Ultra', N'Điện thoại gập màu trắng kem, tích hợp Galaxy AI. Màn hình chính 8,0 inch, màn hình phụ 6,5 inch, chip Snapdragon 8 Elite Gen 5, camera chính 200MP, pin 5000 mAh, sạc nhanh 45W, mở ra chỉ dày 4,1 mm.', 45990000, N'dt06.png'),
 (N'DT07', N'Samsung Galaxy A57 5G', N'Màu Awesome Navy. Màn hình Super AMOLED+ 6,7 inch 120Hz, chip Exynos 1680, 3 camera sau 50MP + 13MP + 5MP, camera trước 12MP, pin 5000 mAh sạc nhanh 45W, kháng nước IP68.', 10490000, N'dt07.png'),
 (N'DT08', N'Samsung Galaxy A36 5G', N'Màu Awesome Lavender. Màn hình Super AMOLED 6,7 inch, 3 camera sau với camera chính 50MP, pin 5000 mAh hỗ trợ sạc nhanh 45W, kháng nước kháng bụi IP67.', 8490000, N'dt08.png');
GO

-- Một vài hóa đơn mẫu để mục "Sản phẩm được lựa chọn nhiều nhất" có dữ liệu
INSERT INTO dbo.tblHoaDon (NgayLap, TenKhachHang, TongTien) VALUES (GETDATE(), N'Khách mẫu 1', 42480000);
INSERT INTO dbo.tblChiTietHoaDon (MaHD, MaDT, SoLuong, DonGia) VALUES
 (1, N'DT01', 1, 31990000),
 (1, N'DT07', 1, 10490000);

INSERT INTO dbo.tblHoaDon (NgayLap, TenKhachHang, TongTien) VALUES (GETDATE(), N'Khách mẫu 2', 91970000);
INSERT INTO dbo.tblChiTietHoaDon (MaHD, MaDT, SoLuong, DonGia) VALUES
 (2, N'DT01', 2, 31990000),
 (2, N'DT03', 1, 27990000);
GO

-- Kiểm tra
SELECT * FROM dbo.tblDienThoai;
SELECT * FROM dbo.tblHoaDon;
SELECT * FROM dbo.tblChiTietHoaDon;
