# Bài tập 03 – Ứng dụng mua bán điện thoại

Flutter + ASP.NET Core Web API (.NET 8) + SQL Server. Khách chọn điện thoại, thêm vào giỏ, thanh toán; mỗi lần thanh toán lưu một hóa đơn vào database.

| Thư mục | Nội dung |
| --- | --- |
| `PhoneStoreAPI/` | Web API .NET 8, Entity Framework Core. Script database ở `Database/PhoneStoreDB.sql` |
| `phone_store_app/` | App Flutter: giới thiệu, cửa hàng, Drawer, giỏ hàng, thanh toán |
| `TaiLieu/` | Tài liệu giải thích code (Word) |

Cách chạy: xem `HUONG_DAN_CHAY.txt`.

> `appsettings.json` để trống mật khẩu (`MATKHAU` / `NHAP_MAT_KHAU_SA`) – điền mật khẩu SQL Server của bạn khi chạy, không commit mật khẩu thật.
