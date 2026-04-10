import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_price_compare/main.dart';

void main() {
  testWidgets('app renders home shell', (tester) async {
    await tester.pumpWidget(const GroceryPriceCompareRoot());

    expect(find.text('Shop smarter'), findsOneWidget);
    expect(find.text('Search'), findsOneWidget);
    expect(find.text('Cart'), findsOneWidget);
  });
}
