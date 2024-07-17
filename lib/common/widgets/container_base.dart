import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/common/values/colors.dart';

class BaseContainer extends StatelessWidget {
  final Widget? child;
  final Color? color;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? margin;

  const BaseContainer({
    required this.child,
    this.color = AppColors.primaryBackground,
    this.height = 50,
    this.width = 50,
    this.margin,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: child,
    );
  }
}
