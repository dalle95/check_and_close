import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '/common/entities/material.dart' as custom;

import '/common/routes/names.dart';

import '/common/values/colors.dart';

import '/common/widgets/container_base.dart';
import '/common/widgets/logos.dart';
import '/common/widgets/text_base.dart';
import '/common/widgets/empty_list.dart';

import '/pages/homepage/widgets/home_buttons.dart';

Widget homePrincipale(
  BuildContext context,
  void Function()? qrCodePage,
  void Function()? nfcReaderPage,
) {
  return SingleChildScrollView(
    child: Column(
      children: [
        Gap(150.h),
        buildLogo(),
        Gap(100.h),
        reusableTitleText(
          'Seleziona un\'azione',
          fontSize: 20.sp,
          fontWeight: FontWeight.normal,
        ),
        Gap(20.h),
        buildElevatedIconButton(
          title: 'Rileva QR Code',
          function: qrCodePage,
          icon: Icons.qr_code,
        ),
        Gap(20.h),
        buildElevatedIconButton(
          title: 'Rileva NFC',
          function: nfcReaderPage,
          icon: Icons.nfc,
        ),
      ],
    ),
  );
}

Widget homePianificazione(
  BuildContext context,
  List<custom.Material>? lista,
) {
  return Column(
    children: [
      Gap(70.h),
      reusableTitleText(
        'Asset con manutenzioni da fare',
        fontSize: 20.sp,
        fontWeight: FontWeight.normal,
      ),
      assetsList(lista),
    ],
  );
}

// Costruzione della linguetta in fondo alla pagina
Widget buildBottomTab(
  PageController pageController,
  int pageIndex,
) {
  return Positioned(
    bottom: 0,
    left: 100.w,
    right: 100.w,
    child: GestureDetector(
      onTap: () {
        // Naviga alla pagina successiva/precedente
        if (pageIndex == 0) {
          pageController.animateToPage(
            1,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
          );
        } else {
          pageController.animateToPage(
            0,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
          );
        }
      },
      child: Container(
        height: 55.h,
        decoration: BoxDecoration(
          color: AppColors.primaryBackground,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.r),
            topRight: Radius.circular(40.r),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              pageIndex == 0
                  ? Icons.keyboard_arrow_down
                  : Icons.keyboard_arrow_up,
              color: AppColors.fourthElementText,
            ),
            Text(
              pageIndex == 0 ? "Vai alla Pianificazione" : "Torna alla Home",
              style: const TextStyle(color: AppColors.fourthElementText),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}

Widget assetsList(List<custom.Material>? lista) {
  return BaseContainer(
    height: 550.h,
    width: 325.w,
    margin: EdgeInsets.only(top: 15.h),
    color: Colors.white,
    child: lista!.isEmpty
        ? buildEmptyListView(
            "Non sono presenti asset associati a manutenzioni.")
        : ListView.builder(
            shrinkWrap: true,
            itemCount: lista.length,
            itemBuilder: (context, index) {
              return assetsItem(
                context: context,
                asset: lista[index],
              );
            },
          ),
  );
}

Widget assetsItem({
  required BuildContext context,
  custom.Material? asset,
}) {
  // Definisco i dati da passare alla prossima pagina
  final arguments = {
    "page": AppRoutes.HOME_PAGE,
    "assetCodice": asset!.code!,
  };
  return Card(
    elevation: 1,
    margin: EdgeInsets.symmetric(
      horizontal: 10.w,
      vertical: 5.h,
    ),
    child: Padding(
      padding: EdgeInsets.all(5.0.dg),
      child: ListTile(
        onTap: () {
          Navigator.of(context).pushNamed(
            AppRoutes.WO_LIST,
            arguments: arguments,
          );
        },
        leading: SizedBox(
          height: 25.h,
          width: 25.w,
          child: FittedBox(
            fit: BoxFit.cover,
            child: Image.asset("assets/icons/asset.png"),
          ),
        ),
        title: Text(
          '${asset.descrizione}',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('[${asset.code}]'),
            Text('EqptType: ${asset.eqptType}'),
          ],
        ),
      ),
    ),
  );
}
