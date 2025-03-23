import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:templates_flutter_app/controllers/template_controller.dart';
import 'package:templates_flutter_app/models/template_model.dart';
import '../../mocks/setup_firebase_auth_mocks.dart.dart';
import '../../mocks/template_app_test.mocks.dart';

// Genera el mock usando build_runner
/*
@GenerateMocks(
    [TemplateDataService, AdService, SuscriptionProvider, TemplateController]) */
void main() {
  setupFirebaseAuthMocks();
  late TemplateController templateController;
  late MockTemplateDataService mockTemplateDataService;
  late MockAdService mockAdService;
  late MockSuscriptionProvider mockSuscriptionProvider;

  setUp(() async {
    await Firebase.initializeApp();
    mockTemplateDataService = MockTemplateDataService();
    mockAdService = MockAdService();
    mockSuscriptionProvider = MockSuscriptionProvider();
    templateController = TemplateController(
      mockTemplateDataService,
      mockAdService,
      mockSuscriptionProvider,
    );
  });

  group('TemplateController Tests', () {
    test('getTemplateData returns a TemplateModel', () async {
      // Arrange
      when(mockTemplateDataService.fetchNameTemplate('image_url'))
          .thenAnswer((_) async => 'Template Name');
      when(mockTemplateDataService.fetchUrlTemplate('image_url'))
          .thenAnswer((_) async => 'https://example.com');
      when(mockTemplateDataService.fetchGetNameImage('image_url'))
          .thenAnswer((_) async => 'image_name.jpg');

      // Act
      final result = await templateController.getTemplateData('image_url');

      // Assert
      expect(result, isA<TemplateModel>());
      expect(result.name, 'Template Name');
      expect(result.url, 'https://example.com');
      expect(result.nameImage, 'image_name.jpg');
    });

    test(
        'downloadImage calls showRewardedAd and fetchDownloadImage when not subscribed',
        () async {
      // Arrange
      when(mockSuscriptionProvider.isSuscribed).thenReturn(false);
      when(mockAdService.showRewardedAd()).thenAnswer((_) async {});
      when(mockTemplateDataService.fetchDownloadImage('image_url'))
          .thenAnswer((_) async {});

      // Act
      await templateController.downloadImage('image_url');

      // Assert
      verify(mockAdService.showRewardedAd()).called(1);
      verify(mockTemplateDataService.fetchDownloadImage('image_url')).called(1);
    });

    test('downloadImage does not call showRewardedAd when subscribed',
        () async {
      // Arrange
      when(mockSuscriptionProvider.isSuscribed).thenReturn(true);
      when(mockTemplateDataService.fetchDownloadImage('image_url'))
          .thenAnswer((_) async {});

      // Act
      await templateController.downloadImage('image_url');

      // Assert
      verifyNever(mockAdService.showRewardedAd());
      verify(mockTemplateDataService.fetchDownloadImage('image_url')).called(1);
    });

    test(
        'saveUrlTemplate calls showRewardedAd and fetchSaveUrlTemplate when not subscribed',
        () async {
      // Arrange
      when(mockSuscriptionProvider.isSuscribed).thenReturn(false);
      when(mockAdService.showRewardedAd()).thenAnswer((_) async {});
      when(mockTemplateDataService.fetchSaveUrlTemplate('https://example.com'))
          .thenAnswer((_) async {});

      // Act
      await templateController.saveUrlTemplate('https://example.com');

      // Assert
      verify(mockAdService.showRewardedAd()).called(1);
      verify(mockTemplateDataService
              .fetchSaveUrlTemplate('https://example.com'))
          .called(1);
    });

    test('saveUrlTemplate does not call showRewardedAd when subscribed',
        () async {
      // Arrange
      when(mockSuscriptionProvider.isSuscribed).thenReturn(true);
      when(mockTemplateDataService.fetchSaveUrlTemplate('https://example.com'))
          .thenAnswer((_) async {});

      // Act
      await templateController.saveUrlTemplate('https://example.com');

      // Assert
      verifyNever(mockAdService.showRewardedAd());
      verify(mockTemplateDataService
              .fetchSaveUrlTemplate('https://example.com'))
          .called(1);
    });

    test(
        'accessDemo calls showRewardedAd and returns demo URL when not subscribed',
        () async {
      // Arrange
      when(mockSuscriptionProvider.isSuscribed).thenReturn(false);
      when(mockAdService.showRewardedAd()).thenAnswer((_) async {});
      when(mockTemplateDataService.accessDemo('image_url'))
          .thenAnswer((_) async => 'https://demo.com');

      // Act
      final result = await templateController.accessDemo('image_url');

      // Assert
      expect(result, 'https://demo.com');
      verify(mockAdService.showRewardedAd()).called(1);
      verify(mockTemplateDataService.accessDemo('image_url')).called(1);
    });

    test('accessDemo does not call showRewardedAd when subscribed', () async {
      // Arrange
      when(mockSuscriptionProvider.isSuscribed).thenReturn(true);
      when(mockTemplateDataService.accessDemo('image_url'))
          .thenAnswer((_) async => 'https://demo.com');

      // Act
      final result = await templateController.accessDemo('image_url');

      // Assert
      expect(result, 'https://demo.com');
      verifyNever(mockAdService.showRewardedAd());
      verify(mockTemplateDataService.accessDemo('image_url')).called(1);
    });
  });
}









/*
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

 */