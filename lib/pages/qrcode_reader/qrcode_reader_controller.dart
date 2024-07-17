import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '/common/routes/names.dart';

import '/pages/qrcode_reader/bloc/qrcode_r_blocs.dart';
import '/pages/config/configuration_controller.dart';

class QRCodeReaderController {
  final BuildContext context;
  String? _funzione;

  QRCodeReaderController({required this.context});

  // Funzione per settare la tipologia di funzione
  void setFunzione(String data) {
    Logger().d(data);
    _funzione = data;
  }

  // Funzione per estrarre la tipologia di funzione
  String? getFunzione() {
    return _funzione;
  }

  /// Funzione per inizializzare la tipologia di funzione
  void init() async {
    final data = ModalRoute.of(context)!.settings.arguments as String?;
    setFunzione(data!);
  }

  /// Funzione per estrarre i dati dal QR Code
  void estraiDatiQRCode() {
    // Per gestire i log
    var logger = Logger();

    logger.d("Funzione: estraiDatiQRCode");

    Map<String, String>? dati;

    // Estraggo i dati dal Bloc QRCodeReaderBloc
    final qrcodeDati = context.read<QRCodeReaderBloc>().state.qrCodeDati;

    logger.d(qrcodeDati);

    // Recupero la funzione per cui devo estrarre i dati
    final funzione = getFunzione();

    // Estraggo le informazioni
    try {
      logger.d('Funzione: $funzione');
      // Se la funzione è relativa alla configurazione dell'ambiente estraggo i dati necessari
      if (funzione == AppRoutes.CONFIGURATION) {
        String? urlAmbiente;
        String? username;
        urlAmbiente = qrcodeDati.toString().substring(
              0,
              qrcodeDati.toString().indexOf('?'),
            );
        username = qrcodeDati.toString().substring(
              qrcodeDati.toString().indexOf('userLogin=') + 10,
            );

        dati = {
          'urlAmbiente': urlAmbiente,
          'username': username,
        };

        logger.d(dati);

        // Eseguo il controllo della configurazione
        ConfigurationController(context: context)
            .inizializzaConfigurazione(dati['urlAmbiente']!);
      }

      // Se la funzione è relativa alla scansione QR Code per definire l'asset estraggo i dati necessari
      if (funzione == AppRoutes.HOME_PAGE) {
        String? codiceAsset = qrcodeDati;

        // Definisco i dati da passare alla prossima pagina
        final arguments = {
          "page": AppRoutes.QRCODE_READING,
          "assetCodice": codiceAsset,
        };

        // Lancio la pagina dei WO passando come argomento il codice asset
        Navigator.of(context).pushNamed(
          AppRoutes.WO_LIST,
          arguments: arguments,
        );
      }
    } catch (error) {
      throw "Funzione: estraiDatiQRCode | Tipologia funzione: $funzione | Errore:\n${error.toString()}";
    }
  }
}
