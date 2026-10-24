import 'package:flutter/material.dart';

import '../config.dart';
import '../models/dien_thoai.dart';
import '../services/api_service.dart';
import '../services/cart_service.dart';
import '../widgets/app_drawer.dart';

// Màn hình giỏ hàng
class CartScreen extends StatefulWidget {
  // true: mở từ Drawer (hiện nút ≡), false: mở từ icon giỏ hàng (hiện nút ←)
  final bool fromDrawer;
  const CartScreen({super.key, this.fromDrawer = false});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isPaying = false;

  // Xác nhận trước khi loại bỏ sản phẩm
  Future<void> _xacNhanXoa(int index) async {
    final dongY = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận'),
        content: const Text('Bạn muốn loại bỏ sản phẩm này ra khỏi giỏ hàng'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Không'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Đồng ý'),
          ),
        ],
      ),
    );
    if (dongY == true) {
      CartService.removeAt(index);
    }
  }

  // Thanh toán: gửi giỏ hàng lên API để lưu hóa đơn
  Future<void> _thanhToan() async {
    if (CartService.items.value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bạn chưa có sản phẩm nào trong giỏ hàng')),
      );
      return;
    }

    setState(() => _isPaying = true);
    try {
      final ketQua =
          await ApiService.thanhToan(CartService.items.value, tenNguoiDung);
      CartService.clear();
      if (!mounted) return;

      final tongTien = (ketQua['tongTien'] as num? ?? 0).toDouble();
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Thanh toán'),
          content: Text(
            'Bạn đã thanh toán xong giỏ hàng\n\n'
            'Mã hóa đơn: ${ketQua['maHD']}\n'
            'Tổng tiền: ${formatGia(tongTien)}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Đóng'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
        ),
      );
    } finally {
      if (mounted) setState(() => _isPaying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E0E0),
      drawer: widget.fromDrawer ? const AppDrawer(current: 'cart') : null,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFC107),
        foregroundColor: Colors.white,
        title: const Text('Giỏ hàng của bạn'),
      ),
      body: ValueListenableBuilder<List<DienThoai>>(
        valueListenable: CartService.items,
        builder: (context, items, _) {
          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text('Giỏ hàng của bạn',
                    style: TextStyle(fontSize: 13, color: Colors.black54)),
              ),
              Expanded(
                child: items.isEmpty
                    ? const Center(
                        child: Text(
                          'Bạn chưa bỏ sản phẩm nào vô giỏ hàng!!!',
                          style: TextStyle(color: Colors.black54),
                        ),
                      )
                    : ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final dt = items[index];
                          return ListTile(
                            title: Text(dt.tenDT),
                            subtitle: Text(formatGia(dt.gia)),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.black87),
                              tooltip: 'Loại bỏ',
                              onPressed: () => _xacNhanXoa(index),
                            ),
                          );
                        },
                      ),
              ),
              if (items.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tổng (${items.length} sản phẩm):',
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      Text(formatGia(CartService.tongTien),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent)),
                    ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: _isPaying ? null : _thanhToan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF00BFA5),
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                  ),
                  child: _isPaying
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Thanh toán'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
