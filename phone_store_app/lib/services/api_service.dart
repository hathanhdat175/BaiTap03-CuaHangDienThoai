import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config.dart';
import '../models/dien_thoai.dart';

class ApiService {
  static const Duration _timeout = Duration(seconds: 15);

  // GET api/DienThoai -> danh sách điện thoại
  static Future<List<DienThoai>> getDienThoai() async {
    final response = await http
        .get(Uri.parse('$apiHost/api/DienThoai'))
        .timeout(_timeout);
    if (response.statusCode != 200) {
      throw Exception('Lỗi tải sản phẩm: ${response.statusCode}');
    }
    final data = jsonDecode(response.body) as List;
    return data.map((e) => DienThoai.fromJson(e)).toList();
  }

  // GET api/DienThoai/banchay -> sản phẩm được lựa chọn nhiều nhất
  static Future<List<DienThoai>> getBanChay({int top = 5}) async {
    final response = await http
        .get(Uri.parse('$apiHost/api/DienThoai/banchay?top=$top'))
        .timeout(_timeout);
    if (response.statusCode != 200) {
      throw Exception('Lỗi tải sản phẩm bán chạy: ${response.statusCode}');
    }
    final data = jsonDecode(response.body) as List;
    return data.map((e) => DienThoai.fromJson(e)).toList();
  }

  // POST api/HoaDon -> lưu hóa đơn khi thanh toán
  // Trả về: { "message", "maHD", "ngayLap", "tongTien" }
  static Future<Map<String, dynamic>> thanhToan(
      List<DienThoai> gioHang, String tenKhachHang) async {
    final body = {
      'tenKhachHang': tenKhachHang,
      'chiTiet': gioHang.map((dt) => {'maDT': dt.maDT, 'soLuong': 1}).toList(),
    };

    final response = await http
        .post(
          Uri.parse('$apiHost/api/HoaDon'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        )
        .timeout(_timeout);

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return data as Map<String, dynamic>;
    }
    final msg = (data is Map && data['message'] != null)
        ? data['message']
        : 'Lỗi thanh toán: ${response.statusCode}';
    throw Exception(msg);
  }
}
