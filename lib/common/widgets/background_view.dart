import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BackgroundView extends StatelessWidget {
  final Widget? child;
  const BackgroundView({
    this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 812.h,
      width: 375.w,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).secondaryHeaderColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: child,
    );
  }
}
