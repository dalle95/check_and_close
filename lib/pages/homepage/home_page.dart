import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/common/routes/names.dart';
import '/common/widgets/background_view.dart';
import '/common/widgets/drawer.dart';
import '/common/widgets/menu_button.dart';

import '/pages/homepage/bloc/home_blocs.dart';
import '/pages/homepage/bloc/home_events.dart';
import '/pages/homepage/bloc/home_states.dart';
import '/pages/homepage/home_page_controller.dart';
import '/pages/homepage/widgets/home_page_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return BackgroundView(
          child: SafeArea(
              child: Scaffold(
            backgroundColor: Colors.transparent,
            endDrawer: const MainDrawer(),
            body: Stack(
              alignment: Alignment.topCenter,
              children: [
                PageView(
                  scrollDirection: Axis.vertical,
                  controller: pageController,
                  onPageChanged: (index) {
                    // Aggiorno l'index della pagina nel bloc HomeBloc
                    context.read<HomeBloc>().add(HomeDatiEvent(page: index));
                    // Estraggo i dati relativi agli asset con manutenzioni solo se la pagina è quella di pianificazione
                    if (index == 1) {
                      HomePageController(context: context).estraiDatiAsset();
                    }
                  },
                  children: [
                    homePrincipale(
                      context,
                      () => qrCodePage(context),
                      () => nfcReaderPage(context),
                    ),
                    homePianificazione(
                      context,
                      state.assets,
                    ),
                  ],
                ),
                Builder(
                  builder: (builderContext) {
                    return buildMenuButton(
                      function: () =>
                          Scaffold.of(builderContext).openEndDrawer(),
                    );
                  },
                ),
                buildBottomTab(
                  pageController,
                  state.page,
                )
              ],
            ),
          )),
        );
      },
    );
  }
}

// Apertura QR Code Pagina
void qrCodePage(BuildContext context) {
  Navigator.of(context).pushNamed(
    AppRoutes.QRCODE_READING,
    arguments: AppRoutes.HOME_PAGE,
  );
}

// Apertura NFC Pagina
void nfcReaderPage(BuildContext context) {
  Navigator.of(context).pushNamed(
    AppRoutes.NFC_READING,
  );
}
