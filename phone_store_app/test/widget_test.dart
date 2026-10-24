import 'package:flutter_test/flutter_test.dart';
import 'package:phone_store_app/main.dart';

void main() {
  testWidgets('Màn hình giới thiệu hiển thị tên cửa hàng', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Cửa hàng điện thoại'), findsOneWidget);
  });
}
