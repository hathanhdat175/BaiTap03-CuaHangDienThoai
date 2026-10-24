import 'package:flutter/material.dart';
import '../models/dien_thoai.dart';
import '../services/cart_service.dart';

// Biểu tượng giỏ hàng trên AppBar, có số lượng sản phẩm
class CartIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  const CartIconButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<DienThoai>>(
      valueListenable: CartService.items,
      builder: (context, items, _) {
        return IconButton(
          tooltip: 'Giỏ hàng',
          onPressed: onPressed,
          icon: Badge(
            isLabelVisible: items.isNotEmpty,
            label: Text('${items.length}'),
            child: const Icon(Icons.shopping_cart),
          ),
        );
      },
    );
  }
}
