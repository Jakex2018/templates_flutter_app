import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:templates_flutter_app/controllers/home_controller.dart';
import 'package:templates_flutter_app/providers/auth_user_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:templates_flutter_app/services/loading_services.dart';
import 'package:templates_flutter_app/views/sidebar_screen.dart';
import 'package:templates_flutter_app/widget/custom_app_bar.dart';
import 'package:templates_flutter_app/widget/home_card.dart';
import 'package:templates_flutter_app/services/connectivity_services.dart';
import 'package:templates_flutter_app/services/provider_services.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late final HomeController _homeController;

  @override
  void initState() {
    super.initState();
    _homeController = HomeController(
      loadingService: LoadingService(),
      connectivityService: ConnectivityService(),
      providerService: ProviderService(),
    );
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _homeController.initialize(context);
    await _homeController.simulateLoading();
  }

  @override
  Widget build(BuildContext context) {
    final homeController = Provider.of<HomeController>(context);
    final authProvider = Provider.of<AuthUserProvider>(context, listen: false);
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return ChangeNotifierProvider.value(
      value: _homeController,
      child: Consumer<HomeController>(
        builder: (context, controller, _) {
          return Scaffold(
            key: scaffoldKey,
            appBar: CustomAppBar(
              onTap: () => scaffoldKey.currentState!.openDrawer(),
            ),
            body: LayoutBuilder(
              builder: (context, constraints) {
                if (controller.isLoading) return _buildLoadScreen(context);
                if (!controller.isLoading) {
                  return _buildHomeContent(
                      authProvider, constraints, homeController, context);
                }
                return Container();
              },
            ),
            drawer: Sidebar(
              isLoggedIn: authProvider,
              username: authProvider.username ?? "Invitado",
            ),
          );
        },
      ),
    );
  }

  Widget _homeContent(HomeController homeController) {
    return StreamBuilder<ConnectivityResult>(
      stream: _homeController.connectivityStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error de conectividad');
        }

        return Container(
          height: MediaQuery.of(context).size.height * .8,
          width: MediaQuery.of(context).size.width,
          color: Theme.of(context).colorScheme.surface,
          child: SingleChildScrollView(
            child: HomeCard(),
          ),
        );
      },
    );
  }

  Container _buildLoadScreen(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Theme.of(context).colorScheme.surface,
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildHomeContent(
      AuthUserProvider authProvider,
      BoxConstraints constraints,
      HomeController homeController,
      BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _homeTypeContent('Choose a Category', constraints, context),
        Expanded(child: _homeContent(homeController)),
      ],
    );
  }

  Widget _homeTypeContent(
      String title, BoxConstraints constraints, BuildContext context) {
    return Container(
      height: 41,
      width: constraints.maxWidth,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onTertiary,
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}




/*

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late final HomeController _homeController;

  @override
  void initState() {
    super.initState();
    _homeController = HomeController(
      loadingService: LoadingService(),
      connectivityService: ConnectivityService(),
      providerService: ProviderService(),
    );
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _homeController.initialize(context);
    await _homeController.simulateLoading();
  }

  @override
  Widget build(BuildContext context) {
    final homeController = Provider.of<HomeController>(context);
    final authProvider = Provider.of<AuthUserProvider>(context, listen: false);
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return ChangeNotifierProvider.value(
      value: _homeController,
      child: Consumer<HomeController>(
        builder: (context, controller, _) {
          return Scaffold(
            key: scaffoldKey,
            appBar: CustomAppBar(
              onTap: () => scaffoldKey.currentState!.openDrawer(),
            ),
            body: LayoutBuilder(
              builder: (context, constraints) {
                if (controller.isLoading) return _buildLoadScreen(context);
                if (!controller.isLoading) {
                  return _buildHomeContent(
                      authProvider, constraints, homeController, context);
                }
                return Container();
              },
            ),
            drawer: Sidebar(
              isLoggedIn: authProvider,
              username: authProvider.username ?? "Invitado",
            ),
          );
        },
      ),
    );
  }

  Widget _homeContent(HomeController homeController) {
    return StreamBuilder<ConnectivityResult>(
      stream: _homeController.connectivityStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error de conectividad');
        }

        return Container(
          height: MediaQuery.of(context).size.height * .8,
          width: MediaQuery.of(context).size.width,
          color: Theme.of(context).colorScheme.surface,
          child: SingleChildScrollView(
            child: HomeCard(),
          ),
        );
      },
    );
  }

  Container _buildLoadScreen(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Theme.of(context).colorScheme.surface,
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildHomeContent(
      AuthUserProvider authProvider,
      BoxConstraints constraints,
      HomeController homeController,
      BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _homeTypeContent('Choose a Category', constraints, context),
        Expanded(child: _homeContent(homeController)),
      ],
    );
  }

  Widget _homeTypeContent(
      String title, BoxConstraints constraints, BuildContext context) {
    return Container(
      height: 41,
      width: constraints.maxWidth,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onTertiary,
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

 */