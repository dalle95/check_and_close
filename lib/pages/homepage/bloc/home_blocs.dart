import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_events.dart';
import 'home_states.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<HomeDatiEvent>(_homeDatiEvent);
  }

  void _homeDatiEvent(HomeDatiEvent event, Emitter<HomeState> emit) {
    emit(
      state.copyWith(
        assets: event.assets,
        page: event.page,
      ),
    );
  }
}
