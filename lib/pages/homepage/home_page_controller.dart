import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';

import '/common/entities/material.dart' as carl;

import '/common/data/material_api.dart';
import '/common/utils/error_util.dart';
import '/common/widgets/flutter_toast.dart';

import '/pages/homepage/bloc/home_blocs.dart';
import '/pages/homepage/bloc/home_events.dart';

class HomePageController {
  final BuildContext context;

  const HomePageController({required this.context});

  // Funzione per estrarre i dati degli asset con manutenzioni associate
  Future<void> estraiDatiAsset() async {
    // Per definire i log
    Logger logger = Logger();

    logger.d('Funzione: estraiDatiAsset');

    List<carl.Material>? listaMaterial;

    // Attivazione caricamento
    EasyLoading.show(
      indicator: const CircularProgressIndicator(),
      maskType: EasyLoadingMaskType.clear,
      dismissOnTap: true,
    );

    try {
      // Estraggo la lista degli asset
      listaMaterial = await MaterialApi.estrazioneMaterialConManutenzioni();
    } on CustomHttpException catch (e) {
      // Disattivazione caricamento
      EasyLoading.dismiss();
      // Notifico l'errore nella UI
      toastInfo(msg: e.message);
    } catch (e) {
      rethrow;
    }

    // Controllo che il context è presente e aggiorno il bloc HomeBloc con la lista degli asset
    if (context.mounted) {
      context.read<HomeBloc>().add(
            HomeDatiEvent(
              assets: listaMaterial,
            ),
          );
    }

    // Disattivazione caricamento
    EasyLoading.dismiss();
  }
}
