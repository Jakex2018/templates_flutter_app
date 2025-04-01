import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:templates_flutter_app/controllers/suscription_controller.dart';
import 'package:templates_flutter_app/models/suscription_model.dart';
import 'package:templates_flutter_app/providers/suscription_provider.dart';
import 'package:templates_flutter_app/services/suscription_services.dart';

import '../../mocks/mock_build_context.dart';
import '../../mocks/suscription_controller_test.mocks.dart';

@GenerateMocks([SuscriptionServices, SuscriptionProvider])
void main() {
  group('SuscriptionController', () {
    late SuscriptionController suscriptionController;
    late MockSuscriptionServices mockSuscriptionServices;
    late MockSuscriptionProvider mockSuscriptionProvider;
    late MockBuildContext mockContext;

    setUp(() {
      mockSuscriptionServices = MockSuscriptionServices();
      mockSuscriptionProvider = MockSuscriptionProvider();
      mockContext = MockBuildContext();
      suscriptionController = SuscriptionController(
        subscriptionServices: mockSuscriptionServices,
        suscriptionProvider: mockSuscriptionProvider,
      );
    });

    test('should call cancelSubscription when isSuscribed is true', () async {
      // Configura el mock
      when(mockSuscriptionProvider.isSuscribed).thenReturn(true);

      // Simula la llamada al método del controlador
      await suscriptionController.cancelSubscription(
          mockContext,
          'user123',
          SuscriptionModel(
            title: 'Premium',
            price: 10.0,
            items: {
              'items0': "https://example.com/item0.jpg",
              'items1': "https://example.com/item1.jpg",
              'items2': "https://example.com/item2.jpg",
            },
            desc: {
              'desc0': "Description item 0",
              'desc1': "Description item 1",
              'desc2': "Description item 2",
            },
            cat: SuscriptionCat.premium,
            icon: Icon(Icons.add),
          ));

      // Verifica que el método del servicio fue llamado
      verify(mockSuscriptionServices.cancelSubscription(
        any,
        'user123',
        mockSuscriptionProvider,
        any,
      )).called(1);
    });
    test('should call handleSubscription when isSuscribed is false', () async {
      // Configura el mock
      when(mockSuscriptionProvider.isSuscribed).thenReturn(false);

      // Simula la llamada al método del controlador
      await suscriptionController.handleSubscription(
          mockContext,
          SuscriptionModel(
            title: 'Premium',
            price: 10.0,
            items: {
              'items0': "https://example.com/item0.jpg",
              'items1': "https://example.com/item1.jpg",
              'items2': "https://example.com/item2.jpg",
            },
            desc: {
              'desc0': "Description item 0",
              'desc1': "Description item 1",
              'desc2': "Description item 2",
            },
            cat: SuscriptionCat.premium,
            icon: Icon(Icons.add),
          ));

      // Verifica que el método del servicio fue llamado
      verify(mockSuscriptionServices.handleSubscription(any, any)).called(1);
    });
  });
}


/*
test('should call handleSubscription when isSuscribed is false', () async {
      // Configura el mock
      when(mockSuscriptionProvider.isSuscribed).thenReturn(false);

      // Simula la llamada al método del controlador
      await suscriptionController.handleSubscription(
        any, 
        SuscriptionModel(title: 'Basic', price: 5.0, items: [])
      );

      // Verifica que el método del servicio fue llamado
      verify(mockSuscriptionServices.handleSubscription(any, any)).called(1);
    });
 */