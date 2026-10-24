-- =============================================================
--  Cập nhật tên / mô tả / giá cho khớp với 8 ảnh thật
--  Chạy trong SSMS trên database PhoneStoreDB (New Query -> Execute)
--  Tên file ảnh giữ nguyên dt01.png ... dt08.png nên KHÔNG cần sửa cột HinhAnh
--  Mô tả theo thông số chính thức của hãng; giá chỉ là giá mẫu cho bài tập
-- =============================================================
USE PhoneStoreDB;
GO

UPDATE dbo.tblDienThoai SET TenDT = N'iPhone Air',
    MoTa = N'Màu Xanh Da Trời, khung titan siêu mỏng chỉ 5,64 mm. Màn hình OLED 6,5 inch, chip A19 Pro, camera Fusion 48MP, camera trước 18MP Center Stage, chỉ dùng eSIM.',
    Gia = 31990000 WHERE MaDT = N'DT01';

UPDATE dbo.tblDienThoai SET TenDT = N'iPhone 16',
    MoTa = N'Màu Xanh Lưu Ly. Màn hình Super Retina XDR 6,1 inch, chip A18, camera chính Fusion 48MP và camera góc siêu rộng 12MP, có nút Camera Control và nút Tác Vụ.',
    Gia = 19990000 WHERE MaDT = N'DT02';

UPDATE dbo.tblDienThoai SET TenDT = N'iPhone 15 Pro Max',
    MoTa = N'Màu Titan Đen, khung titan. Màn hình Super Retina XDR 6,7 inch, chip A17 Pro, camera chính 48MP kèm camera tele zoom quang học 5x, cổng USB-C chuẩn USB 3.',
    Gia = 27990000 WHERE MaDT = N'DT03';

UPDATE dbo.tblDienThoai SET TenDT = N'iPhone X',
    MoTa = N'Màu Xám Không Gian, khung thép không gỉ, mặt lưng kính. Màn hình OLED Super Retina 5,8 inch tràn viền, chip A11 Bionic, camera kép 12MP, mở khóa Face ID, sạc không dây.',
    Gia = 5990000 WHERE MaDT = N'DT04';

UPDATE dbo.tblDienThoai SET TenDT = N'Samsung Galaxy A17 5G',
    MoTa = N'Màu Xanh Navy. Màn hình Super AMOLED 6,7 inch 90Hz dạng giọt nước, chip Exynos 1330, 3 camera sau 50MP + 5MP + 2MP, camera trước 13MP, pin 5000 mAh.',
    Gia = 5490000 WHERE MaDT = N'DT05';

UPDATE dbo.tblDienThoai SET TenDT = N'Samsung Galaxy Z Fold8 Ultra',
    MoTa = N'Điện thoại gập màu trắng kem, tích hợp Galaxy AI. Màn hình chính 8,0 inch, màn hình phụ 6,5 inch, chip Snapdragon 8 Elite Gen 5, camera chính 200MP, pin 5000 mAh, sạc nhanh 45W, mở ra chỉ dày 4,1 mm.',
    Gia = 45990000 WHERE MaDT = N'DT06';

UPDATE dbo.tblDienThoai SET TenDT = N'Samsung Galaxy A57 5G',
    MoTa = N'Màu Awesome Navy. Màn hình Super AMOLED+ 6,7 inch 120Hz, chip Exynos 1680, 3 camera sau 50MP + 13MP + 5MP, camera trước 12MP, pin 5000 mAh sạc nhanh 45W, kháng nước IP68.',
    Gia = 10490000 WHERE MaDT = N'DT07';

UPDATE dbo.tblDienThoai SET TenDT = N'Samsung Galaxy A36 5G',
    MoTa = N'Màu Awesome Lavender. Màn hình Super AMOLED 6,7 inch, 3 camera sau với camera chính 50MP, pin 5000 mAh hỗ trợ sạc nhanh 45W, kháng nước kháng bụi IP67.',
    Gia = 8490000 WHERE MaDT = N'DT08';
GO

SELECT MaDT, TenDT, MoTa, Gia, HinhAnh FROM dbo.tblDienThoai;
