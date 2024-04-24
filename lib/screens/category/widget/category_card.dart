import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:templates_flutter_app/constants.dart';
import 'package:templates_flutter_app/screens/template/template_app.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.image,
  });

  final String image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Template(image: image),
          ),
        );
      },
      child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: aDefaultPadding * 2,
            vertical: aDefaultPadding,
          ),
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.sp),
                border: BorderDirectional(
                    top: BorderSide(color: Colors.black12, width: 2.w)),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10.sp,
                    offset: Offset(0, 10.sp),
                    color: Colors.black26,
                  )
                ]),
            child: Stack(
              children: [
                CachedNetworkImage(
                  placeholder: (context, url) => ClipRRect(
                      borderRadius: BorderRadius.circular(20.sp),
                      child: Image.asset('asset/bg_01.jpg')),
                  imageUrl: image,
                  fit: BoxFit.fitHeight,
                  height: 210.h,
                ),
              ],
            ),
          )),
    );
  }
}
