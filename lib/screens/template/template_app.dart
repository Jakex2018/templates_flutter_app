// ignore_for_file: avoid_print
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:templates_flutter_app/constants.dart';
import 'package:templates_flutter_app/screens/home/widget/home_background.dart';
import 'package:templates_flutter_app/screens/template/widget/template_body.dart';
import 'package:path_provider/path_provider.dart';

class Template extends StatefulWidget {
  const Template({super.key, required this.image});
  final String image;

  @override
  State<Template> createState() => _TemplateState();
}

class _TemplateState extends State<Template> {
  String _name = "";
  String _urlRepository = "";
  String _nameImage = "";
  @override
  void initState() {
    super.initState();
    _fetchNameTemplate(widget.image);
    _fetchUrlTemplate(widget.image);
    _fetchSaveUrlTemplate(_urlRepository);
    _fetchGetNameImage(widget.image);
  }

  Future<String?> _fetchGetNameImage(String image) async {
    try {
      final doc = FirebaseFirestore.instance
          .collection('templates')
          .where('image', isEqualTo: image)
          .get();
      final url = await doc;

      setState(() {
        _nameImage = url.docs[0].get('image');
      });
    } catch (error) {
      print("error fetching name:$error");
    }
    return null;
  }

  Future<void> _fetchDownloadImage(String url) async {
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

  Future<void> _fetchNameTemplate(String image) async {
    try {
      final doc = FirebaseFirestore.instance
          .collection('templates')
          .where('image', isEqualTo: image)
          .limit(1)
          .get();
      final name = await doc;

      setState(() {
        _name = name.docs[0].data()['name'] as String;
      });
    } catch (error) {
      print("erro fetching name:$error");
    }
  }

  Future<void> _fetchUrlTemplate(String image) async {
    try {
      final doc = FirebaseFirestore.instance
          .collection('templates')
          .where('image', isEqualTo: image)
          .limit(1)
          .get();
      final url = await doc;

      setState(() {
        _urlRepository = url.docs[0].data()['urlRepository'] as String;
      });
    } catch (error) {
      print("erro fetching name:$error");
    }
  }

  Future<void> _fetchSaveUrlTemplate(String url) async {
    try {
      final storageRef = FirebaseStorage.instance.refFromURL(url);
      final bytes = await storageRef.getData();

      final path = await getApplicationDocumentsDirectory();
      final filename = url.split("/").last;
      print(filename);
      final savedFile =
          await File('${path.path}/$filename').writeAsBytes(bytes as List<int>);
      Fluttertoast.showToast(
          msg: "Codigo Descargado Correctamente\nen tu dispositivo",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 4,
          backgroundColor: kblueColor,
          textColor: Colors.white,
          fontSize: 18.0);
      print('plantilla guardada correctamente: ${savedFile.path}');
    } catch (error) {
      print("Error al descargar y guardar la plantilla: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(children: [
        HomeBackground(
          onPressed: () => Navigator.of(context).pop(),
          sidebarIcon: Icons.arrow_back_ios_new_outlined,
        ),
        TemplateBody(
          fetchDownloadImage: _fetchDownloadImage,
          image: widget.image,
          title: _name,
          url: _urlRepository,
          nameImg: _nameImage,
        )
      ]),
    );
  }
}
