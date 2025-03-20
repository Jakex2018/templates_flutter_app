// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:templates_flutter_app/controllers/template_controller.dart';
import 'package:templates_flutter_app/services/template_data_services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:templates_flutter_app/common/services/admob_services.dart';
import 'package:templates_flutter_app/providers/suscription_provider.dart';
import 'package:templates_flutter_app/widget/template_option.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Template extends StatefulWidget {
  const Template({super.key, required this.image});
  final String image;

  @override
  State<Template> createState() => _TemplateState();
}

class _TemplateState extends State<Template> {
  final TemplateDataService _dataService = TemplateDataService();
  TemplateController? _templateController;

  String _name = "";
  String _urlRepository = "";
  String _nameImage = "";

  @override
  void initState() {
    super.initState();
    _templateController = TemplateController(_dataService);
    _getData();
  }

  Future<void> _getData() async {
    final data = await _templateController!.getTemplateData(widget.image);
    setState(() {
      _name = data['name']!;
      _urlRepository = data['url']!;
      _nameImage = data['nameImage']!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        TemplateBody(
          image: widget.image,
          title: _name,
          url: _urlRepository,
          nameImg: _nameImage,
          accessDemo: _templateController!.accessDemo(widget.image),
          fetchDownloadImage: _templateController!.downloadImage,
          fetchSaveUrlTemplate: _templateController!.saveUrlTemplate,
        ),
      ],
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
}

class TemplateBody extends StatefulWidget {
  const TemplateBody({
    super.key,
    required this.image,
    required this.title,
    required this.url,
    required this.nameImg,
    required this.accessDemo,
    required this.fetchDownloadImage,
    required this.fetchSaveUrlTemplate,
  });

  final String image;
  final String title;
  final String url;
  final String nameImg;
  final Function(String) fetchDownloadImage;
  final Function(String) fetchSaveUrlTemplate;
  final Future<String?> accessDemo;

  @override
  State<TemplateBody> createState() => _TemplateBodyState();
}

class _TemplateBodyState extends State<TemplateBody> {
  late AdmobServices _admobServices;
  RewardedAd? rewardedAd;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _admobServices = context.read<AdmobServices>();
    _createRewardAd();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _templateName(context),
        _templateImage(context),
      ],
    );
  }

  Container _templateImage(BuildContext context) {
    final subscriptionProvider =
        Provider.of<SuscriptionProvider>(context, listen: false);
    return Container(
      height: MediaQuery.of(context).size.height * .82,
      width: MediaQuery.of(context).size.width,
      color: Theme.of(context).colorScheme.secondary,
      child: SingleChildScrollView(
        child: Column(
          children: [
            CachedNetworkImage(
              placeholder: (context, url) => ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset('asset/bg_01.jpg'),
              ),
              imageUrl: widget.image,
              fit: BoxFit.fitHeight,
              height: MediaQuery.of(context).size.height * .4,
            ),
            SizedBox(height: 50),
            TemplateOption(
              title: 'Download Image',
              onTap: () async {
                if (!subscriptionProvider.isSuscribed) {
                  await _showRewardAd();
                }
                await widget.fetchDownloadImage(widget.image);
              },
              icon: Icon(
                Icons.download_for_offline_rounded,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                size: 40,
              ),
            ),
            SizedBox(height: 30),
            TemplateOption(
              title: 'Source Code',
              icon: Icon(
                Icons.code,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                size: 40,
              ),
              onTap: () async {
                if (!subscriptionProvider.isSuscribed) {
                  await _showRewardAd();
                }
                await widget.fetchSaveUrlTemplate(widget.url);
              },
            ),
            SizedBox(height: 30),
            TemplateOption(
              title: 'Demo',
              icon: Icon(
                Icons.developer_mode,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                size: 40,
              ),
              onTap: () async {
                if (!subscriptionProvider.isSuscribed) {
                  await _showRewardAd();
                }
                final urlDemo = await widget.accessDemo;
                if (urlDemo != null) {
                  print("URL-------> $urlDemo");
                  if (context.mounted) {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WebApp(
                          url: urlDemo,
                        ),
                      ),
                    );
                  }
                } else {
                  print("URl NULL");
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Container _templateName(BuildContext context) {
    return Container(
      height: 53,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onTertiary,
      ),
      child: Center(
        child: Text(
          widget.title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _createRewardAd() {
    RewardedAd.load(
      adUnitId: _admobServices.rewardsAdUid!,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          setState(() {
            rewardedAd = ad;
          });
        },
        onAdFailedToLoad: (LoadAdError error) {
          setState(() {
            rewardedAd = null;
          });
        },
      ),
    );
  }

  Future<void> _showRewardAd() async {
    if (rewardedAd != null) {
      rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (RewardedAd ad) {
          ad.dispose();
          _createRewardAd();
        },
        onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
          ad.dispose();
          _createRewardAd();
        },
      );
      await rewardedAd!.show(
        onUserEarnedReward: (ad, reward) => ad.dispose(),
      );
    }
  }
}

class WebApp extends StatefulWidget {
  final String url;

  const WebApp({super.key, required this.url});

  @override
  State<WebApp> createState() => _WebAppState();
}

class _WebAppState extends State<WebApp> {
  late WebViewController controller;
  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Muestra una barra de progreso o algo similar
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {
            // Maneja errores de carga
            print("Error loading URL: ${error.description}");
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: controller);
  }
}
