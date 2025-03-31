import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:templates_flutter_app/controllers/template_controller.dart';
import 'package:templates_flutter_app/providers/suscription_provider.dart';
import 'package:templates_flutter_app/services/ad_services.dart';
import 'package:templates_flutter_app/services/template_data_services.dart';
import 'package:templates_flutter_app/views/template_app.dart';
import '../../mocks/setup_firebase_auth_mocks.dart.dart';
import '../../mocks/template_app_test.mocks.dart';

@GenerateMocks(
    [TemplateDataService, AdService, SuscriptionProvider, TemplateController])
void main() {
  setupFirebaseAuthMocks();
  group('Template Widget Tests', () {
    late MockTemplateDataService mockTemplateDataService;
    late MockAdService mockAdService;
    late MockSuscriptionProvider mockSuscriptionProvider;

    setUp(() async {
      await Firebase.initializeApp();

      mockTemplateDataService = MockTemplateDataService();
      mockAdService = MockAdService();
      mockSuscriptionProvider = MockSuscriptionProvider();
    });

    testWidgets('Template widget displays UI correctly',
        (WidgetTester tester) async {
      const testImage = 'https://example.com/test_image.jpg';

      when(mockTemplateDataService.fetchNameTemplate(testImage))
          .thenAnswer((_) async => 'Template Name');
      when(mockTemplateDataService.fetchUrlTemplate(testImage))
          .thenAnswer((_) async => 'https://example.com/template_url');
      when(mockTemplateDataService.fetchGetNameImage(testImage))
          .thenAnswer((_) async => 'test_image_name');
      when(mockTemplateDataService.fetchDownloadImage(testImage))
          .thenAnswer((_) async => 'image_downloaded');
      when(mockSuscriptionProvider.isSuscribed).thenReturn(false);
      when(mockAdService.showRewardedAd()).thenAnswer((_) async => true);
      when(mockTemplateDataService.accessDemo(testImage))
          .thenAnswer((_) async => 'https://example.com/demo');

      await tester.pump(Duration(seconds: 10));

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<SuscriptionProvider>.value(
            value: mockSuscriptionProvider,
            child: Template(image: testImage),
          ),
        ),
      );

      await tester.pump(Duration(seconds: 10));

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Template'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(CachedNetworkImage), findsOneWidget);

      expect(find.text('Download Image'), findsOneWidget);
      expect(find.byIcon(Icons.download_for_offline_rounded), findsOneWidget);
      expect(find.text('Source Code'), findsOneWidget);
      expect(find.byIcon(Icons.code), findsOneWidget);
      expect(find.text('Demo'), findsOneWidget);
      expect(find.byIcon(Icons.developer_mode), findsOneWidget);

      final downloadButton = find.byIcon(Icons.download_for_offline_rounded);
      await tester.tap(downloadButton);
      await tester.pump();
    });

    testWidgets('Template widget displays error when image fails to load',
        (WidgetTester tester) async {
      const testImage = 'https://example.com/invalid_image.jpg';

      when(mockTemplateDataService.fetchNameTemplate(testImage))
          .thenAnswer((_) async => 'Template Name');
      when(mockTemplateDataService.fetchUrlTemplate(testImage))
          .thenAnswer((_) async => 'https://example.com/template_url');
      when(mockTemplateDataService.fetchGetNameImage(testImage))
          .thenAnswer((_) async => 'test_image_name');
      when(mockTemplateDataService.fetchDownloadImage(testImage))
          .thenAnswer((_) async => 'image_downloaded');
      when(mockSuscriptionProvider.isSuscribed).thenReturn(false);
      when(mockAdService.showRewardedAd()).thenAnswer((_) async => true);
      when(mockTemplateDataService.accessDemo(testImage))
          .thenAnswer((_) async => 'https://example.com/demo');

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<SuscriptionProvider>.value(
            value: mockSuscriptionProvider,
            child: Template(image: testImage),
          ),
        ),
      );

      await tester.pump(Duration(seconds: 10));
      expect(find.byType(CachedNetworkImage), findsOneWidget);
    });
  });
}
