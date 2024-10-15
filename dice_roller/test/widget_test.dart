import 'package:flutter_test/flutter_test.dart';
import 'package:dice_roller/main.dart'; // Adjust the import path as needed

void main() {
  testWidgets('App title test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DiceApp());

    // Verify that our app title is displayed.
    expect(find.text('Ludo Blitz'), findsOneWidget);
  });
}
