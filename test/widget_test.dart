// test/widget_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:kelompokin/main.dart';

void main() {
  testWidgets('App renders LoginScreen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the title KelompokIn is rendered on Login screen.
    expect(find.text('KelompokIn'), findsOneWidget);
    expect(find.text('Masuk'), findsOneWidget);
    expect(find.text('Daftar'), findsOneWidget);
  });
}
