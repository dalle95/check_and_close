import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import 'qrcode_r_events.dart';
import 'qrcode_r_states.dart';

class QRCodeReaderBloc extends Bloc<QrCodeReaderEvent, QRCodeReaderState> {
  QRCodeReaderBloc() : super(const QRCodeReaderState()) {
    on<QRCodeDatiEvent>(_datiEvent);
  }

  void _datiEvent(QRCodeDatiEvent event, Emitter<QRCodeReaderState> emit) {
    Logger().d("Dati QRCode: ${event.qrCodeDati}");
    emit(state.copyWith(qrCodeDati: event.qrCodeDati));
  }
}
