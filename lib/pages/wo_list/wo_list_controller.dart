import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';

import '/common/data/wo_api.dart';
import '/common/entities/wo.dart';
import '/common/utils/error_util.dart';
import '/common/widgets/flutter_toast.dart';

import '/pages/wo_list/bloc/wo_list_blocs.dart';
import '/pages/wo_list/bloc/wo_list_events.dart';

class WOListController {
  final BuildContext context;
  Map<String, String>? _funzione;

  WOListController({required this.context});

  // Funzione per settare i dati
  void setDati(Map<String, String>? data) {
    _funzione = data;
  }

  // Funzione per estrarre i dati
  Map<String, dynamic>? getDati() {
    return _funzione;
  }

  // Funzione per inizializzare i dati
  void init() async {
    final data =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>?;
    setDati(data!);
  }

  // Funzione per estrarre i dati dei WO associati all'Asset
  Future<void> estraiDatiWO() async {
    Logger().d('Funzione: estraiDatiWO');

    List<WO>? listaWO;

    // Attivazione caricamento
    EasyLoading.show(
      indicator: const CircularProgressIndicator(),
      maskType: EasyLoadingMaskType.clear,
      dismissOnTap: true,
    );

    // Estraggo i dati passati alla pagina WOListPage e recupero il codice dell'asset per cui estrarre i WO
    final String assetCodice = getDati()!["assetCodice"]!;

    try {
      // Estraggo la lista dei WO
      listaWO = await WOApi.estrazioneWOAssociatiAdAsset(assetCodice);
    } on CustomHttpException catch (e) {
      // Disattivazione caricamento
      EasyLoading.dismiss();
      // Notifico l'errore nella UI
      toastInfo(msg: e.message);
      throw CustomHttpException(e.message);
    } catch (e) {
      rethrow;
    }

    // Controllo che il context è presente e aggiorno il bloc WOListBloc con la lista dei WO
    if (context.mounted) {
      context.read<WOListBloc>().add(
            WOListDatiEvent(
              wo: listaWO,
            ),
          );
    }

    // Disattivazione caricamento
    EasyLoading.dismiss();
  }
}
