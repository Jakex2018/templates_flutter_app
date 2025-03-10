/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeType extends StatelessWidget {
  const HomeType({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Object?>>(
        stream: FirebaseFirestore.instance.collection('categories').where('type').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          final data = snapshot.data!.docs.first;
          final type = data['type'];
          return Positioned(
              top: 0.h,
              right: 0.w,
              child: Transform(
                alignment: Alignment.center, // Rotate around center
                transform: Matrix4.identity()..rotateZ(pi / 2),
                child: Container(
                  padding: EdgeInsets.all(13.0.sp),
                  decoration: BoxDecoration(
                    color: type == 'Free' ? Colors.red : Colors.blue,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateZ(-pi / 4),
                    child: SizedBox(
                      height: 40.h,
                      child: Text(
                        type,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ));
        });
  }
}

 */