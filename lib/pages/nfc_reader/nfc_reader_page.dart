import 'package:flutter/material.dart';

import '/common/widgets/background_view.dart';
import '/common/routes/names.dart';
import '/common/widgets/menu_button.dart';

class NfcReaderPage extends StatelessWidget {
  const NfcReaderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = {
      "page": AppRoutes.NFC_READING,
      "assetCodice": "MATERIAL_TEST-1",
    };
    // Implementa qui la pagina per il rilevamento NFC
    return Scaffold(
      body: Stack(
        children: [
          // Background
          const BackgroundView(),
          buildBackButton(context),
          Center(
            child: SingleChildScrollView(
              child: SizedBox(
                width: 250,
                height: 250,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).primaryColor,
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 25,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // Più squadrato
                    ),
                    elevation: 10,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      AppRoutes.WO_LIST,
                      arguments: arguments,
                    );
                  },
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.nfc,
                        size: 150,
                      ),
                      Text(
                        'Lettura NFC',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
