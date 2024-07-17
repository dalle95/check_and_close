import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '/common/routes/names.dart';

import '/global.dart';

import '/pages/auth/auth_page.dart';
import '/pages/homepage/home_page.dart';
import '/pages/homepage/bloc/home_blocs.dart';
import '/pages/auth/bloc/auth_blocs.dart';
import '/pages/welcome/welcome_page.dart';
import '/pages/nfc_reader/nfc_reader_page.dart';
import '/pages/qrcode_reader/qrcode_reader_page.dart';
import '/pages/wo_detail/wo_detail_page.dart';
import '/pages/wo_list/wo_list_page.dart';
import '/pages/config/configuration_page.dart';
import '/pages/qrcode_reader/bloc/qrcode_r_blocs.dart';
import '/pages/wo_detail/bloc/wo_detail_blocs.dart';
import '/pages/wo_list/bloc/wo_list_blocs.dart';

class AppPages {
  /// Lista di routes, pagine e bloc unite
  static List<PageEntity> routes() {
    return [
      PageEntity(
        route: AppRoutes.INITIAL,
        page: const WelcomePage(),
      ),
      PageEntity(
        route: AppRoutes.CONFIGURATION,
        page: const ConfigurationPage(),
      ),
      PageEntity(
        route: AppRoutes.AUTHENTICATION,
        page: const AuthPage(),
        bloc: BlocProvider(
          create: (_) => AuthBloc(),
        ),
      ),
      PageEntity(
        route: AppRoutes.HOME_PAGE,
        page: const HomePage(),
        bloc: BlocProvider(
          create: (_) => HomeBloc(),
        ),
      ),
      PageEntity(
        route: AppRoutes.QRCODE_READING,
        page: const QrCodeReaderPage(),
        bloc: BlocProvider(
          create: (_) => QRCodeReaderBloc(),
        ),
      ),
      PageEntity(
        route: AppRoutes.NFC_READING,
        page: const NfcReaderPage(),
        // bloc: BlocProvider(
        //   create: (_) => RegisterBlocs(),
        // ),
      ),
      PageEntity(
        route: AppRoutes.WO_LIST,
        page: const WOListPage(),
        bloc: BlocProvider(
          create: (_) => WOListBloc(),
        ),
      ),
      PageEntity(
        route: AppRoutes.WO_DETAIL,
        page: const WODetailPage(),
        bloc: BlocProvider(
          create: (_) => WODetailBloc(),
        ),
      ),
    ];
  }

  /// Funzione per estrarre la lista dei bloc
  static List<dynamic> allBlocProviders(BuildContext context) {
    List<dynamic> blocProviders = <dynamic>[];
    // Itero per ogni routes per estrarre tutti i bloc
    for (var bloc in routes()) {
      // Controllo che il bloc esiste
      if (bloc.bloc != null) {
        // Aggiungo alla lista dei bloc
        blocProviders.add(bloc.bloc);
      }
    }
    return blocProviders;
  }

  ///Funzione per gestire il routing
  static Future<Widget> generateRouteSettings(RouteSettings settings) async {
    // Per gestire i log
    var logger = Logger();

    logger.d('Nome route: ${settings.name}');

    // Controllo se è presente il nome di una pagina
    if (settings.name != null) {
      // Controllo il match della route con il nome della pagina quando il navigator viene eseguito
      var result = routes().where(
        (element) => element.route == settings.name,
      );

      // Controllo sia presente una route associata
      if (result.isNotEmpty) {
        // Controllo se la route è quella iniziale
        if (result.first.route == AppRoutes.INITIAL) {
          // Estraggo la configurazione
          bool isConfigured =
              await Global.storageService.getUrlAmbiente() != null;

          logger.d('Configurazione presente? $isConfigured');
          // Controllo se la configurazione è già presente
          if (isConfigured) {
            // Estraggo il dato se l'utente è già loggato estranedo le info dal device
            bool isLoggedin = await Global.storageService.getIsLoggedIn();

            logger.d('Utente loggato? $isLoggedin');

            // Controllo se l'utente è già loggato
            if (isLoggedin) {
              // Se è già loggato visualizza la Homepage
              return const HomePage();
            }

            // Altrimenti visualizza lo pagina di Autenticazione
            return const AuthPage();
          } else {
            // Se non è presente un nome della pagina visualizza la pagina di Configurazione
            return const ConfigurationPage();
          }
        }
        // Se la route non è quella iniziale visualizza la pagina richiesta
        return result.first.page;
      }
    }
    // Se non è presente un nome della pagina visualizza la pagina di Configurazione
    return const ConfigurationPage();
  }
}

// Classe per unire i BlocProvider, le routes e le pagine
class PageEntity {
  String route;
  Widget page;
  dynamic bloc;

  PageEntity({
    required this.route,
    required this.page,
    this.bloc,
  });
}
