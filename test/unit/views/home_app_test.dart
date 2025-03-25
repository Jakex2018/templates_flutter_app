import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:templates_flutter_app/controllers/home_controller.dart';
import 'package:templates_flutter_app/providers/auth_user_provider.dart';
import 'package:templates_flutter_app/services/connectivity_services.dart';
import 'package:templates_flutter_app/views/home_app.dart';
import 'package:templates_flutter_app/widget/home_card.dart';

import '../../mocks/home_app_test.mocks.dart';
import '../../mocks/setup_firebase_auth_mocks.dart.dart';

void main() {
  setupFirebaseAuthMocks();
  setUp(() async {
    await Firebase.initializeApp();
  });
  testWidgets(
      'Home widget test displays correct username and handles connectivity',
      (WidgetTester tester) async {
    // Create mock instances
    final mockHomeController = MockHomeController();
    final mockAuthUserProvider = MockAuthUserProvider();
    final mockConnectivityService = MockConnectivityService();

    // Set up mock data
    when(mockAuthUserProvider.username)
        .thenReturn('test_user'); // Mock username
    when(mockHomeController.connectivityService)
        .thenReturn(mockConnectivityService);

    // Mock the connectivityStream to return a value (Simulating WiFi)
    when(mockConnectivityService.connectivityStream).thenAnswer((_) =>
        Stream.value(ConnectivityResult.wifi)); // Simulate WiFi connection

    // Build the widget tree for testing with the mocked providers
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<HomeController>.value(
              value: mockHomeController),
          ChangeNotifierProvider<AuthUserProvider>.value(
              value: mockAuthUserProvider),
        ],
        child: MaterialApp(
          home: Home(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify that the widget tree builds correctly
    expect(find.byType(Home), findsOneWidget);
    expect(find.text('Choose a Category'), findsOneWidget);

    // Verify that 'test_user' is displayed in the drawer as the username
    expect(find.text('test_user'),
        findsOneWidget); // Should find the 'test_user' text in the widget

    // Verify that the HomeCard widget is displayed
    expect(find.byType(HomeCard), findsOneWidget);

    // Optionally, verify that the connectivity stream works as expected
    // In this case, we are simulating a Wi-Fi connection, so the app should handle it correctly
    verify(mockConnectivityService.connectivityStream).called(1);
  });
}
/*
testWidgets('Home widget handles connectivity error',
      (WidgetTester tester) async {
    // Create mock instances
    final mockHomeController = MockHomeController();
    final mockAuthUserProvider = MockAuthUserProvider();
    final mockConnectivityService = MockConnectivityService();

    // Set up mock data
    when(mockAuthUserProvider.username)
        .thenReturn('test_user'); // Mock username
    when(mockHomeController.connectivityService)
        .thenReturn(mockConnectivityService);

    // Mock the connectivityStream to simulate an error (for example, no internet connection)
    when(mockConnectivityService.connectivityStream)
        .thenAnswer((_) => Stream.error(Exception('No internet')));

    // Build the widget tree for testing with the mocked providers
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<HomeController>.value(
              value: mockHomeController),
          ChangeNotifierProvider<AuthUserProvider>.value(
              value: mockAuthUserProvider),
        ],
        child: MaterialApp(
          home: Home(),
        ),
      ),
    );

    // Verify that the widget tree builds correctly
    expect(find.byType(Home), findsOneWidget);
    expect(find.text('Choose a Category'), findsOneWidget);

    // Verify that the error message is displayed when there's no connectivity
    expect(find.text('Error de conectividad'),
        findsOneWidget); // Error message should be shown

    // Verify that the username 'test_user' is displayed
    expect(find.text('test_user'),
        findsOneWidget); // Should find 'test_user' in the widget

    // Verify that the connectivity stream error was handled correctly
    verify(mockConnectivityService.connectivityStream).called(1);
  });
 */
/*
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

 */