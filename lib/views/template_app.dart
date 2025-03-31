import 'package:flutter/material.dart';
import 'package:templates_flutter_app/controllers/template_controller.dart';
import 'package:templates_flutter_app/models/template_model.dart';
import 'package:templates_flutter_app/services/ad_services.dart';
import 'package:templates_flutter_app/services/template_data_services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:templates_flutter_app/providers/suscription_provider.dart';
import 'package:templates_flutter_app/widget/template_option.dart';
import 'package:templates_flutter_app/widget/web_app.dart';

class Template extends StatefulWidget {
  const Template({super.key, required this.image});
  final String image;

  @override
  State<Template> createState() => _TemplateState();
}

class _TemplateState extends State<Template> {
  late final TemplateController _templateController;
  TemplateModel? _templateModel;

  @override
  void initState() {
    super.initState();
    _templateController = TemplateController(
      TemplateDataService(),
      AdService(),
      SuscriptionProvider(),
    );
    _getData();
  }

  Future<void> _getData() async {
    await Future.delayed(Duration(seconds: 1));
    await _templateController.getTemplateData(widget.image);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: _templateImage(context),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'Template',
        style:
            TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
      ),
    );
  }

  Widget _templateImage(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Theme.of(context).colorScheme.secondary,
      child: SingleChildScrollView(
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: widget.image,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
              fit: BoxFit.fitHeight,
              height: MediaQuery.of(context).size.height * .4,
            ),
            const SizedBox(height: 50),
            TemplateOption(
              title: 'Download Image',
              onTap: () async {
                await _templateController.downloadImage(widget.image);
              },
              icon: Icon(
                Icons.download_for_offline_rounded,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                size: 40,
              ),
            ),
            const SizedBox(height: 30),
            TemplateOption(
              title: 'Source Code',
              icon: Icon(
                Icons.code,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                size: 40,
              ),
              onTap: () async {
                await _templateController.saveUrlTemplate(_templateModel!.url);
              },
            ),
            const SizedBox(height: 30),
            TemplateOption(
              title: 'Demo',
              icon: Icon(
                Icons.developer_mode,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                size: 40,
              ),
              onTap: () async {
                final urlDemo =
                    await _templateController.accessDemo(widget.image);
                if (urlDemo != null && context.mounted) {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebApp(url: urlDemo),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

/*

class Template extends StatefulWidget {
  const Template({super.key, required this.image});
  final String image;

  @override
  State<Template> createState() => _TemplateState();
}

class _TemplateState extends State<Template> {
  TemplateController? _templateController;
  TemplateModel? _templateModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_templateController == null) {
      final admobServices = context.read<AdService>();
      final subscriptionProvider = context.read<SuscriptionProvider>();
      final templateDataService = TemplateDataService();

      _templateController = TemplateController(
        templateDataService,
        admobServices,
        subscriptionProvider,
      );

      _getData();
    }
  }

  Future<void> _getData() async {
    final data = await _templateController!.getTemplateData(widget.image);
    setState(() {
      _templateModel = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: _templateImage(context),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'Template',
        style:
            TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
      ),
    );
  }

  Widget _templateImage(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Theme.of(context).colorScheme.secondary,
      child: SingleChildScrollView(
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: widget.image,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
              fit: BoxFit.fitHeight,
              height: MediaQuery.of(context).size.height * .4,
            ),
            const SizedBox(height: 50),
            TemplateOption(
              title: 'Download Image',
              onTap: () async {
                await _templateController!.downloadImage(widget.image);
              },
              icon: Icon(
                Icons.download_for_offline_rounded,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                size: 40,
              ),
            ),
            const SizedBox(height: 30),
            TemplateOption(
              title: 'Source Code',
              icon: Icon(
                Icons.code,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                size: 40,
              ),
              onTap: () async {
                await _templateController!.saveUrlTemplate(_templateModel!.url);
              },
            ),
            const SizedBox(height: 30),
            TemplateOption(
              title: 'Demo',
              icon: Icon(
                Icons.developer_mode,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                size: 40,
              ),
              onTap: () async {
                final urlDemo =
                    await _templateController!.accessDemo(widget.image);
                if (urlDemo != null && context.mounted) {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebApp(url: urlDemo),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
 */