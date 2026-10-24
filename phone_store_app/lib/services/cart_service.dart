import 'package:flutter/foundation.dart';
import '../models/dien_thoai.dart';

// Giỏ hàng dùng chung cho toàn app.
// ValueNotifier giúp các màn hình (biểu tượng giỏ hàng, trang giỏ hàng)
// tự cập nhật khi giỏ hàng thay đổi.
class CartService {
  CartService._();

  static final ValueNotifier<List<DienThoai>> items =
      ValueNotifier<List<DienThoai>>([]);

  static void add(DienThoai dt) {
    items.value = [...items.value, dt];
  }

  static void removeAt(int index) {
    final list = [...items.value];
    list.removeAt(index);
    items.value = list;
  }

  static void clear() {
    items.value = [];
  }

  static double get tongTien =>
      items.value.fold(0, (sum, dt) => sum + dt.gia);

  static int get soLuong => items.value.length;
}
