class TemplateModel {
  final String name;
  final String url;
  final String nameImage;

  TemplateModel({
    required this.name,
    required this.url,
    required this.nameImage,
  });

  // Método fromJson
  factory TemplateModel.fromJson(Map<String, dynamic> json) {
    return TemplateModel(
      name: json['name'] as String, // Asegúrate de que 'name' exista en el JSON
      url: json['url'] as String, // Asegúrate de que 'url' exista en el JSON
      nameImage: json['nameImage']
          as String, // Asegúrate de que 'nameImage' exista en el JSON
    );
  }
}
