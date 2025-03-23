/*
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:templates_flutter_app/controllers/category_controller.dart';

import '../../mocks/category_controller_test.mocks.dart';

//@GenerateMocks([TemplateDataService, ConnectivityService])
void main() {
  late CategoryController controller;
  late MockTemplateDataService mockTemplateDataService;
  late MockConnectivityService mockConnectivityService;

  setUp(() {
    mockTemplateDataService = MockTemplateDataService();
    mockConnectivityService = MockConnectivityService();
    controller = CategoryControllerImpl(
      templateService: mockTemplateDataService,
      connectivityService: mockConnectivityService,
    );
  });

  test('Change page updates currentPage', () {
    controller.changePage(2);
    expect(controller.currentPage, 2);
  });

  test('getTemplatesByCategory returns a stream', () {
    when(mockTemplateDataService.getTemplatesByCategory(any))
        .thenAnswer((_) => Stream.empty());
    expect(controller.getTemplatesByCategory('category'), isA<Stream>());
  });
}

 */