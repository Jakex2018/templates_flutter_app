// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:templates_flutter_app/screens/template/widget/template_web_app.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:templates_flutter_app/constants.dart';

class TemplateDataService {
  Future<void> getData(
      TemplateDataService dataService,
      String image,
      Function setState,
      String name,
      String urlRepository,
      String nameImage) async {
    final getNameTemplate = await dataService.fetchNameTemplate(image);
    final fetchUrlTemplate = await dataService.fetchUrlTemplate(image);
    final fetchGetNameImage = await dataService.fetchGetNameImage(image);
    setState(() {
      name = getNameTemplate ?? "";
      urlRepository = fetchUrlTemplate ?? "";
      nameImage = fetchGetNameImage ?? "";
    });
  }

  Future<WebApp?> accessDemo(String image) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('templates')
        .where('image', isEqualTo: image)
        .get();
    if (snapshot.docs.isNotEmpty) {
      final url = snapshot.docs[0].get('urlDemo');
      return WebApp(url: url);
    } else {
      return null;
    }
  }

  Future<String?> fetchGetNameImage(String image) async {
    try {
      final doc = FirebaseFirestore.instance
          .collection('templates')
          .where('image', isEqualTo: image)
          .get();
      final url = await doc;

      return url.docs[0].get('image');
    } catch (error) {
      print("error fetching name:$error");
    }
    return null;
  }

  Future<void> fetchDownloadImage(String url) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filename = '${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File('${directory.path}/$filename');
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
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

  Future<void> saveImageToGallery(File image) async {
    final bytes = await image.readAsBytes();
    final result = await ImageGallerySaver.saveImage(bytes);
    if (result['isSuccess']) {
      print('Imagen guardada exitosamente en la galería.');
    } else {
      print('Error al guardar la imagen en la galería.');
    }
  }

  Future<String?> fetchNameTemplate(String image) async {
    try {
      final doc = FirebaseFirestore.instance
          .collection('templates')
          .where('image', isEqualTo: image)
          .limit(1)
          .get();
      final name = await doc;

      return name.docs[0].data()['name'];
    } catch (error) {
      print("erro fetching name:$error");
    }
    return null;
  }

  Future<String?> fetchUrlTemplate(String image) async {
    try {
      final doc = FirebaseFirestore.instance
          .collection('templates')
          .where('image', isEqualTo: image)
          .limit(1)
          .get();
      final url = await doc;

      return url.docs[0].data()['urlRepository'];
    } catch (error) {
      print("erro fetching name:$error");
    }
    return null;
  }

  Future<void> fetchSaveUrlTemplate(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      Fluttertoast.showToast(
        msg: "Error al descargar la plantilla",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 4,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 18.0,
      );
    }
  }
}
