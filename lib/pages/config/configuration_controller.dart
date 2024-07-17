import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '/global.dart';

import '/common/routes/names.dart';
import '/common/utils/http_util.dart';
import '/common/values/constant.dart';

class ConfigurationController {
  final BuildContext context;

  const ConfigurationController({required this.context});

  // Funzione per inizializzare la configurazione dell'ambiente salvando i dati sul dispositivo e inizializzando HttpUtils
  Future<void> inizializzaConfigurazione(String urlAmbiente) async {
    try {
      // Salvataggio dati sul dispositivo
      await Global.storageService.setString(
        AppConstants.SERVER_API_URL,
        urlAmbiente,
      );

      Logger().d(
        "Configurazione salvata",
      );

      // Inizializzo HttpUtil per poter usare sempre l'URL Ambiente salvato
      await HttpUtil().initialize();

      // Controllo se il context è presente e lancio la nuova pagina
      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.AUTHENTICATION,
          (route) => false,
        );
      }
    } catch (error) {
      Logger().d(
        "Errore nel salvataggio della configurazione\n. Errore:\n${error.toString()}",
      );

      throw "Errore nel salvataggio della configurazione\n. Errore:\n${error.toString()}";
    }
  }
}
