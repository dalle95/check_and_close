import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '/common/entities/woprocess.dart';
import '/common/widgets/container_base.dart';
import '/common/utils/date_util.dart';
import '/common/values/colors.dart';
import '/common/widgets/buttons.dart';
import '/common/widgets/text_base.dart';
import '/common/widgets/text_field.dart';
import '/common/widgets/empty_list.dart';

import '/pages/wo_detail/wo_detail_controller.dart';

Widget woprocessList(
  WODetailController controller,
  List<WOProcess>? lista,
) {
  return BaseContainer(
    height: 550.h,
    width: 325.w,
    margin: EdgeInsets.only(top: 15.h),
    color: Colors.white,
    child: RefreshIndicator(
      onRefresh: () => controller.estraiDettaglioWO(),
      child: lista!.isEmpty
          ? buildEmptyListView("Non sono presenti operazioni.")
          : ListView.builder(
              itemCount: lista.length,
              itemBuilder: (context, index) {
                return woprocessItem(
                  context: context,
                  woProcess: lista[index],
                );
              },
            ),
    ),
  );
}

Widget woprocessItem({
  required BuildContext context,
  WOProcess? woProcess,
}) {
  // Funzione per definire l'icona in base alla tipologia della WOProcess
  IconData definisciIcona(tipologia) {
    if (tipologia == 'Standard') {
      return Icons.check_circle_outline_rounded;
    } else if (tipologia == 'Scelta') {
      return Icons.list_alt;
    } else {
      return Icons.inventory_sharp;
    }
  }

  // Funzione per definire il testo del sottotitolo della WOProcess
  String definisciSottoTitolo(WOProcess woProcess) {
    // Se la WOProcess non è ancora gestita mostro la sua tipologia
    if (woProcess.dataRealizzazione == null) {
      return woProcess.tipologia ?? "[Standard]";
    } else {
      if (woProcess.tipologia == "Standard") {
        return dataOraFormattata(woProcess.dataRealizzazione!);
      }
      if (woProcess.tipologia == "Scelta") {
        return "Valutazione: ${woProcess.valore}\n${dataOraFormattata(woProcess.dataRealizzazione!)}";
      }
      if (woProcess.tipologia == "Scelta") {
        return "Valutazione: ${woProcess.valore}\n${dataOraFormattata(woProcess.dataRealizzazione!)}";
      }
      if (woProcess.tipologia == "Lettura") {
        return "Valore: ${woProcess.valore}\n${dataOraFormattata(woProcess.dataRealizzazione!)}";
      }
      return "";
    }
  }

  return Card(
    elevation: 1,
    margin: EdgeInsets.symmetric(
      horizontal: 10.w,
      vertical: 5.h,
    ),
    child: Padding(
      padding: EdgeInsets.all(5.0.dg),
      child: ListTile(
        onTap: () => mostraDettaglioPuntoDiLettura(
          context,
          woProcess,
        ),
        title: Text(
          '${woProcess!.comment}',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.normal,
          ),
        ),
        subtitle: Text(
          definisciSottoTitolo(woProcess),
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: InkWell(
          onTap: () async {
            // Gestisco tipologia Standard
            if (woProcess.tipologia == "Standard") {
              if (woProcess.dataRealizzazione == null) {
                woProcess.dataRealizzazione = DateTime.now();
              } else {
                woProcess.dataRealizzazione = null;
              }
            }
            // Gestisco tipologia a Scelta
            if (woProcess.tipologia == "Scelta") {
              // Controllo che il context è presente e apro il modal
              if (context.mounted) {
                woProcess.valore = await mostraSceltaModal(context);
              }
              if (woProcess.valore != null) {
                woProcess.dataRealizzazione = DateTime.now();
              } else {
                woProcess.dataRealizzazione = null;
              }
            }

            // Gestisco tipologia a Lettura
            if (woProcess.tipologia == "Lettura") {
              // Controllo che il context è presente e apro il modal
              if (context.mounted) {
                woProcess.valore = await mostraLetturaModal(context, woProcess);
              }
              if (woProcess.valore != null) {
                woProcess.dataRealizzazione = DateTime.now();
              } else {
                woProcess.dataRealizzazione = null;
              }
            }
            // Controllo che il context è presente e aggiorno il bloc con la lista delle woprocess
            if (context.mounted) {
              // Aggiorno la WOProcess
              WODetailController(context: context).aggiornaWOProcess(woProcess);
            }
          },
          borderRadius: BorderRadius.circular(50.r),
          splashColor: Colors.blue,
          child: Container(
            height: 55.h,
            width: 55.w,
            decoration: BoxDecoration(
              color: Colors.white70,
              shape: BoxShape.circle,
              border: Border.all(
                width: 2.r,
                color: woProcess.obbligatorio == true
                    ? Colors.redAccent[700]!
                    : Colors.black87,
              ),
              boxShadow: [
                BoxShadow(
                  color: woProcess.obbligatorio == true
                      ? Colors.redAccent[700]!
                      : Colors.black87,
                  blurRadius: 4.0.r,
                  offset: const Offset(4, 4),
                ),
              ],
            ),
            child: Icon(
              definisciIcona(woProcess.tipologia),
              size: 40.sp,
              color: woProcess.dataRealizzazione != null
                  ? Colors.green
                  : AppColors.disabledElement,
            ),
          ),
        ),
      ),
    ),
  );
}

