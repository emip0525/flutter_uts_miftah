import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_uts_miftah/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MuncakGearApp());
    expect(find.text('Selamat Datang di MuncakGear'), findsOneWidget);
  });
}
