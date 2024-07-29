// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:templates_flutter_app/screens/home/widget/home_background.dart';
import 'package:templates_flutter_app/screens/template/services/template_data_services.dart';
import 'package:templates_flutter_app/screens/template/widget/template_body.dart';

class Template extends StatefulWidget {
  const Template({super.key, required this.image});
  final String image;

  @override
  State<Template> createState() => _TemplateState();
}

class _TemplateState extends State<Template> {
  final TemplateDataService _dataService = TemplateDataService();
  String _name = "";
  String _urlRepository = "";
  String _nameImage = "";
  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    final getNameTemplate = await _dataService.fetchNameTemplate(widget.image);
    final fetchUrlTemplate = await _dataService.fetchUrlTemplate(widget.image);
    final fetchGetNameImage =
        await _dataService.fetchGetNameImage(widget.image);
    setState(() {
      _name = getNameTemplate ?? "";
      _urlRepository = fetchUrlTemplate ?? "";
      _nameImage = fetchGetNameImage ?? "";
    });
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
          fetchDownloadImage: _dataService.fetchDownloadImage,
          image: widget.image,
          title: _name,
          url: _urlRepository,
          nameImg: _nameImage,
          fetchSaveUrlTemplate: _dataService.fetchSaveUrlTemplate,
          accessDemo: _dataService.accessDemo(widget.image),
        )
      ]),
    );
  }
}