Future<String?> mostraSceltaModal(BuildContext context) async {
  final String? result = await showModalBottomSheet<String>(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.only(
          top: 20.h,
          left: 10.w,
          right: 10.w,
          bottom: 10.h,
        ),
        height: 270.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ListTile(
              title: reusableBodyText(
                'Conforme',
                textAlign: TextAlign.center,
                fontSize: 25.sp,
              ),
              onTap: () {
                Navigator.pop(context, 'Conforme');
              },
            ),
            ListTile(
              title: reusableBodyText(
                'Non conforme',
                textAlign: TextAlign.center,
                fontSize: 25.sp,
              ),
              onTap: () {
                Navigator.pop(context, 'Non conforme');
              },
            ),
            ListTile(
              title: reusableBodyText(
                'Non valutata',
                textAlign: TextAlign.center,
                fontSize: 25.sp,
              ),
              onTap: () {
                Navigator.pop(context, 'Non valutata');
              },
            ),
            ListTile(
              title: reusableBodyText(
                'Nessuna scelta',
                textAlign: TextAlign.center,
                color: AppColors.disabledElement,
                fontSize: 25.sp,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
  return result;
}

Future<String?> mostraLetturaModal(
  BuildContext context,
  WOProcess woProcess,
) async {
  TextEditingController valore = TextEditingController(text: woProcess.valore);
  final String? result = await showModalBottomSheet<String>(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              top: 20.h,
              left: 10.w,
              right: 10.w,
              bottom: 10.h,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: reusableBodyText(
                    "Inserisci la lettura",
                    fontSize: 20.sp,
                    color: AppColors.primaryElement,
                  ),
                ),
                Gap(10.h),
                buildTextField(
                  controller: valore,
                  iconName: "measure",
                  autofocus: true,
                ),
                buildElevatedButton(
                  title: "Inserisci",
                  function: () => Navigator.pop(context, valore.text),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
  return result;
}

// Dialogo Chiusura WO
Future<bool?> dialogoChiusuraWO(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Chiusura WO'),
      content: const Text(
          'La chiusura del WO convaliderà le operazioni associate automaticamente.\nContinuare?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop(true);
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.red[700],
            backgroundColor: Theme.of(ctx).colorScheme.background,
          ),
          child: const Text(
              'Conferma'), // Assicurati di sostituire con labels.conferma se necessario
        ),
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop(false);
          },
          style: TextButton.styleFrom(
            backgroundColor: Theme.of(ctx).colorScheme.background,
          ),
          child: const Text(
              'Annulla'), // Assicurati di sostituire con labels.annulla se necessario
        ),
      ],
    ),
  );
}

Future<void> mostraDettaglioPuntoDiLettura(
  BuildContext context,
  WOProcess woProcess,
) async {
  await showModalBottomSheet<String>(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              top: 20.h,
              left: 10.w,
              right: 10.w,
              bottom: 10.h,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: reusableBodyText(
                    "Punto di lettura",
                    fontSize: 15.sp,
                    color: AppColors.primaryElement,
                  ),
                ),
                Gap(20.h),
                Container(
                  alignment: Alignment.center,
                  child: reusableBodyText(
                    "Codice: ${woProcess.puntoDiLettura?.codice ?? "---"}",
                    fontSize: 15.sp,
                  ),
                ),
                Gap(5.h),
                Container(
                  alignment: Alignment.center,
                  child: reusableBodyText(
                    "Descrizione: ${woProcess.puntoDiLettura?.descrizione ?? "---"}",
                    fontSize: 15.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
