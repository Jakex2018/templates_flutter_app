import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:templates_flutter_app/providers/suscription_provider.dart';
import 'package:templates_flutter_app/services/ad_services.dart';
import 'package:templates_flutter_app/views/template_app.dart';

import '../../mocks/setup_firebase_auth_mocks.dart.dart';
import '../../mocks/template_app_test.mocks.dart'; // Ajusta según tu ruta de archivo

void main() {
  setupFirebaseAuthMocks();
  late MockAdService mockAdService;
  late MockSuscriptionProvider mockSuscriptionProvider;
  late MockTemplateDataService mockTemplateDataService;

  setUp(() async {
    await Firebase.initializeApp();
    mockAdService = MockAdService();
    mockSuscriptionProvider = MockSuscriptionProvider();
    mockTemplateDataService = MockTemplateDataService();
  });

  testWidgets('Template displays CircularProgressIndicator while loading',
      (WidgetTester tester) async {
    // Arrange
    when(mockTemplateDataService.fetchNameTemplate('image_url'))
        .thenAnswer((_) async => 'Template Name');
    when(mockTemplateDataService.fetchUrlTemplate('image_url'))
        .thenAnswer((_) async => 'https://example.com');
    when(mockTemplateDataService.fetchGetNameImage('image_url'))
        .thenAnswer((_) async => 'image_name.jpg');

    // Act
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<AdService>.value(value: mockAdService),
          ChangeNotifierProvider<SuscriptionProvider>.value(
              value: mockSuscriptionProvider),
        ],
        child: MaterialApp(
          home: Template(image: 'image_url'),
        ),
      ),
    );

    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Template displays data after loading',
      (WidgetTester tester) async {
    // Arrange
    when(mockTemplateDataService.fetchNameTemplate('image_url'))
        .thenAnswer((_) async => 'Template Name');
    when(mockTemplateDataService.fetchUrlTemplate('image_url'))
        .thenAnswer((_) async => 'https://example.com');
    when(mockTemplateDataService.fetchGetNameImage('image_url'))
        .thenAnswer((_) async => 'image_name.jpg');

    // Act
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<AdService>.value(value: mockAdService),
          ChangeNotifierProvider<SuscriptionProvider>.value(
              value: mockSuscriptionProvider),
        ],
        child: MaterialApp(
          home: Template(image: 'image_url'),
        ),
      ),
    );

    // Simula la finalización de la carga
    await tester.pump(const Duration(seconds: 5));

    // Assert
    expect(find.text('Template'), findsOneWidget);
    expect(find.byType(CachedNetworkImage), findsOneWidget);
  });
}

/*
testWidgets('Template displays data after loading',
      (WidgetTester tester) async {
    // Arrange
    when(mockTemplateDataService.fetchNameTemplate('image_url'))
        .thenAnswer((_) async => 'Template Name');
    when(mockTemplateDataService.fetchUrlTemplate('image_url'))
        .thenAnswer((_) async => 'https://example.com');
    when(mockTemplateDataService.fetchGetNameImage('image_url'))
        .thenAnswer((_) async => 'image_name.jpg');

    // Act
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<AdService>.value(value: mockAdService),
          ChangeNotifierProvider<SuscriptionProvider>.value(
              value: mockSuscriptionProvider),
        ],
        child: MaterialApp(
          home: Template(image: 'image_url'),
        ),
      ),
    );

    // Simula la finalización de la carga
    await tester.pump(const Duration(seconds: 5));
 

    // Assert
    expect(find.text('Template'), findsOneWidget);
    expect(find.byType(CachedNetworkImage), findsOneWidget);
  });
 */






