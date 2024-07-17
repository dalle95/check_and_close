import 'package:flutter_bloc/flutter_bloc.dart';

import '/common/entities/woprocess.dart';

import 'wo_detail_events.dart';
import 'wo_detail_states.dart';

class WODetailBloc extends Bloc<WODetailEvent, WODetailState> {
  WODetailBloc() : super(const WODetailState()) {
    on<WODetailDatiEvent>(_downloadDatiEvent);
    on<WOUpdateDetailDatiEvent>(_aggiornaDatiEvent);
  }

  void _downloadDatiEvent(
    WODetailDatiEvent event,
    Emitter<WODetailState> emit,
  ) {
    emit(
      state.copyWith(
        wo: event.wo,
        woprocess: event.woprocess,
      ),
    );
  }

  void _aggiornaDatiEvent(
    WOUpdateDetailDatiEvent event,
    Emitter<WODetailState> emit,
  ) {
    List<WOProcess>? lista = state.woprocess;
    WOProcess? woProcessAggiornata = event.woprocess!;

    // Controllo la lista di WOProcesse e aggiorno quella modificata
    for (int i = 0; i < lista!.length; i++) {
      if (lista[i].id == woProcessAggiornata.id) {
        lista[i] = woProcessAggiornata;
        break;
      }
    }
    emit(
      state.copyWith(
        wo: state.wo,
        woprocess: lista,
      ),
    );
  }
}
