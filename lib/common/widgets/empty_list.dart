import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildEmptyListView(String message) {
  return Center(
    child: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 100.h,
            width: 200.w,
            margin: EdgeInsets.only(bottom: 20.h),
            child: FittedBox(
              fit: BoxFit.contain,
              child: Image.asset('assets/icons/not-found.png'),
            ),
          ),
          Text(
            message,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
