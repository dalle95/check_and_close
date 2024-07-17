import 'package:check_and_close/common/entities/measure_point.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '/common/values/label.dart';
import '/common/entities/wo.dart';
import '/common/entities/woprocess.dart';
import '/common/utils/http_util.dart';
import '/common/utils/conversioni_carl.dart';
import '/common/utils/date_util.dart';
import '/common/utils/error_util.dart';

class WOProcessApi {
  /// Funzione per estrarre le WOProcess
  static Future<List<WOProcess>?> estrazioneWOProcessAssociateAWO(
    String wo,
  ) async {
    // Per gestire i log
    var logger = Logger();

    logger.d("Funzione: estrazioneWOProcessAssociateAWO");

    String? url;
    Response<dynamic> response;
    Map<String, dynamic> responseMap;
    dynamic responseData;
    dynamic responseIncluded;

    List<WOProcess> lista = [];

    HttpUtil().initialize();

    // Chiamata per estrarre le WOProcess
    try {
      // Definizione url per l'estrazione WOProcess Standard
      url =
          '/api/entities/v1/woprocess?fields=ordering,mandatory,realisedDate,comment&filter[process.processClass]=STANDARD&filter[WO.code]=$wo&sort=ordering';

      // Chiamata per estrarre le WOProcess
      response = await HttpUtil().get(
        url,
      );

      // Gestione errore generico
      if (response.statusCode! >= 400) {
        throw CustomHttpException(labels.erroreTitolo);
      }

      responseMap = response.data;

      responseData = responseMap['data'];

      // Itero per i risultati presenti nella path "included" e definisco le WOProcess trovate
      for (var record in responseData) {
        lista.add(
          WOProcess(
            id: record['id'],
            comment: record['attributes']['comment'],
            ordering: (record['attributes']['ordering'] as num?)?.toDouble(),
            obbligatorio: record['attributes']['mandatory'],
            dataRealizzazione: conversioneDataCarlFormatDateTime(
              record['attributes']['realisedDate'],
            ),
            tipologia: "Standard",
          ),
        );
      }
      // Definizione url per l'estrazione WOProcess A Scelta
      url =
          '/api/entities/v1/wochoiceprocess?fields=ordering,mandatory,realisedDate,comment&include=valueListItem&filter[WO.code]=$wo&sort=ordering';

      // Chiamata per estrarre le WOProcess
      response = await HttpUtil().get(
        url,
      );

      // Gestione errore generico
      if (response.statusCode! >= 400) {
        throw CustomHttpException(labels.erroreTitolo);
      }

      responseMap = response.data as Map<String, dynamic>;

      responseData = responseMap['data'];
      responseIncluded = responseMap['included'];

      // Itero per i risultati presenti nella path "included" e definisco le WOProcess trovate
      for (var record in responseData) {
        lista.add(
          WOProcess(
            id: record['id'],
            comment: record['attributes']['comment'],
            ordering: (record['attributes']['ordering'] as num?)?.toDouble(),
            obbligatorio: record['attributes']['mandatory'],
            dataRealizzazione: conversioneDataCarlFormatDateTime(
              record['attributes']['realisedDate'],
            ),
            valore: record['relationships']['valueListItem']['data'] != null
                ? ConversioniCarl().convertiIDValore(
                    record['relationships']['valueListItem']['data']['id'],
                  )
                : null,
            tipologia: "Scelta",
          ),
        );
      }

      // Definizione url per l'estrazione WOProcess di Lettura
      url =
          '/api/entities/v1/touchwomeasureprocess?fields=ordering,mandatory,realisedDate,comment&include=measureReading,measurePoint&filter[WO.code]=$wo&sort=ordering';

      // Chiamata per estrarre le WOProcess
      response = await HttpUtil().get(
        url,
      );

      // Gestione errore generico
      if (response.statusCode! >= 400) {
        throw CustomHttpException(labels.erroreTitolo);
      }

      responseMap = response.data as Map<String, dynamic>;

      responseData = responseMap['data'];
      responseIncluded = responseMap['included'];

      // Itero per i risultati presenti nella path "included" e definisco i materiali trovati
      for (var record in responseData) {
        // Definisco l'operazione base
        var woProcess = WOProcess(
          id: record['id'],
          comment: record['attributes']['comment'],
          ordering: (record['attributes']['ordering'] as num?)?.toDouble(),
          obbligatorio: record['attributes']['mandatory'],
          dataRealizzazione: conversioneDataCarlFormatDateTime(
            record['attributes']['realisedDate'],
          ),
          tipologia: "Lettura",
        );

        // Preparo le variabili per trovare il punto di lettura e la lettura
        MeasurePoint? puntoDiLettura;
        Map<String, dynamic>? lettura;

        // Itero i dati per trovare i match
        for (var record2 in responseIncluded) {
          // Condizione per trovare il punto di lettura
          if (record2["id"] ==
              record["relationships"]["measurePoint"]["data"]?["id"]) {
            puntoDiLettura = MeasurePoint(
              id: record2["id"],
              codice: record2["attributes"]["code"],
              descrizione: record2["attributes"]["description"],
            );
          }
          // Condizione per trovare la lettura
          if (record2["id"] ==
              record["relationships"]["measureReading"]["data"]?["id"]) {
            lettura = record2;
          }
        }

        logger.d(puntoDiLettura?.toJson());

        // Definisco gli attributi della WOProcess mancanti
        woProcess.letturaID = lettura?["id"];
        woProcess.valore = lettura?["attributes"]["measure"];

        woProcess.puntoDiLettura = puntoDiLettura;

        lista.add(woProcess);
      }

      // Ordinamento della lista in base all'attributo ordering
      lista.sort((a, b) => a.ordering!.compareTo(b.ordering!));
    } on CustomHttpException catch (e) {
      throw CustomHttpException(e.message);
    } catch (error) {
      throw "Funzione: estrazioneWOProcessAssociateAWO | Errore: $error";
    }

    return lista;
  }

