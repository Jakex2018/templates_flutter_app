import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:templates_flutter_app/controllers/home_controller.dart';
import 'package:templates_flutter_app/providers/auth_user_provider.dart';
import 'package:templates_flutter_app/services/connectivity_services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:templates_flutter_app/services/loading_services.dart';
import 'package:templates_flutter_app/services/provider_services.dart';
import 'package:templates_flutter_app/views/sidebar_screen.dart';
import 'package:templates_flutter_app/widget/custom_app_bar.dart';
import 'package:templates_flutter_app/widget/home_card.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  bool isLoading = true;
  String username = "";

  late HomeController _homeController;
  final LoadingService _loadingService = LoadingService();
  final ConnectivityService _connectivityService = ConnectivityService();
  final ProviderService _providerService = ProviderService();

  bool showProgress = true;

  @override
  void initState() {
    super.initState();
    _homeController = HomeController();

    _providerService.initializeProviders(context);

    // Use the Timer here
    _loadingService.simulateLoading().then((_) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _homeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthUserProvider>(context,listen: false);
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          if (isLoading) _buildLoadScreen(context),
          if (!isLoading) _buildHomeContent(scaffoldKey, authProvider),
        ],
      ),
    );
  }

  Scaffold _buildHomeContent(
      GlobalKey<ScaffoldState> scaffoldKey, AuthUserProvider authProvider) {
    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar(onTap: () => scaffoldKey.currentState!.openDrawer()),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _homeTypeContent('Choose a Category'),
            _homeContent(_homeController),
          ],
        ),
      ),
      drawer: Sidebar(
          isLoggedIn: authProvider,
          username: authProvider.username ?? "Invitado"),
    );
  }

  Widget _homeContent(HomeController homeController) {
    return StreamBuilder<ConnectivityResult>(
      stream: _connectivityService.connectivityStream,
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

  Widget _homeTypeContent(String title) {
    return Container(
      height: 41,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onTertiary,
      ),
      child: Center(
          child: Text(
        title,
        style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: 20,
            fontWeight: FontWeight.bold),
      )),
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
}
