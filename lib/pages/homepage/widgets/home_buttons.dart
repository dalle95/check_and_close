import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildElevatedIconButton({
  String title = "Clicca qui",
  void Function()? function,
  IconData icon = Icons.twenty_two_mp_sharp,
}) {
  return SizedBox(
    height: 80.h,
    width: 300.w,
    child: ElevatedButton.icon(
      icon: Icon(
        icon,
        size: 30.h,
      ),
      label: Text(
        title,
        style: TextStyle(fontSize: 20.sp),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: 25.w,
          vertical: 25.h,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r), // Più squadrato
        ),
        elevation: 10,
      ),
      onPressed: function,
    ),
  );
}
