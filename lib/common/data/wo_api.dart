import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '/global.dart';

import '/common/values/label.dart';

import '/common/entities/wo.dart';
import '/common/entities/user.dart';

import '/common/utils/http_util.dart';
import '/common/utils/date_util.dart';
import '/common/utils/error_util.dart';

class WOApi {
  /// Funzione per estrarre i WO associati a degli asset
  static Future<List<WO>?> estrazioneWOAssociatiAdAsset(String asset) async {
    // Per gestire i log
    var logger = Logger();

    logger.d("Funzione: estrazioneWOAssociatiAdAsset");

    List<WO> lista = [];
    User user;
    String username;

    String url;
    Response<dynamic> response;
    Map<String, dynamic> responseMap;
    dynamic responseData;
    dynamic responseIncluded;

    // Inizializzo l'HttpUtil per poter usare le chiamate API
    HttpUtil().initialize();

    // Chiamata per autenticare l'utente richiedendo il token
    try {
      // Recupero le informazioni dell'utente salvate sul dispotivo
      user = await Global.storageService.getUserProfile();

      // Recupero l'username
      username = user.username!;
      // Definizione url per l'estrazione WO associati all'asset
      url =
          '/api/entities/v1/woeqpt?include=WO&filter[WO.statusCode]=AWAITINGREAL,INPROGRESS&filter[eqpt.code]=$asset&filter[WO.assignedTo.code]=$username&sort=WO.WOBegin';

      // Chiamata per estrarre i WO
      response = await HttpUtil().get(
        url,
      );

      // Gestione errore generico
      if (response.statusCode! >= 400) {
        throw CustomHttpException(labels.erroreTitolo);
      }

      responseMap = response.data;

      responseData = responseMap['data'];
      responseIncluded = responseMap['included'];

      // Se non sono presenti dati esco dalla funzione
      if (responseData == null) {
        return [];
      }

      // Itero per i risultati presenti nella path "included" e definisco i materiali trovati
      for (var record in responseIncluded) {
        lista.add(
          WO(
            id: record['id'],
            code: record['attributes']['code'],
            descrizione: record['attributes']['description'],
            dataInizio: conversioneDataCarlFormatDateTime(
              record['attributes']['WOBegin'],
            ),
            dataFine: conversioneDataCarlFormatDateTime(
              record['attributes']['WOEnd'],
            ),
          ),
        );
      }
    } on CustomHttpException catch (e) {
      throw CustomHttpException(e.message);
    } catch (error) {
      throw "Funzione: estrazioneWOAssociatiAdAsset | Errore: $error";
    }

    return lista;
  }

  /// Funzione per aggiornare la data di inizio e fine di un WO e permetterne la convalida delle WOProcess
  static Future<void> aggiornaPeriodoWO(WO wo) async {
    // Per gestire i log
    var logger = Logger();

    logger.d("Funzione: aggiornaPeriodoWO");

    String? url;
    Map<String, dynamic> data;
    Response<dynamic> response;

    // Procedura per aggiornare le date di un WO
    try {
      // Definizione url per l'aggiornamento di un WO
      url = '/api/entities/v1/wo/${wo.id}';

      // Definizione Body
      data = {
        'data': {
          'type': 'wo',
          'attributes': {
            'WOBegin': conversioneDataDateTimeCarlFormat(wo.dataInizio),
            'WOEnd': conversioneDataDateTimeCarlFormat(wo.dataFine),
          },
        }
      };

      // Chiamata per l'aggiornamento delle date
      response = await HttpUtil().patch(
        url,
        mydata: data,
      );

      // Gestione errore generico
      if (response.statusCode! >= 400) {
        throw CustomHttpException(labels.erroreTitolo);
      }
    } on CustomHttpException catch (e) {
      throw CustomHttpException(e.message);
    } catch (error) {
      throw "Funzione: aggiornaPeriodoWO | Errore: $error";
    }
  }

  /// Funzione per effettuare il passaggio di stato di un WO - Stato: Concluso
  static Future<void> passaggioDiStatoClosed(WO wo) async {
    // Per gestire i log
    var logger = Logger();

    logger.d("Funzione: passaggioDiStatoClosed");

    String? url;
    Map<String, dynamic> data;
    Response<dynamic> response;

    // Procedura per passaggio di stato
    try {
      // Definizione url per l'aggiornamento di un WO
      url = '/api/entities/v1/wo/${wo.id}/workflow-transitions';

      // Definizione Body
      data = {
        "data": {
          "id":
              "WOTOUCH_INPROGRESS_CLOSED:com.carl.xnet.works.backend.bean.status.WoClosedTransitionParameters", //"177fed5ef2f-28e0:com.carl.xnet.works.backend.bean.status.WOTransitionParameters", //TODO: da pensare bene
          "type": "workflow-transitions",
        }
      };

      // Chiamata per il passaggio di stato
      response = await HttpUtil().post(
        url,
        mydata: data,
      );

      // Gestione errore generico
      if (response.statusCode! >= 400) {
        logger.d(response.data);
        throw CustomHttpException(labels.erroreTitolo);
      }
    } on CustomHttpException catch (e) {
      throw CustomHttpException(e.message);
    } catch (error) {
      throw "Funzione: passaggioDiStatoClosed | Errore: $error";
    }
  }
}
