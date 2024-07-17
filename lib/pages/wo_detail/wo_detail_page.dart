import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '/common/widgets/background_view.dart';
import '/common/widgets/buttons.dart';
import '/common/widgets/menu_button.dart';
import '/common/widgets/text_base.dart';

import '/pages/wo_detail/bloc/wo_detail_blocs.dart';
import '/pages/wo_detail/bloc/wo_detail_states.dart';
import '/pages/wo_detail/widgets/wo_detail_widget.dart';
import '/pages/wo_detail/wo_detail_controller.dart';

class WODetailPage extends StatefulWidget {
  const WODetailPage({super.key});

  @override
  State<WODetailPage> createState() => _WODetailPageState();
}

class _WODetailPageState extends State<WODetailPage> {
  late WODetailController _controller;
  late String woCodice;

  @override
  void didChangeDependencies() {
    // Inizializzazione WODetailController
    _controller = WODetailController(context: context);
    _controller.init();

    // Estrazione Codice WO
    woCodice = _controller.getDati()!["code"]!;

    // Estraggo le WOProcess
    _controller.estraiDettaglioWO();
    super.didChangeDependencies();
  }

  /// Funzione per convalidare le WOProcess e chiudere il WO
  Future<void> chiusuraWO() async {
    await _controller.convalidaWOProcessEChiudiWO();
    // Controllo che il context è presente e chiudo la pagina
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WODetailBloc, WODetailState>(
      builder: (context, state) {
        return BackgroundView(
          child: SafeArea(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    buildBackButton(context),
                    reusableTitleText(
                      'Elenco operazioni',
                      fontSize: 20.sp,
                      fontWeight: FontWeight.normal,
                    ),
                    woprocessList(_controller, state.woprocess),
                    Gap(10.h),
                    buildElevatedButton(
                      title: 'Concludi WO',
                      foregroudColor: Colors.redAccent[700]!,
                      function: () async {
                        final result = await dialogoChiusuraWO(context);
                        if (result == true) {
                          chiusuraWO();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