/*
void main() {
  group('Template Widget Test', () {
    late MockTemplateController mockTemplateController;
    late MockAdService mockAdService;
    late MockSuscriptionProvider mockSuscriptionProvider;
    late MockTemplateDataService mockTemplateDataService;

    setUp(() {
      // Inicializar mocks
      mockTemplateController = MockTemplateController();
      mockTemplateDataService = MockTemplateDataService();
      mockAdService = MockAdService();
      mockSuscriptionProvider = MockSuscriptionProvider();
    });

    testWidgets('Template widget shows image and name when data is loaded',
        (tester) async {
      // Simula datos para TemplateModel
      final templateModel = TemplateModel(
          name: 'Template Name',
          url: 'https://example.com',
          nameImage: 'image.jpg');

      // Configura los mocks para los métodos del TemplateDataService
      when(mockTemplateDataService
              .fetchNameTemplate('https://example.com/image.jpg'))
          .thenAnswer((_) async => 'Template Name');
      when(mockTemplateDataService
              .fetchUrlTemplate('https://example.com/image.jpg'))
          .thenAnswer((_) async => 'https://example.com');
      when(mockTemplateDataService
              .fetchGetNameImage('https://example.com/image.jpg'))
          .thenAnswer((_) async => 'image.jpg');

      // Configura el mock para el método getTemplateData
      when(mockTemplateController
              .getTemplateData('https://example.com/image.jpg'))
          .thenAnswer((_) async => templateModel);

      // Construir el widget
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: mockAdService,
            child: ChangeNotifierProvider.value(
              value: mockSuscriptionProvider,
              child: Builder(
                builder: (context) {
                  return Template(
                    image: 'https://example.com/image.jpg',
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Verificar si el CircularProgressIndicator se muestra mientras se carga la data
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Realiza el pump para esperar la carga de los datos
      await tester.pumpAndSettle(); // Espera a que el estado cambie

      // Verificar si el título y la imagen se muestran
      expect(find.text('Template Name'), findsOneWidget);
      expect(find.byType(CachedNetworkImage), findsOneWidget);
    });
  });
}

 */

/*
 testWidgets('Template widget shows progress indicator until data is loaded',
        (tester) async {
      // Configura el mock para simular que aún no se han cargado los datos
      when(mockTemplateController.getTemplateData('Template'))
          .thenAnswer((_) async {
        await Future.delayed(Duration(seconds: 1)); // Simula una carga tardada
        return TemplateModel(
            name: 'Template Name',
            url: 'https://example.com',
            nameImage: 'image.jpg');
      });

      // Construir el widget
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: mockAdService,
            child: ChangeNotifierProvider.value(
              value: mockSuscriptionProvider,
              child: Builder(
                builder: (context) {
                  return Template(
                    image: 'https://example.com/image.jpg',
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Verifica que el CircularProgressIndicator se muestra antes de que se carguen los datos
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Realiza un pump para esperar la carga de los datos
      await tester.pumpAndSettle(); // Espera a que el estado cambie

      // Verifica que la imagen y el nombre se muestran una vez que los datos se cargan
      expect(find.text('Template Name'), findsOneWidget);
      expect(find.byType(CachedNetworkImage), findsOneWidget);
    });
 */


/*
testWidgets('Template widget shows error icon if image fails to load', (tester) async {
      // Simula error en la carga de la imagen
      when(mockTemplateController.getTemplateData(any)).thenAnswer((_) async {
        return TemplateModel(name: 'Template Name', url: 'https://example.com', nameImage: 'image.jpg');
      });

      // Construir el widget
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: mockAdService,
            child: ChangeNotifierProvider.value(
              value: mockSuscriptionProvider,
              child: Builder(
                builder: (context) {
                  return Template(
                    image: 'https://example.com/invalid_image.jpg',
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Verifica si el CircularProgressIndicator se muestra inicialmente
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Realiza un pump para esperar la carga de los datos
      await tester.pumpAndSettle();

      // Verifica si el icono de error se muestra si la imagen no se carga correctamente
      expect(find.byIcon(Icons.error), findsOneWidget);
    });
 */












