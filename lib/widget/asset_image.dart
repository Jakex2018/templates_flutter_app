// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageAsset extends StatelessWidget {
  const ImageAsset({
    super.key,
    required this.image,
    required this.height, this.format,this.fit,
  });
  final String? image,format;
  final BoxFit? fit;
  static List<ImageAsset>fromList(List<ImageAsset>imageAssets){
    return imageAssets.map((imageAsset){
        return ImageAsset(image: imageAsset.image ,height: 20.h, fit: BoxFit.cover,);
      }).toList();
  }
  final double height;
  @override
  Widget build(BuildContext context) {
    if (image != null) {
      return GestureDetector(
          onTap: () {},
          child: Image.asset(
            fit:fit,
            'asset/$image.$format',
            height: height,
          ));
    } else {
      // Devuelve un widget vacío
      return const SizedBox.shrink();
    }
  }
}
