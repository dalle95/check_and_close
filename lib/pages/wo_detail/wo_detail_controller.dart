import 'package:check_and_close/common/utils/error_util.dart';
import 'package:check_and_close/common/widgets/flutter_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';

import '/common/entities/wo.dart';
import '/common/data/woprocess_api.dart';
import '/common/entities/woprocess.dart';
import '/common/data/wo_api.dart';

import '/pages/wo_list/bloc/wo_list_blocs.dart';
import '/pages/wo_list/bloc/wo_list_events.dart';
import '/pages/wo_detail/bloc/wo_detail_blocs.dart';
import '/pages/wo_detail/bloc/wo_detail_events.dart';

/// Controller per la pagina WODetailPage
class WODetailController {
  final BuildContext context;
  Map<String, dynamic>? _data;

  WODetailController({required this.context});

  /// Funzione per settare i dati relativi al WO
  void setDati(Map<String, dynamic>? data) {
    _data = data;
  }

  /// Funzione per estrarre i dati relativi al WO
  Map<String, dynamic>? getDati() {
    return _data;
  }

  /// Funzione per inizializzare i dati relativi al WO
  void init() async {
    final data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    setDati(data!);
  }

  /// Funzione per estrarre il dettaglio del WO associato all'Asset
  Future<void> estraiDettaglioWO() async {
    Logger().d('Funzione: estraiDettaglioWO');

    // Attivazione caricamento
    EasyLoading.show(
      indicator: const CircularProgressIndicator(),
      maskType: EasyLoadingMaskType.clear,
      dismissOnTap: true,
    );

    // Estraggo i dati passati alla pagina WODetailPage e li converto in entità WO
    final WO wo = WO.fromJson(getDati()!);

    try {
      // Controllo che il context è presente e controllo se il nuovo WO è diverso dal precedente
      if (context.mounted) {
        // Controllo se è presente un WO nello stato del bloc
        if (context.read<WODetailBloc>().state.wo == null) {
          // Estraggo la lista delle Operazioni associate al WO filtrando per il codice
          final List<WOProcess>? lista =
              await WOProcessApi.estrazioneWOProcessAssociateAWO(wo.code!);

          // Controllo che il context è presente e aggiorno il bloc con la lista delle woprocess
          if (context.mounted) {
            context.read<WODetailBloc>().add(
                  WODetailDatiEvent(
                    wo: wo,
                    woprocess: lista,
                  ),
                );
          }
        } else {
          // Controllo se il WO è lo stesso già presente nello Bloc, e nel caso non aggiorno la lista
          if (context.read<WODetailBloc>().state.wo!.id != wo.id) {
            // Estraggo la lista delle Operazioni associate al WO filtrando per il codice
            final List<WOProcess>? lista =
                await WOProcessApi.estrazioneWOProcessAssociateAWO(wo.code!);

            // Controllo che il context è presente e aggiorno il bloc con la lista delle woprocess
            if (context.mounted) {
              context.read<WODetailBloc>().add(
                    WODetailDatiEvent(
                      wo: wo,
                      woprocess: lista,
                    ),
                  );
            }
          }
        }
      }
    } on CustomHttpException catch (e) {
      // Disattivazione caricamento
      EasyLoading.dismiss();
      // Notifico l'errore nella UI
      toastInfo(msg: e.message);
      rethrow;
    } catch (e) {
      rethrow;
    }

    // Disattivazione caricamento
    EasyLoading.dismiss();
  }

  /// Funzione per aggiornare le WOProcess
  void aggiornaWOProcess(WOProcess woProcess) {
    Logger().d('Funzione: aggiornaWOProcess');

    // Controllo che il context è presente e aggiorno il bloc con la woProcess modificata
    if (context.mounted) {
      context.read<WODetailBloc>().add(
            WOUpdateDetailDatiEvent(
              woprocess: woProcess,
            ),
          );
    }
  }

