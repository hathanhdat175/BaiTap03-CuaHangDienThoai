import 'package:flutter/material.dart';
import '../models/dien_thoai.dart';

// Thẻ hiển thị 1 điện thoại: ảnh, tên, mô tả, giá, nút "+"
class ProductCard extends StatelessWidget {
  final DienThoai dienThoai;
  final VoidCallback onAdd;
  final String? badge; // vd: "Đã bán 3"

  const ProductCard({
    super.key,
    required this.dienThoai,
    required this.onAdd,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190,
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ảnh
          SizedBox(
            height: 140,
            width: double.infinity,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    dienThoai.imageUrl,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, progress) => progress == null
                        ? child
                        : const Center(
                            child: CircularProgressIndicator(strokeWidth: 2)),
                    errorBuilder: (context, error, stack) => const Icon(
                        Icons.smartphone,
                        size: 80,
                        color: Colors.grey),
                  ),
                ),
                if (badge != null)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(badge!,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 11)),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Tên
          Text(
            dienThoai.tenDT,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 6),
          // Mô tả
          Text(
            dienThoai.moTa,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
          const Spacer(),
          // Giá + nút thêm
          Row(
            children: [
              Expanded(
                child: Text(
                  formatGia(dienThoai.gia),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                width: 36,
                height: 36,
                child: ElevatedButton(
                  onPressed: onAdd,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: const Color(0xFF1DE9B6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Icon(Icons.add, size: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
