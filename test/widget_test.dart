import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_uts_miftah/main.dart';
import 'package:flutter_uts_miftah/config/app_constants.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App smoke test - verifies branding and navigation destinations', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 2.0;

    await tester.pumpWidget(const MuncakGearApp());
    await tester.pump();

    // Verify application title in AppBar
    expect(find.text(AppConstants.appName), findsAtLeastNWidgets(1));

    // Verify navigation bar labels
    expect(find.text('Beranda'), findsOneWidget);
    expect(find.text('Katalog'), findsOneWidget);
    expect(find.text('Sewa Saya'), findsOneWidget);
    expect(find.text('Wishlist'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  });
}
