import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_cart/app.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ShopVibeApp());
    expect(find.text('ShopVibe'), findsOneWidget);
  });
}