  /// Funzione per convalidare tutte le WOProcess e chiudere il WO
  Future<void> convalidaWOProcessEChiudiWO() async {
    Logger().d('Funzione: convalidaWOProcessEChiudiWO');

    List<WOProcess> lista = [];
    WO wo;

    // Attivazione caricamento
    EasyLoading.show(
      indicator: const CircularProgressIndicator(),
      maskType: EasyLoadingMaskType.clear,
      dismissOnTap: true,
    );

    try {
      // Controllo che il context è presente ed estraggo la lista delle WOProcess
      if (context.mounted) {
        lista = context.read<WODetailBloc>().state.woprocess!;
        wo = context.read<WODetailBloc>().state.wo!;

        // Recupero la data di realizzazione maggiore e minore tra le WOProcess
        Map<String, DateTime?> rangeDate = findMinMaxDates(lista);

        // Controllo che tutte le date di realizzazione delle WOProcess siano all'interno del range di date del WO
        if (wo.dataInizio!
                .isAfter(rangeDate['dataRealizzazioneMin'] ?? wo.dataInizio!) ||
            wo.dataFine!
                .isBefore(rangeDate['dataRealizzazioneMax'] ?? wo.dataFine!)) {
          // Aggiorno le date di inizio e fine del WO con i nuovi valori
          wo.dataInizio = rangeDate['dataRealizzazioneMin']!
              .add(const Duration(minutes: -1));
          wo.dataFine = rangeDate['dataRealizzazioneMax']!
              .add(const Duration(minutes: 1));

          // Aggiorno le date del WO per poter convalidare le WOProcess
          await WOApi.aggiornaPeriodoWO(wo);
        }

        // Avvio la procedura di convalida WOProcess
        await WOProcessApi.convalidaWOProcess(
          lista,
          wo,
        );

        // Aggiorno lo stato del WO mettendolo nello stato CLOSED
        await WOApi.passaggioDiStatoClosed(wo);

        // Aggiorno lo stato del WOListBloc per togliere il WO appena gestito
        if (context.mounted) {
          // Estraggo la lista dei WO dal bloc
          List<WO>? listaWO = context.read<WOListBloc>().state.wo;

          // Rimozione del WOProcess con l'ID specificato
          listaWO!.removeWhere((record) => record.id == wo.id);

          // Aggiorno la lista dei WO
          context.read<WOListBloc>().add(
                WOListDatiEvent(
                  wo: listaWO,
                ),
              );
        }
      }
    } on CustomHttpException catch (e) {
      // Disattivazione caricamento
      EasyLoading.dismiss();
      // Notifico l'errore nella UI
      toastInfo(msg: e.message);
      rethrow;
    } catch (e) {
      rethrow;
    }

    // Disattivazione caricamento
    EasyLoading.dismiss();
  }
}

/// Funzione per estrarre la data minore e maggiore da una lista di WOProcess
Map<String, DateTime?> findMinMaxDates(List<WOProcess> lista) {
  if (lista.isEmpty) {
    return {
      "dataRealizzazioneMin": null,
      "dataRealizzazioneMax": null,
    };
  }

  DateTime? dataRealizzazioneMin = lista.first.dataRealizzazione;
  DateTime? dataRealizzazioneMax = lista.first.dataRealizzazione;

  for (var process in lista) {
    if (process.dataRealizzazione != null) {
      if (dataRealizzazioneMin == null ||
          process.dataRealizzazione!.isBefore(dataRealizzazioneMin)) {
        dataRealizzazioneMin = process.dataRealizzazione;
      }
      if (dataRealizzazioneMax == null ||
          process.dataRealizzazione!.isAfter(dataRealizzazioneMax)) {
        dataRealizzazioneMax = process.dataRealizzazione;
      }
    }
  }

  return {
    "dataRealizzazioneMin": dataRealizzazioneMin,
    "dataRealizzazioneMax": dataRealizzazioneMax,
  };
}
