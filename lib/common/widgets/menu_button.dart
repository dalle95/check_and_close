import 'package:check_and_close/common/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildMenuButton({
  void Function()? function,
  String imagePath = "assets/images/check&close_logo.png",
}) {
  return SafeArea(
    child: Align(
      alignment: Alignment.topRight,
      child: IconButton(
        icon: const Icon(
          Icons.settings,
          size: 30,
          color: Colors.white,
        ),
        onPressed: function,
      ),
    ),
  );
}

Widget buildBackButton(BuildContext context) {
  return SafeArea(
    child: Align(
      alignment: Alignment.topLeft,
      child: Container(
        height: 40.h,
        width: 40.w,
        alignment: Alignment.center,
        margin: EdgeInsets.only(
          top: 10.h,
          left: 15.h,
        ),
        child: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 30.sp,
            color: AppColors.primaryBackground,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    ),
  );
}
