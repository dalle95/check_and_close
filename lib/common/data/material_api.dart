import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '/global.dart';

import '/common/values/label.dart';

import '/common/entities/material.dart';
import '/common/entities/user.dart';
import '/common/utils/http_util.dart';
import '/common/utils/error_util.dart';

class MaterialApi {
  /// Funzione per estrarre i materiali con manutenzioni associate
  static Future<List<Material>?> estrazioneMaterialConManutenzioni() async {
    // Per gestire i log
    var logger = Logger();

    logger.d("Funzione: estrazioneMaterialConManutenzioni");

    List<Material> lista = [];
    User user;
    String username;

    String url;
    Response<dynamic> response;
    Map<String, dynamic> responseMap;
    dynamic responseData;
    dynamic responseIncluded;

    HttpUtil().initialize();

    // Chiamata per autenticare l'utente richiedendo il token
    try {
      // Recupero le informazioni dell'utente salvate sul dispotivo
      user = await Global.storageService.getUserProfile();

      // Recupero l'username
      username = user.username!;

      // Definizione url per l'estrazione asset associati alle manutenzioni
      url =
          '/api/entities/v1/woeqpt?include=eqpt&filter[directEqpt]=true&filter[WO.statusCode]=AWAITINGREAL,INPROGRESS&filter[eqpt.structure.code]=MATERIALE&filter[WO.assignedTo.code]=$username&sort=eqpt.code&';

      // Chiamata per estrarre i material associati ad una manutenzione
      response = await HttpUtil().get(
        url,
      );

      // Gestione errore credenziali
      if (response.statusCode! >= 401) {
        throw CustomHttpException(labels.status401);
      }

      // Gestione errore generico
      if (response.statusCode! >= 402) {
        throw CustomHttpException(labels.erroreTitolo);
      }

      responseMap = response.data;

      responseData = responseMap['data'];
      responseIncluded = responseMap['included'];

      // Se non sono presenti dati esco dalla funzione
      if (responseIncluded == null) {
        return lista;
      }

      // Itero per i risultati presenti nella path "included" e definisco i materiali trovati
      for (var record in responseIncluded) {
        lista.add(
          Material(
            id: record['id'],
            code: record['attributes']['code'],
            descrizione: record['attributes']['description'],
            eqptType: record['attributes']['eqptType'],
          ),
        );
      }
    } on CustomHttpException catch (e) {
      throw CustomHttpException(e.message);
    } catch (error) {
      throw "Funzione: estrazioneMaterialConManutenzioni | Errore: $error";
    }

    return lista;
  }
}
