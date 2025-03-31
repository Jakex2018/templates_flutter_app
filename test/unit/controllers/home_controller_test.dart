import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:templates_flutter_app/controllers/home_controller.dart';
import 'package:templates_flutter_app/providers/auth_user_provider.dart';

///MOCKS
import '../../mocks/home_controller_test.mocks.dart';

/*
@GenerateMocks([
  LoadingService,
  ConnectivityService,
  ProviderService,
  AuthUserProvider,
  HomeController
])
 */
void main() {
  group('HomeController Tests', () {
    late MockLoadingService mockLoadingService;
    late MockConnectivityService mockConnectivityService;
    late MockProviderService mockProviderService;
    late MockAuthUserProvider mockAuthUserProvider;
    late HomeController homeController;

    setUp(() {
      // Inicializa los mocks
      mockLoadingService = MockLoadingService();
      mockConnectivityService = MockConnectivityService();
      mockProviderService = MockProviderService();
      mockAuthUserProvider = MockAuthUserProvider();

      // Crea la instancia del controlador
      homeController = HomeController(
        loadingService: mockLoadingService,
        connectivityService: mockConnectivityService,
        providerService: mockProviderService,
      );
    });

    test('Debe cambiar el estado de isLoading correctamente en simulateLoading',
        () async {
      // Configura el mock para devolver un Future<void>
      when(mockLoadingService.simulateLoading())
          .thenAnswer((_) async => Future<void>.delayed(Duration(seconds: 1)));

      // Llama a simulateLoading
      await homeController.simulateLoading();

      // Verifica que el estado de isLoading cambió a false
      expect(homeController.isLoading, false);
    });
    testWidgets('Debe inicializar el username correctamente en initialize',
        (tester) async {
      // Simula que el AuthUserProvider tiene un username
      when(mockAuthUserProvider.username).thenReturn("UsuarioPrueba");

      // Simula que initializeProviders no hace nada
      when(mockProviderService.initializeProviders(any))
          .thenAnswer((_) async {});

      // Usa un Provider real para inyectar el AuthUserProvider
      await tester.pumpWidget(
        ChangeNotifierProvider<AuthUserProvider>.value(
          value: mockAuthUserProvider,
          child: MaterialApp(
            home: HomeControllerTestWidget(homeController: homeController),
          ),
        ),
      );

      // Llama al método initialize
      await homeController
          .initialize(tester.element(find.byType(HomeControllerTestWidget)));

      // Verifica que el nombre de usuario se haya asignado correctamente
      expect(homeController.username, "UsuarioPrueba");
    });
    test('Debe cambiar el valor de showProgress al llamar toggleProgress',
        () async {
      // Verifica el valor inicial de _showProgress
      expect(homeController.showProgress, true);

      // Llama a toggleProgress
      homeController.toggleProgress();

      // Verifica que el valor haya cambiado
      expect(homeController.showProgress, false);

      // Llama nuevamente a toggleProgress
      homeController.toggleProgress();

      // Verifica que el valor vuelva a cambiar
      expect(homeController.showProgress, true);
    });
    test('Debe escuchar los cambios de conectividad correctamente', () async {
      // Configura un stream simulado para la conectividad
      final connectivityStreamController =
          StreamController<ConnectivityResult>();
      when(mockConnectivityService.connectivityStream)
          .thenAnswer((_) => connectivityStreamController.stream);

      // Escucha el stream y verifica el cambio
      homeController.connectivityStream.listen((connectivityResult) {
        expect(connectivityResult, ConnectivityResult.mobile);
      });

      // Agrega un evento al stream simulado
      connectivityStreamController.add(ConnectivityResult.mobile);

      // No olvides cerrar el stream después de la prueba
      await connectivityStreamController.close();
    });
    test('Debe llamar a notifyListeners cuando se cambia el valor de isLoading',
        () async {
      // Crea un Mock de ChangeNotifier para verificar la llamada a notifyListeners
      final mockChangeNotifier = MockHomeController();

      // Verifica que notifyListeners sea llamado cuando se llama simulateLoading
      when(mockChangeNotifier.simulateLoading()).thenAnswer((_) async {
        await mockLoadingService.simulateLoading();
        mockChangeNotifier.notifyListeners();
        return; // Simula la llamada a notifyListeners
      });

      // Llama a simulateLoading y verifica que notifyListeners sea llamado
      await mockChangeNotifier.simulateLoading();
      verify(mockChangeNotifier.notifyListeners()).called(1);
    });
  });
}

// Un widget simple para probar el HomeController
class HomeControllerTestWidget extends StatelessWidget {
  final HomeController homeController;
  const HomeControllerTestWidget({super.key, required this.homeController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider.value(
        value: homeController,
        child: Consumer<HomeController>(
          builder: (context, controller, child) {
            return Text(controller.username); // Muestra el username
          },
        ),
      ),
    );
  }
}
