import 'package:flutter/material.dart';

// Logo cửa hàng (vẽ bằng icon, không cần file ảnh)
class StoreLogo extends StatelessWidget {
  final double size;
  const StoreLogo({super.key, this.size = 120});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: const Color(0xFF1565C0), width: size * 0.04),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Center(
        child: Container(
          width: size * 0.62,
          height: size * 0.62,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF1565C0),
          ),
          child: Icon(Icons.phone_iphone, color: Colors.white, size: size * 0.36),
        ),
      ),
    );
  }
}
