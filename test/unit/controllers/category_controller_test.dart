import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:templates_flutter_app/controllers/category_controller.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../mocks/category_controller_test.mocks.dart';

/*
@GenerateMocks(
    [TemplateDataService, ConnectivityService, DocumentSnapshot, QuerySnapshot])
 */
void main() {
  late CategoryController categoryController;
  late MockTemplateDataService mockTemplateDataService;
  late MockConnectivityService mockConnectivityService;

  setUp(() {
    mockTemplateDataService = MockTemplateDataService();
    mockConnectivityService = MockConnectivityService();
    categoryController = CategoryController(
      templateService: mockTemplateDataService,
      connectivityService: mockConnectivityService,
    );
  });

  group('CategoryController Tests', () {
    test('initializeStreams sets up streams correctly', () async {
      // Mock de los streams
      final mockTemplatesStream =
          Stream<QuerySnapshot<Map<String, dynamic>>>.empty();
      final mockConnectivityStream =
          Stream<ConnectivityResult>.value(ConnectivityResult.none);

      // Usar thenAnswer en lugar de thenReturn
      when(mockTemplateDataService.getTemplatesByCategory(any))
          .thenAnswer((_) => mockTemplatesStream);
      when(mockConnectivityService.connectivityStream)
          .thenAnswer((_) => mockConnectivityStream);

      // Llamar a initializeStreams
      categoryController.initializeStreams('category_name');

      // Verificar que los streams se han configurado correctamente
      expect(categoryController.templatesStream, mockTemplatesStream);
      expect(categoryController.connectivityStream, mockConnectivityStream);
    });
    test('combinedStream emits values correctly', () async {
      // Mock empty QuerySnapshot<Map<String, dynamic>>
      final mockQuerySnapshot = MockQuerySnapshot<Map<String, dynamic>>();

      // Mock docs to return an empty list
      when(mockQuerySnapshot.docs).thenReturn([]);

      // Create a stream that emits the mock QuerySnapshot
      final mockTemplatesStream =
          Stream<QuerySnapshot<Map<String, dynamic>>>.value(mockQuerySnapshot);
      final mockConnectivityStream =
          Stream<ConnectivityResult>.value(ConnectivityResult.wifi);

      when(mockTemplateDataService.getTemplatesByCategory(any))
          .thenAnswer((_) => mockTemplatesStream);
      when(mockConnectivityService.connectivityStream)
          .thenAnswer((_) => mockConnectivityStream);

      // Mock the template service and connectivity service
      when(mockTemplateDataService.getTemplatesByCategory(any))
          .thenAnswer((_) => mockTemplatesStream);

      when(mockConnectivityService.connectivityStream)
          .thenAnswer((_) => mockConnectivityStream);

      // Initialize the streams in the category controller
      categoryController.initializeStreams('category_name');

      // Verify that combinedStream emits the correct values
      final combinedStream = categoryController.combinedStream;
      expectLater(
          combinedStream,
          emitsInOrder([
            {'connectivity': ConnectivityResult.wifi},
            {
              'templates': mockQuerySnapshot
            }, // Check for the mock query snapshot
          ]));
    });
    test('combinedStream emits values correctly', () async {
      // Mock empty QuerySnapshot<Map<String, dynamic>>
      final mockQuerySnapshot = MockQuerySnapshot<Map<String, dynamic>>();

      // Mock docs to return an empty list
      when(mockQuerySnapshot.docs).thenReturn([]);

      // Mock the connectivity stream
      final mockConnectivityStream =
          Stream<ConnectivityResult>.value(ConnectivityResult.wifi);

      // Mock the templates stream (with the mock QuerySnapshot)
      final mockTemplatesStream =
          Stream<QuerySnapshot<Map<String, dynamic>>>.value(mockQuerySnapshot);

      // Mock the service methods
      when(mockTemplateDataService.getTemplatesByCategory(any))
          .thenAnswer((_) => mockTemplatesStream);
      when(mockConnectivityService.connectivityStream)
          .thenAnswer((_) => mockConnectivityStream);

      // Initialize the streams in the category controller
      categoryController.initializeStreams('category_name');

      // Listen to the combinedStream
      final combinedStream = categoryController.combinedStream;

      // Now, we expect the combinedStream to emit two separate events: one for connectivity and one for templates.
      expectLater(
        combinedStream,
        emitsInOrder([
          {
            'connectivity': ConnectivityResult.wifi
          }, // First event with connectivity
          {'templates': mockQuerySnapshot}, // Second event with templates
        ]),
      );
    });
    test('changePage updates currentPage and notifies listeners', () {
      // Verify that `changePage` updates `currentPage` correctly.
      categoryController.changePage(2);

      // Make sure `currentPage` is updated correctly (it will clamp to 0 if no templates are available)
      expect(categoryController.currentPage,
          0); // If there are no templates, currentPage should stay 0
    });
  });
  test('getFilteredTemplates returns the correct filtered templates', () {
    final List<MockDocumentSnapshot<Map<String, dynamic>>> mockDocuments =
        List.generate(
      5,
      (index) {
        final mockDoc = MockDocumentSnapshot<Map<String, dynamic>>();
        when(mockDoc.data()).thenReturn({'template': 'Template $index'});
        return mockDoc;
      },
    );
    categoryController.currentPage = 1;

    final filteredTemplates =
        categoryController.getFilteredTemplates(mockDocuments);

    expect(filteredTemplates.length, 2);
    expect(filteredTemplates[0].data()?['template'], 'Template 2');
    expect(filteredTemplates[1].data()?['template'], 'Template 3');
  });
}