/*
// Genera los mocks usando build_runner
// Genera los mocks usando build_runner
@GenerateMocks([
  TemplateDataService,
  AdService,
  SuscriptionProvider,
  TemplateController,
  TemplateModel
])
void main() {
  setupFirebaseAuthMocks();
  late MockAdService mockAdService;
  late MockSuscriptionProvider mockSuscriptionProvider;
  late MockTemplateDataService mockTemplateDataService;
  late MockTemplateController mockTemplateController;

  setUp(() async {
    await Firebase.initializeApp();
    mockAdService = MockAdService();
    mockSuscriptionProvider = MockSuscriptionProvider();
    mockTemplateDataService = MockTemplateDataService();
    mockTemplateController = MockTemplateController();
  });

  testWidgets('Template displays CircularProgressIndicator while loading',
      (WidgetTester tester) async {
    // Arrange
    when(mockTemplateDataService.fetchNameTemplate('image_url'))
        .thenAnswer((_) async => 'Template Name');
    when(mockTemplateDataService.fetchUrlTemplate('image_url'))
        .thenAnswer((_) async => 'https://example.com');
    when(mockTemplateDataService.fetchGetNameImage('image_url'))
        .thenAnswer((_) async => 'image_name.jpg');

    // Act
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<AdService>.value(value: mockAdService),
          ChangeNotifierProvider<SuscriptionProvider>.value(
              value: mockSuscriptionProvider),
        ],
        child: MaterialApp(
          home: Template(image: 'image_url'),
        ),
      ),
    );

    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Template displays data after loading',
      (WidgetTester tester) async {
    // Arrange
    when(mockTemplateDataService.fetchNameTemplate('image_url'))
        .thenAnswer((_) async => 'Template Name');
    when(mockTemplateDataService.fetchUrlTemplate('image_url'))
        .thenAnswer((_) async => 'https://example.com');
    when(mockTemplateDataService.fetchGetNameImage('image_url'))
        .thenAnswer((_) async => 'image_name.jpg');

    final templateModel = TemplateModel(
        name: 'Template Name',
        url: 'https://example.com',
        nameImage: 'image_name.jpg');

    when(mockTemplateController.getTemplateData('image_url'))
        .thenAnswer((_) async => templateModel);

    // Act
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<AdService>.value(value: mockAdService),
          ChangeNotifierProvider<SuscriptionProvider>.value(
              value: mockSuscriptionProvider),
          Provider<TemplateDataService>.value(value: mockTemplateDataService),
          Provider<TemplateController>.value(value: mockTemplateController),
        ],
        child: MaterialApp(
          home: Template(image: 'image_url'),
        ),
      ),
    );

    await tester.pump(const Duration(seconds: 5));

    // Assert
    expect(find.text('Template'), findsOneWidget);
    expect(find.byType(CachedNetworkImage), findsOneWidget);
  });
}

*/

/*
testWidgets('Template displays data after loading',
      (WidgetTester tester) async {
    // Arrange
    when(mockTemplateDataService.fetchNameTemplate('image_url'))
        .thenAnswer((_) async => 'Template Name');
    when(mockTemplateDataService.fetchUrlTemplate('image_url'))
        .thenAnswer((_) async => 'https://example.com');
    when(mockTemplateDataService.fetchGetNameImage('image_url'))
        .thenAnswer((_) async => 'image_name.jpg');

    // Act
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<AdService>.value(value: mockAdService),
          Provider<SuscriptionProvider>.value(value: mockSuscriptionProvider),
        ],
        child: MaterialApp(
          home: Template(image: 'image_url'),
        ),
      ),
    );

    // Simula la finalización de la carga
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Template Name'), findsOneWidget);
    expect(find.byType(CachedNetworkImage), findsOneWidget);
  });
 */




/**
 void main() {
  setupFirebaseAuthMocks();
  late MockTemplateDataService mockDataService;
  late MockTemplateController mockController;
  late MockAdmobServices mockAdmobServices;

  // Inicializa Firebase antes de todas las pruebas
  setUpAll(() async {
    await Firebase.initializeApp();
    mockDataService = MockTemplateDataService();
    mockController = MockTemplateController();
    mockAdmobServices = MockAdmobServices();
    mockSubscriptionProvider = MockSuscriptionProvider();
  });

  // Pruebas unitarias
  group('Template Widget', () {
    // Crea instancias de los mocks

    // Configura los mocks de TemplateDataService
    when(mockDataService.fetchNameTemplate('image1')).thenAnswer((_) async {
      return 'Template Name';
    });
    when(mockDataService.fetchUrlTemplate('image1')).thenAnswer((_) async {
      return 'https://example.com';
    });
    when(mockDataService.fetchGetNameImage('image1')).thenAnswer((_) async {
      return 'image.jpg';
    });

    // Configura el mock de TemplateController para usar el mock de TemplateDataService
    when(mockController.getTemplateData('image1')).thenAnswer((_) async {
      return TemplateModel(
        name: 'Template Name',
        url: 'https://example.com',
        nameImage: 'image.jpg',
      );
    });

    // Configura el mock de SuscriptionProvider
    when(mockSubscriptionProvider.isSuscribed).thenReturn(false);

    // Configura el mock de AdmobServices
    when(mockAdmobServices.rewardsAdUid).thenReturn('test_ad_unit_id');

    testWidgets('renders loading indicator initially',
        (WidgetTester tester) async {
      print('Starting test...');

      // Cargar el widget que estamos probando
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<AdmobServices>.value(value: mockAdmobServices),
            ChangeNotifierProvider<SuscriptionProvider>.value(
              value: mockSubscriptionProvider,
            ),
          ],
          child: MaterialApp(
            home: Template(image: 'image1'),
          ),
        ),
      );

      // Comprobar que el CircularProgressIndicator se muestra inicialmente
      print('Widget rendered, looking for CircularProgressIndicator...');
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Espera a que el Future termine y el estado se actualice
      await tester.pump(Duration(seconds: 1)); // Simula un retraso
      await tester
          .pumpAndSettle(); // Espera que la animación o el estado finalicen

      // Verifica que el CircularProgressIndicator desaparezca
      print('Checking if CircularProgressIndicator is gone...');
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // Verifica que el mock de getTemplateData haya sido llamado una vez
      verify(mockController.getTemplateData('image1')).called(1);
    });
  });
}

 */



