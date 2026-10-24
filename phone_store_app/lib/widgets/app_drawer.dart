import 'package:flutter/material.dart';

import '../config.dart';
import '../screens/cart_screen.dart';
import '../screens/home_screen.dart';
import '../screens/intro_screen.dart';
import 'store_logo.dart';

// Drawer gồm 3 mục: Cửa hàng, Giỏ hàng, Thoát
class AppDrawer extends StatelessWidget {
  // Trang hiện tại, để không mở lại chính nó
  final String current; // 'home' hoặc 'cart'
  const AppDrawer({super.key, required this.current});

  void _go(BuildContext context, String target) {
    Navigator.pop(context); // đóng drawer
    if (target == current) return;

    Widget page;
    switch (target) {
      case 'home':
        page = const HomeScreen();
        break;
      case 'cart':
        page = const CartScreen(fromDrawer: true);
        break;
      default:
        page = const IntroScreen();
    }

    // Xóa hết các trang cũ, mở trang mới làm trang gốc
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF2196F3),
      child: Column(
        children: [
          // Phần đầu: logo + tên + email
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(
                16, MediaQuery.of(context).padding.top + 16, 16, 16),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StoreLogo(size: 64),
                SizedBox(height: 12),
                Text(tenNguoiDung,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                SizedBox(height: 4),
                Text(emailNguoiDung,
                    style: TextStyle(fontSize: 13, color: Colors.black54)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.shopping_bag, color: Colors.black87),
            title: const Text('Cửa hàng'),
            selected: current == 'home',
            selectedColor: Colors.white,
            onTap: () => _go(context, 'home'),
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart, color: Colors.black87),
            title: const Text('Giỏ hàng'),
            selected: current == 'cart',
            selectedColor: Colors.white,
            onTap: () => _go(context, 'cart'),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.black87),
            title: const Text('Thoát'),
            onTap: () => _go(context, 'intro'),
          ),
        ],
      ),
    );
  }
}
