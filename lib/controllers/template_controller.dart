import 'package:templates_flutter_app/services/template_data_services.dart';

class TemplateController {
  final TemplateDataService _dataService;

  TemplateController(this._dataService);

  // Método para obtener los datos de la plantilla
  Future<Map<String, String>> getTemplateData(String image) async {
    final name = await _dataService.fetchNameTemplate(image);
    final url = await _dataService.fetchUrlTemplate(image);
    final nameImage = await _dataService.fetchGetNameImage(image);

    return {
      'name': name ?? "",
      'url': url ?? "",
      'nameImage': nameImage ?? "",
    };
  }

  // Método para descargar la imagen
  Future<void> downloadImage(String image) async {
    await _dataService.fetchDownloadImage(image);
  }

  // Método para guardar la URL del repositorio
  Future<void> saveUrlTemplate(String url) async {
    await _dataService.fetchSaveUrlTemplate(url);
  }

  // Método para acceder a la demo
  Future<String?> accessDemo(String image) async {
    return _dataService.accessDemo(image);
  }
}