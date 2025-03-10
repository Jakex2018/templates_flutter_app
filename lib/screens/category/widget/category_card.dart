import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:templates_flutter_app/constants.dart';
import 'package:templates_flutter_app/screens/category/widget/error_category_image.dart';
import 'package:templates_flutter_app/screens/template/template_app.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CategoryCard extends StatefulWidget {
  const CategoryCard({
    super.key,
    required this.image,
  });

  final String image;

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityResult>(
        stream: Connectivity()
            .onConnectivityChanged
            .map((results) => results.first),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Error de conectividad');
          }

          return GestureDetector(
              onTap: () {
                if (snapshot.data != ConnectivityResult.none) {
                
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Template(
                        image: widget.image,
                      ),
                    ),
                  );
                  
                } else if (snapshot.data == ConnectivityResult.none) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Error Network'),
                        content: const Text('Please Connet your Internet.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: snapshot.data == ConnectivityResult.none
                  ? const ErrorCategoryImage()
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: aDefaultPadding * 2,
                        vertical: aDefaultPadding,
                      ),
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.sp),
                            border: BorderDirectional(
                                top: BorderSide(
                                    color: Colors.black12, width: 2.w)),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 10.sp,
                                offset: Offset(0, 10.sp),
                                color: Colors.black26,
                              )
                            ]),
                        child: FutureBuilder(
                          future: precacheImage(
                            NetworkImage(widget.image),
                            context,
                          ),
                          builder: (context, snapshot) {
                            return CachedNetworkImage(
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              placeholder: (context, url) => ClipRRect(
                                  borderRadius: BorderRadius.circular(30.sp),
                                  child: Image.asset(
                                    'asset/bg_01.jpg',
                                    fit: BoxFit.cover,
                                  )),
                              imageUrl: widget.image,
                              fit: BoxFit.fitHeight,
                              height: 210.h,
                            );
                          },
                        ),
                      ),
                    ));
        });
  }
}