  /// Funzione per convalidare le WOProcess
  static Future<void> convalidaWOProcess(
    List<WOProcess> lista,
    WO wo,
  ) async {
    // Per gestire i log
    var logger = Logger();

    logger.d("Funzione: convalidaWOProcess");

    String? url;
    Map<String, dynamic>? body;
    Response<dynamic> response;

    DateTime now = DateTime.now().add(const Duration(minutes: -1));

    // Procedura per convalidare le WOProcess una alla volta
    try {
      // Itero le WOProcess associate al WO
      for (WOProcess woProcess in lista) {
        // Controllo se la WOProcess è obbligatoria o se il valore è stato aggiornato
        if (woProcess.obbligatorio == true ||
            woProcess.dataRealizzazione != null) {
          // Gestione WOProcess di tipologia Standard
          if (woProcess.tipologia == "Standard") {
            // Definizione url per l'estrazione WOProcess Standard
            url = '/api/entities/v1/woprocess/${woProcess.id}';

            body = {
              "data": {
                "type": "woprocess",
                "attributes": {
                  "ordering": woProcess.ordering,
                  "comment": woProcess.comment,
                  "realisedDate": conversioneDataDateTimeCarlFormat(
                    woProcess.obbligatorio == true
                        ? woProcess.dataRealizzazione ?? now
                        : woProcess
                            .dataRealizzazione, // TODO: Da pensare meglio
                  ),
                }
              }
            };

            // Chiamata per aggiornare la WOProcess
            response = await HttpUtil().patch(
              url,
              mydata: body,
            );

            logger.d('Standard: ${response.statusCode}');

            // Gestione errore generico
            if (response.statusCode! >= 400) {
              logger.d(body);
              logger.d(response.data);
              throw CustomHttpException(labels.erroreTitolo);
            }
          }
          // Gestione WOProcess di tipologia A Scelta
          if (woProcess.tipologia == "Scelta") {
            // Definizione url per l'estrazione WOProcess Standard
            url = '/api/entities/v1/wochoiceprocess/${woProcess.id}';

            final valoreCastato = woProcess.obbligatorio == true
                ? woProcess.valore ?? "Non valutata"
                : woProcess.valore;

            final valueListItem = valoreCastato == null
                ? {
                    "data": null,
                  }
                : {
                    "data": {
                      "id": ConversioniCarl().convertiValoreID(
                        valoreCastato, // TODO: Da pensare meglio
                      ),
                      "type": "valuelistitem",
                    }
                  };

            body = {
              "data": {
                "type": "wochoiceprocess",
                "attributes": {
                  "ordering": woProcess.ordering,
                  "comment": woProcess.comment,
                  "realisedDate": conversioneDataDateTimeCarlFormat(
                    woProcess.obbligatorio == true
                        ? woProcess.dataRealizzazione ?? now
                        : woProcess
                            .dataRealizzazione, // TODO: Da pensare meglio
                  ),
                },
                "relationships": {
                  "valueListItem": valueListItem,
                }
              }
            };

            // Chiamata per aggiornare la WOProcess
            response = await HttpUtil().patch(
              url,
              mydata: body,
            );

            logger.d('Scelta: ${response.statusCode}');

            // Gestione errore generico
            if (response.statusCode! >= 400) {
              throw CustomHttpException(labels.erroreTitolo);
            }
          }
          // Gestione WOProcess di tipologia A Lettura
          if (woProcess.tipologia == "Lettura") {
            // Chiamata per creazione lettura ed estrazione dell'ID
            woProcess.letturaID = await creaLettura(woProcess);

            // Definizione url per l'estrazione WOProcess Standard
            url = '/api/entities/v1/touchwomeasureprocess/${woProcess.id}';

            body = {
              "data": {
                "type": "touchwomeasureprocess",
                "attributes": {
                  "ordering": woProcess.ordering,
                  "comment": woProcess.comment,
                  "realisedDate": conversioneDataDateTimeCarlFormat(
                    woProcess.obbligatorio == true
                        ? woProcess.dataRealizzazione ?? now
                        : woProcess
                            .dataRealizzazione, // TODO: Da pensare meglio
                  ),
                },
                "relationships": {
                  "measureReading": {
                    "data": {
                      "id": woProcess.letturaID,
                      "type": "measurereading"
                    },
                  }
                }
              }
            };

            // Chiamata per aggiornare la WOProcess
            response = await HttpUtil().patch(
              url,
              mydata: body,
            );

            logger.d('Lettura: ${response.statusCode}');

            // Gestione errore generico
            if (response.statusCode! >= 400) {
              logger.d(body);
              logger.d(response.data);
              throw CustomHttpException(labels.erroreTitolo);
            }
          }
        }
      }
    } on CustomHttpException catch (e) {
      throw CustomHttpException(e.message);
    } catch (error) {
      throw "Funzione: convalidaWOProcess | Errore: $error";
    }
  }

