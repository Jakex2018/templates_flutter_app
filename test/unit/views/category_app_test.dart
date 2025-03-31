import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:templates_flutter_app/controllers/category_controller.dart';
import 'package:templates_flutter_app/providers/suscription_provider.dart';
import 'package:templates_flutter_app/views/category_app.dart';

import '../../mocks/category_app_test.mocks.dart';
import '../../mocks/category_controller_test.mocks.dart';

///@GenerateMocks([CategoryController, SuscriptionProvider])
void main() {
  group('Category Widget Tests', () {
    late MockCategoryController mockCategoryController;
    late MockSuscriptionProvider mockSubscriptionProvider;

    setUp(() {
      mockCategoryController = MockCategoryController();
      mockSubscriptionProvider = MockSuscriptionProvider();

      when(mockSubscriptionProvider.isSuscribed).thenReturn(false);
    });

    testWidgets('displays loading indicator when stream is waiting',
        (tester) async {
      when(mockCategoryController.combinedStream)
          .thenAnswer((_) => Stream.value({}));

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<CategoryController>.value(
                value: mockCategoryController),
          ],
          child: MaterialApp(
            home: ChangeNotifierProvider.value(
              value: mockSubscriptionProvider,
              child: Category(
                category: 'category1',
                type: 'Free',
              ),
            ),
          ),
        ),
      );

      // Check if the loading indicator is shown
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays error message when stream has an error',
        (tester) async {
      when(mockCategoryController.combinedStream)
          .thenAnswer((_) => Stream.error('Error'));

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<CategoryController>.value(
                value: mockCategoryController),
          ],
          child: MaterialApp(
            home: ChangeNotifierProvider.value(
              value: mockSubscriptionProvider,
              child: Category(
                category: 'category1',
                type: 'Free',
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Error de conectividad'), findsOneWidget);
    });

    testWidgets('displays templates when data is available', (tester) async {
      final mockQuerySnapshot = MockQuerySnapshot<Map<String, dynamic>>();
      when(mockQuerySnapshot.docs).thenReturn([]);
      when(mockCategoryController.combinedStream)
          .thenAnswer((_) => Stream.value({
                'connectivity': ConnectivityResult.wifi,
                'templates': mockQuerySnapshot,
              }));
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<SuscriptionProvider>.value(
                value: mockSubscriptionProvider),
            ChangeNotifierProvider<CategoryController>.value(
                value: mockCategoryController),
          ],
          child: MaterialApp(
            home: ChangeNotifierProvider.value(
              value: mockSubscriptionProvider,
              child: Category(
                category: 'category1',
                type: 'Free',
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('No data available'), findsOneWidget);
    });

    testWidgets('displays subscription page when type is Premium',
        (tester) async {
      final mockQuerySnapshot = MockQuerySnapshot<Map<String, dynamic>>();

      when(mockCategoryController.combinedStream)
          .thenAnswer((_) => Stream.value({
                'connectivity': ConnectivityResult.wifi,
                'templates': mockQuerySnapshot,
              }));

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<CategoryController>.value(
              value: mockCategoryController,
            ),
            ChangeNotifierProvider<SuscriptionProvider>.value(
              value: mockSubscriptionProvider,
            ),
          ],
          child: MaterialApp(
            home: ChangeNotifierProvider.value(
              value: mockSubscriptionProvider,
              child: Category(
                category: 'category1',
                type: 'Premium',
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Your Subscription has Expired'), findsOneWidget);
    });
  });
}
