import 'package:flutter_bloc/flutter_bloc.dart';

import 'wo_list_events.dart';
import 'wo_list_states.dart';

class WOListBloc extends Bloc<WOListEvent, WOListState> {
  WOListBloc() : super(const WOListState()) {
    on<WOListDatiEvent>(_aggiornaDatiEvent);
  }

  void _aggiornaDatiEvent(WOListDatiEvent event, Emitter<WOListState> emit) {
    emit(
      state.copyWith(
        wo: event.wo,
      ),
    );
  }
}
