import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:templates_flutter_app/controllers/template_controller.dart';
import '../../mocks/template_controller_test.mocks.dart';

void main() {
  late TemplateController templateController;
  late MockTemplateDataService mockTemplateDataService;

  setUp(() {
    mockTemplateDataService = MockTemplateDataService();
    templateController = TemplateController(mockTemplateDataService);
  });

  group('TemplateController', () {
    test('getTemplateData should return a map with name, url, and nameImage',
        () async {
      // Arrange
      const image = 'image.png';
      when(mockTemplateDataService.fetchNameTemplate(image))
          .thenAnswer((_) async => 'Template Name');
      when(mockTemplateDataService.fetchUrlTemplate(image))
          .thenAnswer((_) async => 'https://example.com/template');
      when(mockTemplateDataService.fetchGetNameImage(image))
          .thenAnswer((_) async => 'template_image.png');

      // Act
      final result = await templateController.getTemplateData(image);

      // Assert
      expect(result, {
        'name': 'Template Name',
        'url': 'https://example.com/template',
        'nameImage': 'template_image.png',
      });
      verify(mockTemplateDataService.fetchNameTemplate(image)).called(1);
      verify(mockTemplateDataService.fetchUrlTemplate(image)).called(1);
      verify(mockTemplateDataService.fetchGetNameImage(image)).called(1);
    });

    test('downloadImage should call fetchDownloadImage', () async {
      // Arrange
      const image = 'image.png';
      when(mockTemplateDataService.fetchDownloadImage(image))
          .thenAnswer((_) async {});

      // Act
      await templateController.downloadImage(image);

      // Assert
      verify(mockTemplateDataService.fetchDownloadImage(image)).called(1);
    });

    test('saveUrlTemplate should call fetchSaveUrlTemplate', () async {
      // Arrange
      const url = 'https://example.com/template';
      when(mockTemplateDataService.fetchSaveUrlTemplate(url))
          .thenAnswer((_) async {});

      // Act
      await templateController.saveUrlTemplate(url);

      // Assert
      verify(mockTemplateDataService.fetchSaveUrlTemplate(url)).called(1);
    });

    test('accessDemo should return the demo URL', () async {
      // Arrange
      const image = 'image.png';
      const demoUrl = 'https://example.com/demo';
      when(mockTemplateDataService.accessDemo(image))
          .thenAnswer((_) async => demoUrl);

      // Act
      final result = await templateController.accessDemo(image);

      // Assert
      expect(result, demoUrl);
      verify(mockTemplateDataService.accessDemo(image)).called(1);
    });
  });
}
