import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:provider/provider.dart';
import 'package:templates_flutter_app/common/constants/constants.dart';
import 'package:templates_flutter_app/controllers/category_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:templates_flutter_app/views/home_app.dart';
import 'package:templates_flutter_app/views/template_app.dart';
import 'package:templates_flutter_app/widget/splash_subscribe.dart';
import 'package:templates_flutter_app/providers/suscription_provider.dart';

class Category extends StatefulWidget {
  const Category({
    super.key,
    required this.category,
    required this.type,
  });

  final String category;
  final String type;

  @override
  // ignore: library_private_types_in_public_api
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  late CategoryController categoryController;

  @override
  void initState() {
    super.initState();
    categoryController = context.read<CategoryController>();
    categoryController.initializeStreams(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Consumer<CategoryController>(
        builder: (context, categoryController, child) {
          return StreamBuilder<Map<String, dynamic>>(
            stream: categoryController.combinedStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: const CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Text('Error de conectividad');
              }

              if (!snapshot.hasData) {
                return const Text('No data available');
              }

              final connectivity = snapshot.data!['connectivity'];
              final templateSnapshot = snapshot.data!['templates'];

              if (connectivity == ConnectivityResult.none) {
                return const Text('Error de conectividad');
              }

              return _categoryBody(
                  widget.type, templateSnapshot, categoryController);
            },
          );
        },
      ),
    );
  }

  Widget _categoryBody(
      String categoryType,
      QuerySnapshot<Map<String, dynamic>> snapshot,
      CategoryController categoryController) {
    return Consumer<SuscriptionProvider>(
      builder: (context, subscriptionProvider, child) {
        if (categoryType == 'Free' ||
            subscriptionProvider.isSuscribed == true) {
          return Material(
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  'Category',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              body: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _categoryTypeContent(widget.category),
                      showTemplates(snapshot, categoryController),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else if (categoryType == 'Premium') {
          return const SplashSuscribe(
            widgetScreen: Home(),
            titleSuscription: 'Your Subscription has Expired',
          );
        } else {
          return const Material();
        }
      },
    );
  }

  Widget showTemplates(QuerySnapshot<Map<String, dynamic>> snapshot,
      CategoryController categoryController) {
    if (snapshot.docs.isEmpty) {
      return const Text('No data available');
    }

    final documents = snapshot.docs;
    final filteredDocs = categoryController.getFilteredTemplates(documents);

    return SizedBox(
      height: MediaQuery.of(context).size.height * .8,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: filteredDocs.length,
              itemBuilder: (context, index) {
                final doc = filteredDocs[index];
                final imageUrl = doc['image'] ?? '';
                if (imageUrl.isEmpty) {
                  return const Icon(Icons.error);
                }
                return _categoryCard(imageUrl);
              },
            ),
          ),
          NumberPaginator(
            config: NumberPaginatorUIConfig(
              buttonSelectedBackgroundColor:
                  Theme.of(context).colorScheme.onTertiary,
            ),
            numberPages:
                (documents.length / categoryController.itemsPerPage).ceil(),
            initialPage: categoryController.currentPage,
            onPageChange: (index) =>
                setState(() => categoryController.currentPage = index),
          ),
        ],
      ),
    );
  }

  Widget _categoryTypeContent(String title) {
    return Container(
      height: 51,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onTertiary,
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _categoryCard(String imageUrl) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Template(
              image: imageUrl,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: aDefaultPadding * 2,
          vertical: aDefaultPadding,
        ),
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: BorderDirectional(
                top: BorderSide(color: Colors.black12, width: 2)),
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                offset: Offset(0, 10),
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ],
          ),
          child: FutureBuilder(
            future: _loadImage(imageUrl),
            builder: (context, imageSnapshot) {
              if (imageSnapshot.connectionState == ConnectionState.waiting) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: imageUrl.startsWith('http')
                      ? CachedNetworkImage(
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          placeholder: (context, url) => ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.asset(
                              'asset/bg_01.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          height: 210,
                        )
                      : Image.asset(
                          'asset/bg_01.jpg',
                          fit: BoxFit.cover,
                        ),
                );
              } else if (imageSnapshot.hasError) {
                return const Icon(Icons.error);
              }

              return imageUrl.startsWith('http')
                  ? CachedNetworkImage(
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      placeholder: (context, url) => ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.asset(
                          'asset/bg_01.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      imageUrl: imageUrl,
                      fit: BoxFit.fitHeight,
                      height: 210,
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.asset(
                        imageUrl,
                        fit: BoxFit.cover,
                        height: 210,
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _loadImage(String imageUrl) async {
    if (imageUrl.isEmpty) {
      return;
    }

    try {
      if (imageUrl.startsWith('http')) {
        await precacheImage(NetworkImage(imageUrl), context);
      } else {
        await precacheImage(AssetImage(imageUrl), context);
      }
    } catch (e) {
      debugPrint("Errors al precargar la imagen: $e");
    }
  }
}

/*
class Category extends StatefulWidget {
  const Category({
    super.key,
    required this.category,
    required this.type,
  });

  final String category;
  final String type;

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  late Stream<ConnectivityResult> _connectivityStream;
  late Stream<Map<String, dynamic>> _combinedStream;

  @override
  void initState() {
    super.initState();
    _connectivityStream =
        Connectivity().onConnectivityChanged.map((event) => event.first);
  }

  // Función para combinar los dos streams
  Stream<Map<String, dynamic>> _combineStreams(
    Stream<QuerySnapshot<Map<String, dynamic>>> templatesStream,
    Stream<ConnectivityResult> connectivityStream,
  ) {
    return Stream<Map<String, dynamic>>.multi((controller) {
      StreamSubscription? connectivitySubscription;
      StreamSubscription? templatesSubscription;

      // Suscribirse al stream de conectividad
      connectivitySubscription = connectivityStream.listen((connectivity) {
        controller.add({'connectivity': connectivity});
      });

      // Suscribirse al stream de templates
      templatesSubscription = templatesStream.listen((templates) {
        controller.add({'templates': templates});
      });

      // Cancelar las suscripciones cuando se cierre el stream
      controller.onCancel = () {
        connectivitySubscription?.cancel();
        templatesSubscription?.cancel();
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Consumer<CategoryController>(
        builder: (context, categoryController, child) {
          // Llamamos a getTemplatesByCategory aquí
          final templatesStream =
              categoryController.getTemplatesByCategory(widget.category);
          _combinedStream =
              _combineStreams(templatesStream, _connectivityStream);

          return StreamBuilder<Map<String, dynamic>>(
            stream: _combinedStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: const CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Text('Error de conectividad');
              }

              if (!snapshot.hasData) {
                return const Text('No data available');
              }

              final connectivity = snapshot.data!['connectivity'];
              final templateSnapshot = snapshot.data!['templates'];

              if (connectivity == ConnectivityResult.none) {
                return const Text('Error de conectividad');
              }

              return _categoryBody(
                  widget.type, templateSnapshot, categoryController);
            },
          );
        },
      ),
    );
  }

  Widget _categoryBody(
      String categoryType,
      QuerySnapshot<Map<String, dynamic>> snapshot,
      CategoryController categoryController) {
    return Consumer<SuscriptionProvider>(
      builder: (context, subscriptionProvider, child) {
        if (categoryType == 'Free' ||
            subscriptionProvider.isSuscribed == true) {
          return Material(
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  'Category',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              body: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _categoryTypeContent(widget.category),
                      showTemplates(snapshot, categoryController),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else if (categoryType == 'Premium') {
          return const SplashSuscribe(
            widgetScreen: Home(),
            titleSuscription: 'Your Subscription has Expired',
          );
        } else {
          return const Material();
        }
      },
    );
  }

  Widget showTemplates(QuerySnapshot<Map<String, dynamic>> snapshot,
      CategoryController categoryController) {
    if (snapshot.docs.isEmpty) {
      return const Text('No data available');
    }

    final documents = snapshot.docs;
    final totalPages =
        (documents.length / categoryController.itemsPerPage).ceil();

    categoryController.currentPage =
        min(categoryController.currentPage, totalPages - 1);
    categoryController.currentPage =
        categoryController.currentPage.clamp(0, totalPages - 1);

    final startIndex = max(
      0,
      categoryController.currentPage * categoryController.itemsPerPage,
    );
    final filteredDocs = documents.sublist(
      startIndex,
      min(startIndex + categoryController.itemsPerPage, documents.length),
    );

    return SizedBox(
      height: MediaQuery.of(context).size.height * .8,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: filteredDocs.length,
              itemBuilder: (context, index) {
                final doc = filteredDocs[index];
                final imageUrl = doc['image'] ?? '';
                if (imageUrl.isEmpty) {
                  return const Icon(Icons.error);
                }
                return _categoryCard(imageUrl);
              },
            ),
          ),
          NumberPaginator(
            config: NumberPaginatorUIConfig(
              buttonSelectedBackgroundColor:
                  Theme.of(context).colorScheme.onTertiary,
            ),
            numberPages: totalPages,
            initialPage: categoryController.currentPage,
            onPageChange: (index) =>
                setState(() => categoryController.currentPage = index),
          ),
        ],
      ),
    );
  }

  Widget _categoryTypeContent(String title) {
    return Container(
      height: 51,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onTertiary,
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _categoryCard(String imageUrl) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Template(
              image: imageUrl,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: aDefaultPadding * 2,
          vertical: aDefaultPadding,
        ),
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: BorderDirectional(
                top: BorderSide(color: Colors.black12, width: 2)),
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                offset: Offset(0, 10),
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ],
          ),
          child: FutureBuilder(
            future: _loadImage(imageUrl),
            builder: (context, imageSnapshot) {
              if (imageSnapshot.connectionState == ConnectionState.waiting) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: imageUrl.startsWith('http')
                      ? CachedNetworkImage(
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          placeholder: (context, url) => ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.asset(
                              'asset/bg_01.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          height: 210,
                        )
                      : Image.asset(
                          'asset/bg_01.jpg',
                          fit: BoxFit.cover,
                        ),
                );
              } else if (imageSnapshot.hasError) {
                return const Icon(Icons.error);
              }

              return imageUrl.startsWith('http')
                  ? CachedNetworkImage(
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      placeholder: (context, url) => ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.asset(
                          'asset/bg_01.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      imageUrl: imageUrl,
                      fit: BoxFit.fitHeight,
                      height: 210,
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.asset(
                        imageUrl,
                        fit: BoxFit.cover,
                        height: 210,
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _loadImage(String imageUrl) async {
    if (imageUrl.isEmpty) {
      print("La URL de la imagen está vacía.");
      return;
    }

    try {
      if (imageUrl.startsWith('http')) {
        await precacheImage(NetworkImage(imageUrl), context);
      } else {
        await precacheImage(AssetImage(imageUrl), context);
      }
    } catch (e) {
      print("Error al precargar la imagen: $e");
    }
  }
}
 */









/*
class Category extends StatefulWidget {
  const Category({
    super.key,
    required this.category,
    required this.type,
  });

  final String category;
  final String type;

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  late Stream<Map<String, dynamic>> _combinedStream;

  @override
  void initState() {
    super.initState();
    _combinedStream =
        context.read<CategoryController>().combinedStream(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    print(widget.category);
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Consumer<CategoryController>(
        builder: (context, categoryController, child) {
          return StreamBuilder<Map<String, dynamic>>(
            stream: _combinedStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: const CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return _buildErrorView('Error de Conectividad');
              }

              if (!snapshot.hasData) {
                return _buildErrorView('No data available');
              }

              final connectivity = snapshot.data!['connectivity'];
              final templateSnapshot = snapshot.data!['templates'];

              if (connectivity == ConnectivityResult.none) {
                return const Text('Error de conectividad');
              }

              return _categoryBody(
                  widget.type, templateSnapshot, categoryController);
            },
          );
        },
      ),
    );
  }

  Widget _buildErrorView(String message) {
    return Center(
      child: Text(message),
    );
  }

  Widget _categoryBody(
      String categoryType,
      QuerySnapshot<Map<String, dynamic>> snapshot,
      CategoryController categoryController) {
    return Consumer<SuscriptionProvider>(
      builder: (context, subscriptionProvider, child) {
        if (categoryType == 'Free' ||
            subscriptionProvider.isSuscribed == true) {
          return Material(
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  'Category',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              body: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _categoryTypeContent(widget.category),
                      showTemplates(snapshot, categoryController),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else if (categoryType == 'Premium') {
          return const SplashSuscribe(
            widgetScreen: Home(),
            titleSuscription: 'Your Subscription has Expired',
          );
        } else {
          return const Material();
        }
      },
    );
  }

  Widget showTemplates(QuerySnapshot<Map<String, dynamic>> snapshot,
      CategoryController categoryController) {
    if (snapshot.docs.isEmpty) {
      return const Text('No data available');
    }

    final documents = snapshot.docs;
    final filteredDocs = categoryController.getFilteredTemplates(documents);
    return SizedBox(
      height: MediaQuery.of(context).size.height * .8,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: filteredDocs.length,
              itemBuilder: (context, index) {
                final doc = filteredDocs[index];
                final imageUrl = doc['image'] ?? '';
                if (imageUrl.isEmpty) {
                  return const Icon(Icons.error);
                }
                return _categoryCard(imageUrl);
              },
            ),
          ),
          NumberPaginator(
            config: NumberPaginatorUIConfig(
              buttonSelectedBackgroundColor:
                  Theme.of(context).colorScheme.onTertiary,
            ),
            numberPages: filteredDocs.length,
            initialPage: categoryController.currentPage,
            onPageChange: (index) =>
                setState(() => categoryController.currentPage = index),
          ),
        ],
      ),
    );
  }

  Widget _categoryTypeContent(String title) {
    return Container(
      height: 51,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onTertiary,
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _categoryCard(String imageUrl) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Template(
              image: imageUrl,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: aDefaultPadding * 2,
          vertical: aDefaultPadding,
        ),
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: BorderDirectional(
                top: BorderSide(color: Colors.black12, width: 2)),
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                offset: Offset(0, 10),
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ],
          ),
          child: FutureBuilder(
            future: _loadImage(imageUrl),
            builder: (context, imageSnapshot) {
              if (imageSnapshot.connectionState == ConnectionState.waiting) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: imageUrl.startsWith('http')
                      ? CachedNetworkImage(
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          placeholder: (context, url) => ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.asset(
                              'asset/bg_01.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          height: 210,
                        )
                      : Image.asset(
                          'asset/bg_01.jpg',
                          fit: BoxFit.cover,
                        ),
                );
              } else if (imageSnapshot.hasError) {
                return const Icon(Icons.error);
              }

              return imageUrl.startsWith('http')
                  ? CachedNetworkImage(
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      placeholder: (context, url) => ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.asset(
                          'asset/bg_01.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      imageUrl: imageUrl,
                      fit: BoxFit.fitHeight,
                      height: 210,
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.asset(
                        imageUrl,
                        fit: BoxFit.cover,
                        height: 210,
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _loadImage(String imageUrl) async {
    if (imageUrl.isEmpty) {
      print("La URL de la imagen está vacía.");
      return;
    }

    try {
      if (imageUrl.startsWith('http')) {
        await precacheImage(NetworkImage(imageUrl), context);
      } else {
        await precacheImage(AssetImage(imageUrl), context);
      }
    } catch (e) {
      print("Error al precargar la imagen: $e");
    }
  }
}


 */