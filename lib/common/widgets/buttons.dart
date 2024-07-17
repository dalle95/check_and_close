import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '/common/values/colors.dart';

Widget buildElevatedButton({
  String title = "Clicca qui",
  void Function()? function,
  Color foregroudColor = AppColors.primaryElement,
}) {
  return SizedBox(
    width: 300.w,
    height: 60.h,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: 25.w,
          vertical: 10.h,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.h), // Più squadrato
        ),
        elevation: 10,
        foregroundColor: foregroudColor,
      ),
      onPressed: function,
      child: Text(
        title,
        style: TextStyle(fontSize: 20.sp),
      ),
    ),
  );
}

Widget buildElevatedButtonWithImage({
  String title = "Clicca qui",
  void Function()? function,
  String imagePath = "assets/images/check&close_logo.png",
}) {
  return ElevatedButton(
    onPressed: function,
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(
        horizontal: 25.w,
        vertical: 10.h,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.h), // Più squadrato
      ),
      elevation: 10,
    ),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
      height: 300.h,
      width: 200.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 150.h,
            width: 150.w,
            child: FittedBox(
              fit: BoxFit.cover,
              child: Image.asset(
                imagePath,
              ),
            ),
          ),
          Gap(20.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.sp,
            ),
          ),
        ],
      ),
    ),
  );
}
