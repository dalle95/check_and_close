import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/common/values/colors.dart';

// TextField custom da usare in tutta l'app
Widget buildTextField({
  String? hintText,
  String? textType,
  String? iconName,
  Color? foregroundColor = AppColors.secondaryElementText,
  void Function(String value)? func,
  int? maxLines = 1,
  TextEditingController? controller,
  bool autofocus = false,
}) {
  return Container(
    width: 300.w,
    height: 50.h,
    margin: EdgeInsets.only(bottom: 20.h),
    padding: EdgeInsets.only(top: 0.h, bottom: 0.h),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(
        Radius.circular(15.r),
      ),
      border: Border.all(color: AppColors.thirdElementText),
    ),
    child: Row(
      children: [
        Container(
          width: 16.w,
          margin: EdgeInsets.only(left: 17.w),
          height: 16.w,
          child: Image.asset("assets/icons/$iconName.png"),
        ),
        SizedBox(
          width: 245.w,
          height: 50.h,
          child: appTextField(
            hintText ?? "Scrivi qui",
            textType ?? "Normale",
            func: func,
            foregroundColor: foregroundColor,
            maxLines: maxLines,
            controller: controller,
            autofocus: autofocus,
          ),
        )
      ],
    ),
  );
}

Widget appTextField(
  String hintText,
  String textType, {
  void Function(String value)? func,
  Color? foregroundColor = AppColors.secondaryElementText,
  int? maxLines = 1,
  TextEditingController? controller,
  bool autofocus = false,
}) {
  return TextField(
    controller: controller,
    onChanged: (value) => func != null ? func(value) : {},
    keyboardType: TextInputType.multiline,
    maxLines: maxLines,
    autofocus: autofocus,
    decoration: InputDecoration(
      hintText: hintText,
      border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent)),
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent)),
      disabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent)),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent)),
      hintStyle: TextStyle(
        color: foregroundColor,
      ),
    ),
    style: TextStyle(
      color: AppColors.secondaryElementText,
      fontFamily: "Avenir",
      fontWeight: FontWeight.normal,
      fontSize: 14.sp,
    ),
    autocorrect: false,
    obscureText: textType == "password" ? true : false,
  );
}
