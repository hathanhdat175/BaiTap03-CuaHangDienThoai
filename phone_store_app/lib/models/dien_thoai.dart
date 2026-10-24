import '../config.dart';

class DienThoai {
  final String maDT;
  final String tenDT;
  final String moTa;
  final double gia;
  final String hinhAnh;
  final int soLuongDaBan;

  DienThoai({
    required this.maDT,
    required this.tenDT,
    required this.moTa,
    required this.gia,
    required this.hinhAnh,
    this.soLuongDaBan = 0,
  });

  // JSON từ API: { "maDT", "tenDT", "moTa", "gia", "hinhAnh", "soLuongDaBan" }
  factory DienThoai.fromJson(Map<String, dynamic> json) {
    return DienThoai(
      maDT: json['maDT'] ?? '',
      tenDT: json['tenDT'] ?? '',
      moTa: json['moTa'] ?? '',
      gia: (json['gia'] as num? ?? 0).toDouble(),
      hinhAnh: json['hinhAnh'] ?? '',
      soLuongDaBan: (json['soLuongDaBan'] as num? ?? 0).toInt(),
    );
  }

  // Ảnh được API phục vụ trong thư mục wwwroot/images
  String get imageUrl => '$apiHost/images/$hinhAnh';
}

// Định dạng giá: 12000000 -> "12.000.000 đ"
String formatGia(double gia) {
  final s = gia.round().toString();
  final buf = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
    buf.write(s[i]);
  }
  return '$buf đ';
}
