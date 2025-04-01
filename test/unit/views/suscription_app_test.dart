import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:templates_flutter_app/providers/auth_user_provider.dart';
import 'package:templates_flutter_app/providers/suscription_provider.dart';
import 'package:templates_flutter_app/views/suscription_screen.dart';
import 'package:templates_flutter_app/widget/button01.dart';

import '../../mocks/home_app_test.mocks.dart';
import '../../mocks/setup_firebase_auth_mocks.dart.dart';

void main() {
  setupFirebaseAuthMocks();
  setUp(() async {
    await Firebase.initializeApp();
  });
  testWidgets('Subscription Screen displays correctly',
      (WidgetTester tester) async {
    // Crea un mock del AuthUserProvider
    final mockAuthUserProvider = MockAuthUserProvider();
    final mockSuscriptionProvider = MockSuscriptionProvider();

    // Define el comportamiento del mock
    when(mockAuthUserProvider.userId).thenReturn('user123');
    when(mockSuscriptionProvider.isSuscribed).thenReturn(true);

    // Crea el widget que vamos a probar
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthUserProvider>.value(
              value: mockAuthUserProvider),
          ChangeNotifierProvider<SuscriptionProvider>.value(
              value: mockSuscriptionProvider),
        ],
        child: MaterialApp(
          home: ChangeNotifierProvider.value(
            value: mockAuthUserProvider,
            child: SuscriptionScreen(),
          ),
        ),
      ),
    );

    // Verifica que el título se muestra correctamente
    expect(find.text('Choose a Subscription'), findsOneWidget);

    // Verifica que la tarjeta de suscripción está siendo renderizada
    expect(find.byType(ListView), findsOneWidget);

    // Verifica que los botones de las tarjetas de suscripción están visibles
    expect(find.byType(ButtonOne), findsWidgets);
  });
}
