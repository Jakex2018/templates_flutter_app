import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';
import 'package:templates_flutter_app/controllers/template_controller.dart';
import 'package:templates_flutter_app/models/template_model.dart';

import '../../mocks/template_controller_test.mocks.dart';

/*@GenerateMocks([TemplateDataService, AdService, SuscriptionProvider]) */
void main() {
  late TemplateController templateController;
  late MockTemplateDataService mockDataService;
  late MockAdService mockAdService;
  late MockSuscriptionProvider mockSubscriptionProvider;

  setUp(() {
    mockDataService = MockTemplateDataService();
    mockAdService = MockAdService();
    mockSubscriptionProvider = MockSuscriptionProvider();
    templateController = TemplateController(
        mockDataService, mockAdService, mockSubscriptionProvider);
  });

  group('TemplateController', () {
    test('getTemplateData should return a TemplateModel with correct data',
        () async {
      // Arrange
      String image = 'test_image';
      when(mockDataService.fetchNameTemplate(image))
          .thenAnswer((_) async => 'Template Name');
      when(mockDataService.fetchUrlTemplate(image))
          .thenAnswer((_) async => 'https://example.com');
      when(mockDataService.fetchGetNameImage(image))
          .thenAnswer((_) async => 'test_image_name');

      // Act
      TemplateModel result = await templateController.getTemplateData(image);

      // Assert
      expect(result.name, 'Template Name');
      expect(result.url, 'https://example.com');
      expect(result.nameImage, 'test_image_name');
    });

    test('downloadImage should show ad if not subscribed', () async {
      // Arrange
      String image = 'test_image';
      when(mockSubscriptionProvider.isSuscribed)
          .thenReturn(false); // Simulamos que no está suscrito
      when(mockAdService.showRewardedAd()).thenAnswer((_) async {
        return true;
      });
      when(mockDataService.fetchDownloadImage(image)).thenAnswer((_) async {
        return;
      });

      // Act
      await templateController.downloadImage(image);

      // Assert
      verify(mockAdService.showRewardedAd())
          .called(1); // Verifica que se mostró el anuncio
      verify(mockDataService.fetchDownloadImage(image))
          .called(1); // Verifica que se descargó la imagen
    });
    test('downloadImage should not show ad if subscribed', () async {
      // Arrange
      String image = 'test_image';
      when(mockSubscriptionProvider.isSuscribed)
          .thenReturn(true); // Simulamos que está suscrito
      when(mockDataService.fetchDownloadImage(image)).thenAnswer((_) async {
        return;
      });

      // Act
      await templateController.downloadImage(image);

      // Assert
      verifyNever(mockAdService
          .showRewardedAd()); // No debería haberse mostrado el anuncio
      verify(mockDataService.fetchDownloadImage(image))
          .called(1); // Verifica que se descargó la imagen
    });

    test('saveUrlTemplate should show ad if not subscribed', () async {
      // Arrange
      String url = 'https://example.com';
      when(mockSubscriptionProvider.isSuscribed)
          .thenReturn(false); // Simulamos que no está suscrito
      when(mockAdService.showRewardedAd()).thenAnswer((_) async {
        return true;
      });
      when(mockDataService.fetchSaveUrlTemplate(url)).thenAnswer((_) async {
        return;
      });

      // Act
      await templateController.saveUrlTemplate(url);

      // Assert
      verify(mockAdService.showRewardedAd())
          .called(1); // Verifica que se mostró el anuncio
      verify(mockDataService.fetchSaveUrlTemplate(url))
          .called(1); // Verifica que se guardó la URL
    });
    test('accessDemo should return a demo URL if not subscribed', () async {
      // Arrange
      String image = 'test_image';
      when(mockSubscriptionProvider.isSuscribed)
          .thenReturn(false); // Simulamos que no está suscrito
      when(mockAdService.showRewardedAd()).thenAnswer((_) async {
        return true;
      });
      when(mockDataService.accessDemo(image))
          .thenAnswer((_) async => 'https://demo.com');

      // Act
      String? demoUrl = await templateController.accessDemo(image);

      // Assert
      expect(demoUrl, 'https://demo.com');
      verify(mockAdService.showRewardedAd())
          .called(1); // Verifica que se mostró el anuncio
    });

    test('accessDemo should return null if subscribed', () async {
      // Arrange
      String image = 'test_image';
      when(mockSubscriptionProvider.isSuscribed)
          .thenReturn(true); // Simulamos que está suscrito
      when(mockDataService.accessDemo(image))
          .thenAnswer((_) async => 'https://demo.com');

      // Act
      String? demoUrl = await templateController.accessDemo(image);

      // Assert
      expect(demoUrl, 'https://demo.com');
      verifyNever(mockAdService
          .showRewardedAd()); // No debería haberse mostrado el anuncio
    });
  });
}
