// ignore_for_file: avoid_print
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:templates_flutter_app/screens/template/widget/template_option.dart';
import 'package:templates_flutter_app/screens/template/widget/template_web_app.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:templates_flutter_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TemplateBody extends StatelessWidget {
  const TemplateBody(
      {super.key,
      required this.image,
      required this.title,
      required this.url,
      required this.nameImg,
      required this.fetchDownloadImage});
  final String image;
  final String title;
  final String url;
  final String nameImg;
  final Function(String) fetchDownloadImage;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: 41.h,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: kblueColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.sp),
                  topRight: Radius.circular(20.sp))),
          child: Center(
              child: Text(
            title,
            style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold),
          )),
        ),
        Container(
          height: 560.h,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                CachedNetworkImage(
                  placeholder: (context, url) => ClipRRect(
                      borderRadius: BorderRadius.circular(20.sp),
                      child: Image.asset('asset/bg_01.jpg')),
                  imageUrl: image,
                  fit: BoxFit.fitHeight,
                  height: 250.h,
                ),
                SizedBox(
                  height: 50.h,
                ),
                TemplateOption(
                  title: 'Download Image',
                  onTap: () async {
                    await fetchDownloadImage(image);
                  },
                  icon: const Icon(
                    Icons.download_for_offline_rounded,
                    color: Colors.black,
                    size: 40,
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                TemplateOption(
                    title: 'Source Code',
                    icon: const Icon(
                      Icons.code,
                      color: Colors.black,
                      size: 40,
                    ),
                    onTap: () {
                      url;
                    }),
                SizedBox(
                  height: 30.h,
                ),
                TemplateOption(
                  title: 'Demo',
                  icon: const Icon(
                    Icons.developer_mode,
                    color: Colors.black,
                    size: 40,
                  ),
                  onTap: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FutureBuilder(
                              future: accessDemo(),
                              builder: ((context, snapshot) {
                                if (snapshot.hasData) {
                                  return snapshot.data!;
                                } else if (snapshot.hasError) {
                                  return Text("Error ${snapshot.error}");
                                } else {
                                  return const CircularProgressIndicator();
                                }
                              })),
                        ));
                  },
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Future<WebApp?> accessDemo() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('templates')
        .where('urlDemo')
        .get();
    if (snapshot.docs.isNotEmpty) {
      final url =
          snapshot.docs[0].get('urlDemo'); // Use 'accessDemo' field here
      return WebApp(url: url);
    } else {
      return null;
    }
  }
}

/*
Future<void> downloadCode() async {
    final connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.none) {
      // No hay conexión a internet, muestra un mensaje de error al usuario

      return; // Evita la descarga si no hay conexión
    }

    final snapshot =
        await FirebaseFirestore.instance.collection('templates').get();
    if (snapshot.docs.isNotEmpty) {
      final url = snapshot.docs[0].get('urlRepository');
      if (url != null && url is String) {
        _launchUrl(url);
      }
    } else {
      throw 'No se encontro el documento';
    }
  }
 */

/**
  Future<void> saveImageToGallery(File image) async {
    final bytes = await image.readAsBytes();
    final result = await ImageGallerySaver.saveImage(bytes);
    if (result['isSuccess']) {
      print('Imagen guardada exitosamente en la galería.');
    } else {
      print('Error al guardar la imagen en la galería.');
    }
  }

  Future<String?> getDownloadImage(String templateImg) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('templates')
        .where('image', isEqualTo: templateImg)
        .get();
    if (snapshot.docs.isNotEmpty) {
      final url = snapshot.docs[0].get('image');
      return url;
    } else {
      return null;
    }
  }

  Future<void> downloadImage(String imageUrl, context) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final filename = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        final file = File('${directory.path}/$filename');
        await file.writeAsBytes(response.bodyBytes);
        Fluttertoast.showToast(
            msg: "Imagen Descargada Correctamente\nen tu dispositivo",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 4,
            backgroundColor: kblueColor,
            textColor: Colors.white,
            fontSize: 18.0);
        print('Imagen descargada exitosamente a: ${file.path}');
        await saveImageToGallery(file);
      } else {
        throw Exception('Error al descargar la imagen: ${response.statusCode}');
      }
    } on PlatformException catch (e) {
      throw Exception('Error al descargar la imagen: $e');
    } catch (e) {
      print('Error downloading image: $e'); // Generic error handling
    }
  }

 */