/*
 testWidgets('renders template data after loading',
        (WidgetTester tester) async {
      // Renderiza el widget
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<AdmobServices>.value(value: mockAdmobServices),
            Provider<SuscriptionProvider>.value(
                value: mockSubscriptionProvider),
          ],
          child: MaterialApp(
            home: Template(image: 'image1'),
          ),
        ),
      );

      // Espera a que se complete la carga
      await tester.pumpAndSettle();

      // Verifica que los datos del template se muestran correctamente
      expect(find.text('Template Name'), findsOneWidget);
      expect(find.byType(CachedNetworkImage), findsOneWidget);
      expect(find.text('Download Image'), findsOneWidget);
      expect(find.text('Source Code'), findsOneWidget);
      expect(find.text('Demo'), findsOneWidget);
    });

    testWidgets('calls downloadImage when Download Image button is pressed',
        (WidgetTester tester) async {
      // Renderiza el widget
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<AdmobServices>.value(value: mockAdmobServices),
            Provider<SuscriptionProvider>.value(
                value: mockSubscriptionProvider),
          ],
          child: MaterialApp(
            home: Template(image: 'image1'),
          ),
        ),
      );

      // Espera a que se complete la carga
      await tester.pumpAndSettle();

      // Simula el tap en el botón "Download Image"
      await tester.tap(find.text('Download Image'));
      await tester.pump();

      // Verifica que el método downloadImage fue llamado
      verify(mockController.downloadImage('image1')).called(1);
    });

    testWidgets('calls saveUrlTemplate when Source Code button is pressed',
        (WidgetTester tester) async {
      // Renderiza el widget
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<AdmobServices>.value(value: mockAdmobServices),
            Provider<SuscriptionProvider>.value(
                value: mockSubscriptionProvider),
          ],
          child: MaterialApp(
            home: Template(image: 'image1'),
          ),
        ),
      );

      // Espera a que se complete la carga
      await tester.pumpAndSettle();

      // Simula el tap en el botón "Source Code"
      await tester.tap(find.text('Source Code'));
      await tester.pump();

      // Verifica que el método saveUrlTemplate fue llamado
      verify(mockController.saveUrlTemplate('https://example.com')).called(1);
    });

    testWidgets('calls accessDemo when Demo button is pressed',
        (WidgetTester tester) async {
      // Configura el mock para devolver una URL de demo
      when(mockController.accessDemo('image1'))
          .thenAnswer((_) async => 'https://demo.com');

      // Renderiza el widget
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<AdmobServices>.value(value: mockAdmobServices),
            Provider<SuscriptionProvider>.value(
                value: mockSubscriptionProvider),
          ],
          child: MaterialApp(
            home: Template(image: 'image1'),
          ),
        ),
      );

      // Espera a que se complete la carga
      await tester.pumpAndSettle();

      // Simula el tap en el botón "Demo"
      await tester.tap(find.text('Demo'));
      await tester.pump();

      // Verifica que el método accessDemo fue llamado
      verify(mockController.accessDemo('image1')).called(1);
    });
 */
