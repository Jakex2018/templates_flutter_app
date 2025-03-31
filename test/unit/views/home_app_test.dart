import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:templates_flutter_app/controllers/home_controller.dart';
import 'package:templates_flutter_app/providers/auth_user_provider.dart';
import 'package:templates_flutter_app/providers/suscription_provider.dart';
import 'package:templates_flutter_app/services/provider_services.dart';
import 'package:templates_flutter_app/views/home_app.dart';
import 'package:templates_flutter_app/widget/home_card.dart';

import '../../mocks/home_app_test.mocks.dart';
import '../../mocks/setup_firebase_auth_mocks.dart.dart';

void main() {
  setupFirebaseAuthMocks();
  late MockHomeController mockHomeController;
  late MockAuthUserProvider mockAuthUserProvider;
  late MockProviderService mockProviderService;
  late MockSuscriptionProvider mockSuscriptionProvider;

  setUp(() async {
    await Firebase.initializeApp();
    mockHomeController = MockHomeController();
    mockAuthUserProvider = MockAuthUserProvider();
    mockProviderService = MockProviderService();
    mockSuscriptionProvider = MockSuscriptionProvider();

    when(mockHomeController.isLoading).thenReturn(true);
    when(mockAuthUserProvider.getUserId()).thenReturn('userId');
    when(mockAuthUserProvider.username).thenReturn("UsuarioPrueba");
    when(mockAuthUserProvider.isLogged).thenReturn(true);
    when(mockSuscriptionProvider.isSuscribed).thenReturn(true);

    when(mockHomeController.simulateLoading()).thenAnswer((_) async {
      await Future.delayed(Duration(seconds: 2));

      when(mockHomeController.isLoading).thenReturn(false);
    });
  });

  testWidgets(
      'Home widget shows loading indicator initially and content after loading',
      (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<HomeController>.value(
              value: mockHomeController),
          ChangeNotifierProvider<AuthUserProvider>.value(
              value: mockAuthUserProvider),
          Provider<ProviderService>.value(value: mockProviderService),
          ChangeNotifierProvider<SuscriptionProvider>.value(
              value: mockSuscriptionProvider),
        ],
        child: MaterialApp(
          home: Home(),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(seconds: 5));

    expect(find.byType(CircularProgressIndicator), findsNothing);

    expect(find.byType(HomeCard), findsOneWidget);
  });
}
