import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mobile_scanner/mobile_scanner.dart';

import '/common/widgets/background_view.dart';
import '/common/widgets/flutter_toast.dart';

import '/pages/qrcode_reader/bloc/qrcode_r_blocs.dart';
import '/pages/qrcode_reader/bloc/qrcode_r_events.dart';
import '/pages/qrcode_reader/bloc/qrcode_r_states.dart';

import '/pages/qrcode_reader/qrcode_reader_controller.dart';

class QrCodeReaderPage extends StatefulWidget {
  const QrCodeReaderPage({super.key});

  @override
  State<QrCodeReaderPage> createState() => _QrCodeReaderPageState();
}

class _QrCodeReaderPageState extends State<QrCodeReaderPage> {
  late QRCodeReaderController _controller;

  @override
  void didChangeDependencies() {
    _controller = QRCodeReaderController(context: context);
    _controller.init();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<QRCodeReaderBloc, QRCodeReaderState>(
      listener: (context, state) {
        if (state.qrCodeDati.isNotEmpty) {
          // Estraggo i dati tramite il controller QRCodeReaderController
          _controller.estraiDatiQRCode();
        }
      },
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          foregroundColor: Colors.blue,
          onPressed: () {
            // TODO: TEST PER SKIPPARE LA CONFIGURAZIONE DA TOGLIERE IN PROD
            // context.read<QRCodeReaderBloc>().add(
            //       const QRCodeDatiEvent(
            //         "https://demo-4.in-am.it/gmaoCS04?username=DEMO",
            //       ),
            //     );
            Navigator.pop(context);
          },
          child: const Icon(Icons.expand_more),
        ),
        body: BackgroundView(
          child: MobileScanner(
            controller: MobileScannerController(
              detectionSpeed: DetectionSpeed.noDuplicates,
              facing: CameraFacing.back,
              torchEnabled: false,
            ),
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                // Assegno alla lettura il valore presente nel qr code
                String? lettura = barcode.rawValue;

                if (lettura != null) {
                  try {
                    // Aggiorno il bloc QRCodeReaderBloc passando i dati del qrcode
                    context.read<QRCodeReaderBloc>().add(
                          QRCodeDatiEvent(lettura),
                        );
                  } catch (error) {
                    toastInfo(msg: "Il QR Code non è valido");
                  }
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
