import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/common/values/colors.dart';

// Testo per i titoli
Widget reusableTitleText(
  String text, {
  Color color = AppColors.primaryElementText,
  double fontSize = 20,
  FontWeight fontWeight = FontWeight.bold,
  FontStyle fontStyle = FontStyle.normal,
}) {
  return Text(
    text,
    style: TextStyle(
      color: color,
      fontWeight: fontWeight,
      fontSize: fontSize.sp,
      fontStyle: fontStyle,
    ),
  );
}

// Testo normale
Widget reusableBodyText(
  String text, {
  Color color = AppColors.secondaryElementText,
  double fontSize = 12,
  FontWeight fontWeight = FontWeight.normal,
  TextAlign textAlign = TextAlign.left,
}) {
  return Text(
    text,
    textAlign: textAlign,
    style: TextStyle(
      color: color,
      fontWeight: fontWeight,
      fontSize: fontSize.sp,
    ),
  );
}

// Testo per i sotto titoli
Widget reusableSmallText(
  String text, {
  Color color = AppColors.thirdElementText,
  double fontSize = 10,
  FontWeight fontWeight = FontWeight.normal,
}) {
  return Text(
    text,
    style: TextStyle(
      color: color,
      fontWeight: fontWeight,
      fontSize: fontSize.sp,
    ),
  );
}
