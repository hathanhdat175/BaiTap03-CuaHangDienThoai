import 'package:flutter/material.dart';

import '../config.dart';
import '../models/dien_thoai.dart';
import '../services/api_service.dart';
import '../services/cart_service.dart';
import '../widgets/app_drawer.dart';
import '../widgets/cart_icon_button.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';

// Màn hình cửa hàng: hiển thị điện thoại đang bán
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<DienThoai> _dienThoais = [];
  List<DienThoai> _banChay = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Xóa ảnh cũ trong bộ nhớ đệm để kéo xuống làm mới là tải lại ảnh mới từ API
    PaintingBinding.instance.imageCache.clear();
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final results = await Future.wait([
        ApiService.getDienThoai(),
        ApiService.getBanChay(),
      ]);
      if (!mounted) return;
      setState(() {
        _dienThoais = results[0];
        _banChay = results[1];
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = 'Không thể kết nối API.\nKiểm tra API đang chạy và địa chỉ $apiHost';
      });
    }
  }

  // Hộp thoại xác nhận khi chọn mua
  Future<void> _xacNhanThem(DienThoai dt) async {
    final dongY = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận'),
        content: Text('Bạn vừa thêm sản phẩm "${dt.tenDT}" vào Giỏ hàng'),
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
      CartService.add(dt);
      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Đã thêm ${dt.tenDT}. Giỏ hàng có ${CartService.soLuong} sản phẩm'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  Future<void> _moGioHang() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CartScreen()),
    );
    // Quay lại sau khi thanh toán -> tải lại "bán chạy"
    _loadData();
  }

  Widget _tieuDe(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      );

  Widget _danhSachNgang(List<DienThoai> list, {bool hienSoLuongBan = false}) {
    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final dt = list[index];
          return ProductCard(
            dienThoai: dt,
            badge: hienSoLuongBan ? 'Đã bán ${dt.soLuongDaBan}' : null,
            onAdd: () => _xacNhanThem(dt),
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off, size: 64, color: Colors.grey),
              const SizedBox(height: 12),
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadData,
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        children: [
          _tieuDe('Chọn sản phẩm bạn muốn sử dụng'),
          _dienThoais.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('Cửa hàng chưa có sản phẩm nào',
                      textAlign: TextAlign.center),
                )
              : _danhSachNgang(_dienThoais),
          _tieuDe('Sản phẩm được lựa chọn nhiều nhất'),
          _banChay.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('Chưa có hóa đơn nào',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey)),
                )
              : _danhSachNgang(_banChay, hienSoLuongBan: true),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E0E0),
      drawer: const AppDrawer(current: 'home'),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFC107),
        foregroundColor: Colors.white,
        title: const Text(tenCuaHang),
        actions: [CartIconButton(onPressed: _moGioHang)],
      ),
      body: _buildBody(),
    );
  }
}
