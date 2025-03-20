import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:templates_flutter_app/providers/app_provider.dart';
import 'package:templates_flutter_app/providers/auth_user_provider.dart';
import 'package:templates_flutter_app/providers/suscription_provider.dart';

import '../../mocks/app_provider_test.mocks.dart';

///@GenerateMocks([AuthUserProvider, SuscriptionProvider])
void main() {
  group('AppProvider', () {
    test('allProviders should return a list of providers', () {
      // Act
      final providers = AppProvider.allProviders;

      // Assert
      expect(providers, isA<List<ChangeNotifierProvider<dynamic>>>());
      expect(providers.length, 6); // Verifica que hay 6 proveedores
    });

    testWidgets(
        'ChangeNotifierProxyProvider should update SuscriptionProvider correctly',
        (WidgetTester tester) async {
      // Arrange
      final mockAuthUserProvider = MockAuthUserProvider();
      final mockSuscriptionProvider = MockSuscriptionProvider();

      // Configura el comportamiento de los mocks
      when(mockAuthUserProvider.isLogged).thenReturn(true);
      when(mockAuthUserProvider.setLoggedIn(any)).thenAnswer((_) async {}); // Simula setLoggedIn
      when(mockSuscriptionProvider.loadSubscriptionState('userId'))
          .thenAnswer((_) async {}); // Simula loadSubscriptionState

      // Act
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            // Replica la estructura de proveedores de AppProvider
            ChangeNotifierProvider<AuthUserProvider>.value(
              value: mockAuthUserProvider,
            ),
            ChangeNotifierProxyProvider<AuthUserProvider, SuscriptionProvider>(
              create: (_) => mockSuscriptionProvider,
              update: (_, authProvider, subscriptionProvider) {
                subscriptionProvider?.loadSubscriptionState(
                    authProvider.isLogged ? 'userId' : '');
                return subscriptionProvider!;
              },
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  // Obtén los proveedores del contexto
                  final authProvider = Provider.of<AuthUserProvider>(context);

                  // Simula un cambio en el AuthUserProvider usando setLoggedIn
                  authProvider.setLoggedIn(true);

                  return Container();
                },
              ),
            ),
          ),
        ),
      );

      // Espera a que se completen las operaciones asíncronas
      await tester.pump();

      // Assert
      verify(mockSuscriptionProvider.loadSubscriptionState('userId')).called(1);
    });
  });
}