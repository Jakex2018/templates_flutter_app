// ignore_for_file: unused_local_variable
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:templates_flutter_app/controllers/category_controller.dart';
import 'package:templates_flutter_app/providers/suscription_provider.dart';
import 'package:templates_flutter_app/views/category_app.dart';

import '../../mocks/category_app_test.mocks.dart';
import '../../mocks/setup_firebase_auth_mocks.dart.dart';

//@GenerateMocks([CategoryController, QuerySnapshot, DocumentSnapshot])
void main() {
  setupFirebaseAuthMocks();

  group('Category Widget Tests', () {
    late MockCategoryController mockCategoryController;
    late MockQuerySnapshot mockQuerySnapshot;
    late MockDocumentSnapshot mockDocumentSnapshot;

    setUp(() async {
      await Firebase.initializeApp();

      mockCategoryController = MockCategoryController();
      mockQuerySnapshot = MockQuerySnapshot();
      mockDocumentSnapshot = MockDocumentSnapshot();

      // Configura el mock para que devuelva un Stream
      when(mockCategoryController.getTemplatesByCategory('Test Category'))
          .thenAnswer((_) => Stream.value(mockQuerySnapshot));

      when(mockCategoryController.itemsPerPage).thenReturn(10);
      when(mockCategoryController.connectivityStream).thenAnswer(
          (_) => Stream.value(ConnectivityResult.wifi)); // Mock de conectividad
      when(mockCategoryController.currentPage).thenReturn(0);

      when(mockCategoryController.changePage(1)).thenAnswer((_) {});
    });

    tearDown(() {
      reset(mockCategoryController);
    });

    testWidgets('Category widget builds correctly', (WidgetTester tester) async {
      final suscriptionProvider = SuscriptionProvider();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<SuscriptionProvider>.value(
              value: suscriptionProvider,
            ),
            ChangeNotifierProvider<CategoryController>.value(
              value: mockCategoryController, // Inyecta el mock aquí
            ),
          ],
          child: MaterialApp(
            home: Category(
              category: 'Test Category',
              type: 'Free',
            ),
          ),
        ),
      );

      // Espera un poco más para asegurarte de que los streams tengan tiempo para emitirse
      await tester.pumpAndSettle(Duration(seconds: 20));

      // Verifica que se ha encontrado el texto correcto, esperado encontrarlo dos veces
      expect(find.text('Test Category'), findsNWidgets(1)); 

      // Verifica que se haya llamado al método getTemplatesByCategory
      verify(mockCategoryController.getTemplatesByCategory('Test Category'))
          .called(1);
    });
  });
}


/*
testWidgets('Category widget shows error on connectivity error',
        (WidgetTester tester) async {
      // Arrange: Mock the connectivityStream to emit an error
      when(mockCategoryController.connectivityStream)
          .thenAnswer((_) => Stream.error('Error de conectividad'));

      // Act: Wrap the Category widget with the required providers
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<SuscriptionProvider>(
              create: (_) => SuscriptionProvider(),
            ),
          ],
          child: MaterialApp(
            home: Category(
              category: 'Test Category',
              type: 'Free',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle(Duration(seconds: 20));

      // Assert: Verify that the error message is displayed
      expect(find.text('Error de conectividad'), findsOneWidget);
    });
    testWidgets('Category widget shows premium splash screen',
        (WidgetTester tester) async {
      final suscriptionProvider = SuscriptionProvider();

      // Act: Wrap the Category widget with the required providers
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<SuscriptionProvider>.value(
              value: suscriptionProvider,
            ),
          ],
          child: MaterialApp(
            home: Category(
              category: 'Test Category',
              type: 'Premium',
            ),
          ),
        ),
      );

      await tester.pumpAndSettle(Duration(seconds: 20));

      // Assert: Verify that the premium splash screen is displayed
      expect(find.text('Your Subscription has Expired'), findsOneWidget);
    });
 */



/*

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:templates_flutter_app/controllers/category_controller.dart';
import 'package:templates_flutter_app/providers/suscription_provider.dart';
import 'package:templates_flutter_app/views/category_app.dart';

import '../../mocks/category_app_test.mocks.dart';
import '../../mocks/setup_firebase_auth_mocks.dart.dart';

@GenerateMocks([CategoryController, QuerySnapshot, DocumentSnapshot])
void main() {
  setupFirebaseAuthMocks();

  group('Category Widget Tests', () {
    late MockCategoryController mockCategoryController;
    late MockQuerySnapshot mockQuerySnapshot;
    late MockDocumentSnapshot mockDocumentSnapshot;

    setUp(() async {
      await Firebase.initializeApp();

      mockCategoryController = MockCategoryController();
      mockQuerySnapshot = MockQuerySnapshot();
      mockDocumentSnapshot = MockDocumentSnapshot();

      when(mockCategoryController.getTemplatesByCategory('Test Category'))
          .thenAnswer((_) => Stream.value(mockQuerySnapshot));

      when(mockCategoryController.itemsPerPage).thenReturn(10);
      when(mockCategoryController.connectivityStream).thenAnswer(
          (_) => Stream.value(ConnectivityResult.wifi)); // Mock connectivity
      when(mockCategoryController.currentPage).thenReturn(0);

      when(mockCategoryController.changePage(1)).thenAnswer((_) {});
    });

    tearDown(() {
      reset(mockCategoryController);
    });

    testWidgets('Category widget builds correctly',
        (WidgetTester tester) async {
      final suscriptionProvider = SuscriptionProvider();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<SuscriptionProvider>.value(
              value: suscriptionProvider,
            ),
          ],
          child: MaterialApp(
            home: Category(
              category: 'Test Category',
              type: 'Free',
            ),
          ),
        ),
      );

      // Espera un poco más para asegurarte de que los streams tengan tiempo para emitirse
      await tester.pumpAndSettle(Duration(seconds: 20));

      expect(find.text('Test Category'),
          findsNWidgets(2)); // Espera encontrar exactamente dos widgets

      verify(mockCategoryController.getTemplatesByCategory('Test Category'))
          .called(1);
    });
    
  });
}

 */