import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:templates_flutter_app/controllers/suscription_controller.dart';
import 'package:templates_flutter_app/models/suscription_model.dart';

import '../../mocks/suscription_controller_test.mocks.dart';

///@GenerateMocks([SuscriptionServices, BuildContext,SuscriptionProvider])
void main() {
  late SuscriptionController suscriptionController;
  late MockSuscriptionServices mockSuscriptionServices;
  late MockSuscriptionProvider mockSuscriptionProvider;
  late MockBuildContext mockBuildContext;

  setUp(() {
    mockSuscriptionServices = MockSuscriptionServices();
    mockSuscriptionProvider = MockSuscriptionProvider();
    mockBuildContext = MockBuildContext();
    suscriptionController = SuscriptionController(
      subscriptionServices: mockSuscriptionServices,
      suscriptionProvider: mockSuscriptionProvider,
    );
  });

  test('cancelSubscription should call cancelSubscription on SuscriptionServices', () async {
    // Arrange
    final userId = '123';
    final suscription = SuscriptionModel(
      title: 'Free',
      icon: Icon(Icons.coffee, size: 24, color: Colors.black),
      cat: SuscriptionCat.free,
      desc: {
        'desc01': 'Templates Free',
        'desc02': 'Limitated Chat Bot',
        'desc03': '5 Coins for day IA Chat Bot'
      },
      items: {
        'items01': 'asset/verify.png',
        'items02': 'asset/verify.png',
        'items03': 'asset/verify.png',
      },
      price: 0.0,
    );

    when(mockSuscriptionServices.cancelSubscription(
      mockBuildContext,
      userId,
      mockSuscriptionProvider,
      suscription,
    )).thenAnswer((_) async {});

    // Act
    await suscriptionController.cancelSubscription(mockBuildContext, userId, suscription);

    // Assert
    verify(mockSuscriptionServices.cancelSubscription(
      mockBuildContext,
      userId,
      mockSuscriptionProvider,
      suscription,
    )).called(1);
  });
}