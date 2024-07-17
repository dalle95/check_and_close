import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '/common/routes/names.dart';

import '/common/widgets/background_view.dart';
import '/common/widgets/buttons.dart';
import '/common/widgets/text_base.dart';

import 'package:check_and_close/common/widgets/logos.dart';

class ConfigurationPage extends StatefulWidget {
  const ConfigurationPage({super.key});

  @override
  State<ConfigurationPage> createState() => _ConfigurationPage();
}

class _ConfigurationPage extends State<ConfigurationPage> {
  void _qrCodePage(BuildContext context) {
    Navigator.of(context).pushNamed(
      AppRoutes.QRCODE_READING,
      arguments: AppRoutes.CONFIGURATION,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundView(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Gap(75.h),
                  buildLogo(),
                  Gap(70.h),
                  reusableTitleText(
                    'Configurazione',
                    fontSize: 20,
                    color: Colors.white70,
                    fontWeight: FontWeight.normal,
                  ),
                  Gap(30.h),
                  buildElevatedButtonWithImage(
                    title: "Scannerizza il QR Code per collegarti all'ambiente",
                    imagePath: "assets/icons/qr-code.png",
                    function: () => _qrCodePage(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