  /// Funzione per creare una misura per la validazione delle WOProcess a Lettura
  static Future<String?> creaLettura(WOProcess woProcess) async {
    // Per gestire i log
    var logger = Logger();

    logger.d("Funzione: creaLettura");

    String? url;
    Map<String, dynamic> data;
    Response<dynamic> response;

    // Procedura per creare una misura
    try {
      // Definizione url per le letture
      url = '/api/entities/v1/measurereading';

      // Definizione Body
      data = {
        "data": {
          "type": "measurereading",
          "attributes": {
            "origin": 1,
            "description": null,
            "measure": woProcess.valore,
            "dateMeasure":
                conversioneDataDateTimeCarlFormat(woProcess.dataRealizzazione),
            "repercussion": false,
            "correction": false,
            "noChrono": false
          },
          "relationships": {
            "measurePoint": {
              "data": {
                "id": woProcess.puntoDiLettura!.id,
                "type": "measurepoint"
              }
            }
          }
        }
      };

      // Chiamata per l'aggiornamento delle date
      response = await HttpUtil().post(
        url,
        mydata: data,
      );

      logger.d(response.data);

      // Gestione errore generico
      if (response.statusCode! >= 400) {
        logger.d(response.data);
        throw CustomHttpException(labels.erroreTitolo);
      }
    } on CustomHttpException catch (e) {
      throw CustomHttpException(e.message);
    } catch (error) {
      throw "Funzione: creaLettura | Errore: $error";
    }
    // Restituisco l'ID della misura appena creata
    return response.data["data"]["id"];
  }
}
