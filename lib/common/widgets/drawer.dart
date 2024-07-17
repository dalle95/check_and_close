import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '/global.dart';

import '../values/label.dart';

import '/common/routes/names.dart';
import '/common/values/colors.dart';
import '/common/values/constant.dart';

import '/pages/auth/bloc/auth_blocs.dart';
import '/pages/auth/bloc/auth_events.dart';

import '/pages/homepage/bloc/home_blocs.dart';
import '/pages/homepage/bloc/home_events.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({super.key});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  // Definizione variabile per estrarre informazioni app
  late PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  late String _actorName = "Utente";

  // Funzione per estrarre le informazioni app
  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  // Funzione per estrarre le informazioni dell'utente
  Future<void> _initUserInfo() async {
    final user = await Global.storageService.getUserProfile();
    setState(() {
      _actorName = user.actorNome ?? "Utente";
    });
  }

  Widget buildListTile(Function()? tapHandler, IconData icon, String text,
      Color iconColor, Color textColor,
      [String subTitle = '']) {
    return GestureDetector(
      onTap: tapHandler,
      child: Container(
        padding: EdgeInsets.all(10.w),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(5.w),
              width: 30.w,
              height: 30.h,
              child: Icon(
                icon,
                size: 25.w,
                color: iconColor,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20.w),
              width: 200.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (subTitle != '') Text(subTitle),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
    _initUserInfo();
  }

  // Funzione per effetturare il logout
  void removeUserData(BuildContext context) {
    // Per eliminare lo stato del AuthBloc
    BlocProvider.of<AuthBloc>(context).add(const UsernameEvent(""));
    BlocProvider.of<AuthBloc>(context).add(const PasswordEvent(""));
    // Per resettare lo stato del HomeBloc
    BlocProvider.of<HomeBloc>(context).add(const HomeDatiEvent(
      assets: [],
      page: 0,
    ));

    // Per rimuover i dati di autenticazione salvati sul dispositivo
    Global.storageService.remove(AppConstants.STORAGE_USER_DATA);
    // Per tornare alla pagina di autenticazione
    Navigator.of(context)
        .pushNamedAndRemoveUntil(AppRoutes.AUTHENTICATION, (route) => false);
  }

  // Dialogo Logout
  void logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(labels.logout),
        content: Text(labels.disconnessioneMessaggio),
        actions: [
          TextButton(
            onPressed: () {
              removeUserData(context);
            },
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.background,
            ),
            child: Text(labels.conferma),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.background,
            ),
            child: Text(labels.annulla),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Drawer
    return Drawer(
      child: Column(
        children: [
          buildLogoDrawer(context),
          Gap(20.h),
          buildDivider(),
          buildListTile(
            () {},
            Icons.account_circle_rounded,
            labels.utente,
            Theme.of(context).colorScheme.primary,
            Colors.black,
            _actorName,
          ),
          buildListTile(
            () => logout(context),
            Icons.logout,
            labels.logout,
            Theme.of(context).colorScheme.primary,
            Colors.black,
          ),
          buildDivider(),
          const Expanded(child: SizedBox()),
          buildListTile(
            () {},
            Icons.info,
            labels.infoApp,
            Theme.of(context).colorScheme.primary,
            Colors.black,
            'Versione ${_packageInfo.version}',
          ),
          Gap(10.h),
        ],
      ),
    );
  }

  Container buildLogoDrawer(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(top: 40, left: 20),
      width: double.infinity,
      height: 130,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue,
            Color.fromRGBO(135, 59, 255, 1)
            // Theme.of(context).primaryColor,
            // Theme.of(context).secondaryHeaderColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SizedBox(
        width: 150,
        height: 70,
        child: FittedBox(
          fit: BoxFit.contain,
          child: Image.asset('assets/images/logo_dinova_dark.png'),
        ),
      ),
    );
  }

  Divider buildDivider() {
    return Divider(
      indent: 15.h,
      endIndent: 15.h,
      thickness: 2,
      color: AppColors.primaryElement,
    );
  }
}
