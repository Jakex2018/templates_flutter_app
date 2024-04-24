// ignore_for_file: avoid_print
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:templates_flutter_app/screens/template/widget/template_option.dart';
import 'package:templates_flutter_app/screens/template/widget/template_web_app.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:templates_flutter_app/constants.dart';

class TemplateBody extends StatelessWidget {
  const TemplateBody(
      {super.key,
      required this.image,
      required this.title,
      required this.url,
      required this.nameImg,
      required this.fetchDownloadImage,
      required this.fetchSaveUrlTemplate,
      required this.accessDemo});
  final String image;
  final String title;
  final String url;
  final String nameImg;
  final Function(String) fetchDownloadImage;
  final Function(String) fetchSaveUrlTemplate;
  final Future<WebApp?> accessDemo;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: 41.h,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: kblueColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.sp),
                  topRight: Radius.circular(20.sp))),
          child: Center(
              child: Text(
            title,
            style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold),
          )),
        ),
        Container(
          height: 560.h,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                CachedNetworkImage(
                  placeholder: (context, url) => ClipRRect(
                      borderRadius: BorderRadius.circular(20.sp),
                      child: Image.asset('asset/bg_01.jpg')),
                  imageUrl: image,
                  fit: BoxFit.fitHeight,
                  height: 250.h,
                ),
                SizedBox(
                  height: 50.h,
                ),
                TemplateOption(
                  title: 'Download Image',
                  onTap: () async {
                    await fetchDownloadImage(image);
                  },
                  icon: const Icon(
                    Icons.download_for_offline_rounded,
                    color: Colors.black,
                    size: 40,
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                TemplateOption(
                    title: 'Source Code',
                    icon: const Icon(
                      Icons.code,
                      color: Colors.black,
                      size: 40,
                    ),
                    onTap: () async {
                      await fetchSaveUrlTemplate(url);
                    }),
                SizedBox(
                  height: 30.h,
                ),
                TemplateOption(
                  title: 'Demo',
                  icon: const Icon(
                    Icons.developer_mode,
                    color: Colors.black,
                    size: 40,
                  ),
                  onTap: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FutureBuilder(
                              future: accessDemo,
                              builder: ((context, snapshot) {
                                if (snapshot.hasData) {
                                  return snapshot.data!;
                                } else if (snapshot.hasError) {
                                  return Text("Error ${snapshot.error}");
                                } else {
                                  return const CircularProgressIndicator();
                                }
                              })),
                        ));
                  },
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
