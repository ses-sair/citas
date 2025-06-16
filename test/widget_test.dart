import 'package:flutter_test/flutter_test.dart';
import 'package:citas_app/main.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CitasApp());

    // Verify that the welcome screen appears
    expect(find.text('Citas App'), findsOneWidget);
  });
}
