import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/common/widgets/background_view.dart';
import '/common/widgets/menu_button.dart';
import '/common/widgets/text_base.dart';

import '/pages/wo_list/widgets/wo_list_widget.dart';
import '/pages/wo_list/bloc/wo_list_blocs.dart';
import '/pages/wo_list/bloc/wo_list_states.dart';
import '/pages/wo_list/wo_list_controller.dart';

class WOListPage extends StatefulWidget {
  const WOListPage({super.key});

  @override
  State<WOListPage> createState() => _WOListPageState();
}

class _WOListPageState extends State<WOListPage> {
  late WOListController _controller;
  late String assetCodice;

  @override
  void didChangeDependencies() {
    // Inizializzazione WOListController
    _controller = WOListController(context: context);
    _controller.init();

    // Estrazione Codice Asset
    assetCodice = _controller.getDati()!["assetCodice"]!;

    // Estrazione WO associati all'asset
    _controller.estraiDatiWO();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WOListBloc, WOListState>(
      builder: (context, state) {
        return BackgroundView(
          child: SafeArea(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(
                children: [
                  buildBackButton(context),
                  reusableTitleText(
                    'Asset: $assetCodice',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.normal,
                  ),
                  woList(state.wo),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
