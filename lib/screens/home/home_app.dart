import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:templates_flutter_app/screens/home/services/initialize_providers.dart';
import 'package:templates_flutter_app/screens/home/widget/home_content.dart';
import 'package:templates_flutter_app/screens/home/widget/home_type_content.dart';
import 'package:templates_flutter_app/screens/sidebar/sidebar_screen.dart';
import 'package:templates_flutter_app/screens/auth/model/user_model.dart';
import 'package:templates_flutter_app/widget/custom_app_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String username = '';
  Future<void> loadData() async {
    await Future.delayed(Duration(seconds: 3));
  }

  @override
  void initState() {
    super.initState();
    initializeProviders(context);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthUserProvider>(context);
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Stack(
      children: [
        FutureBuilder(
          future: loadData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadScreen(context);
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return _buildHomeContent(scaffoldKey, authProvider);
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error al cargar los datos'));
            }
            return SizedBox();
          },
        ),
      ],
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
            HomeTypeContent(title: 'Choose a Category'),
            HomeContent(),
          ],
        ),
      ),
      drawer: Sidebar(isLoggedIn: authProvider, username: username),
    );
  }

  Container _buildLoadScreen(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.black.withOpacity(0.6),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
