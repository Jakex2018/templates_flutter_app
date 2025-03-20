import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:templates_flutter_app/providers/auth_user_provider.dart';
import 'package:templates_flutter_app/providers/suscription_provider.dart';
import 'package:templates_flutter_app/providers/theme_provider.dart';
import 'package:templates_flutter_app/views/home_app.dart';

import '../../mocks/setup_firebase_auth_mocks.dart.dart';

void main() {
  setupFirebaseAuthMocks();
  setUpAll(() async {
    await Firebase.initializeApp();
  });
  testWidgets('Home Widget initializes correctly', (WidgetTester tester) async {
    final themeProvider = ThemeProvider();
    final authProvider = AuthUserProvider();
    final suscriptionProvider = SuscriptionProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
          ChangeNotifierProvider<AuthUserProvider>.value(value: authProvider),
          ChangeNotifierProvider<SuscriptionProvider>.value(
              value: suscriptionProvider),
        ],
        child: MaterialApp(
          home: Home(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(Home), findsOneWidget);
  });
}
