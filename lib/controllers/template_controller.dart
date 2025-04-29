import 'package:templates_flutter_app/models/template_model.dart';
import 'package:templates_flutter_app/providers/suscription_provider.dart';
import 'package:templates_flutter_app/services/ad_services.dart';
import 'package:templates_flutter_app/services/template_data_services.dart';

class TemplateController {
  final TemplateDataService _dataService;
  final AdService _admobServices;
  final SuscriptionProvider _subscriptionProvider;

  TemplateController(
    this._dataService,
    this._admobServices,
    this._subscriptionProvider,
  );

  Future<TemplateModel> getTemplateData(String image) async {
    final name = await _dataService.fetchNameTemplate(image);
    final url = await _dataService.fetchUrlTemplate(image);
    final nameImage = await _dataService.fetchGetNameImage(image);

    return TemplateModel(
      name: name ?? "",
      url: url ?? "",
      nameImage: nameImage ?? "",
    );
  }

  Future<void> downloadImage(String image) async {
    if (!_subscriptionProvider.isSuscribed) {
      await _admobServices.showRewardedAd();
    }
    await _dataService.fetchDownloadImage(image);
  }

  Future<void> saveUrlTemplate(String url) async {
    if (!_subscriptionProvider.isSuscribed) {
      await _admobServices.showRewardedAd();
    }
    await _dataService.fetchSaveUrlTemplate(url);
  }

  Future<String?> accessDemo(String image) async {
    if (!_subscriptionProvider.isSuscribed) {
      await _admobServices.showRewardedAd();
    }
    return _dataService.accessDemo(image);
  }
}
