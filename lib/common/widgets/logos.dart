import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildLogo() {
  return SizedBox(
    height: 100.h,
    width: 200.w,
    child: FittedBox(
      fit: BoxFit.cover,
      child: Image.asset('assets/images/check&close_logo.png'),
    ),
  );
}
