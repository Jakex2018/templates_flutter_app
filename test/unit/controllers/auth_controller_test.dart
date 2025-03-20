import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:templates_flutter_app/controllers/auth_controller.dart';


// Importa el archivo generado por Mockito
import '../../mocks/auth_controller_test.mocks.dart';
import '../../mocks/mock_build_context.dart';

// Anota la clase que deseas mockear
///@GenerateMocks([AuthServices, BuildContext])
void main() {
  late AuthController authController;
  late MockAuthServices mockAuthServices;
  late MockBuildContext mockBuildContext;

  setUp(() {
    mockAuthServices = MockAuthServices(); // Crea el mock de AuthServices
    mockBuildContext = MockBuildContext(); // Crea el mock de BuildContext
    authController = AuthController(authServices: mockAuthServices); // Inyecta el mock
  });

  group('AuthController', () {
    test('loginUser should call AuthServices.loginUser', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password';
      final formKey = GlobalKey<FormState>();

      // Simula el comportamiento de AuthServices.loginUser
      when(mockAuthServices.loginUser(email, password, mockBuildContext, formKey))
          .thenAnswer((_) async {});

      // Act
      await authController.loginUser(email, password, mockBuildContext, formKey);

      // Assert
      verify(mockAuthServices.loginUser(email, password, mockBuildContext, formKey)).called(1);
    });

    test('registerUser should call AuthServices.registerUser', () async {
      // Arrange
      const username = 'testuser';
      const email = 'test@example.com';
      const password = 'password';
      final formKey = GlobalKey<FormState>();

      // Simula el comportamiento de AuthServices.registerUser
      when(mockAuthServices.registerUser(username, email, password, mockBuildContext, formKey))
          .thenAnswer((_) async {});

      // Act
      await authController.registerUser(username, email, password, mockBuildContext, formKey);

      // Assert
      verify(mockAuthServices.registerUser(username, email, password, mockBuildContext, formKey)).called(1);
    });

    test('logoutUser should call AuthServices.logoutUser', () async {
      // Arrange
      // Simula el comportamiento de AuthServices.logoutUser
      when(mockAuthServices.logoutUser(mockBuildContext))
          .thenAnswer((_) async {});

      // Act
      await authController.logoutUser(mockBuildContext);

      // Assert
      verify(mockAuthServices.logoutUser(mockBuildContext)).called(1);
    });
  });
}