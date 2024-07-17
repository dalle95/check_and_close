import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_events.dart';
import 'auth_states.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState()) {
    on<UsernameEvent>(_usernameEvent);

    on<PasswordEvent>(_passwordEvent);
  }

  void _usernameEvent(UsernameEvent event, Emitter<AuthState> emit) {
    //Logger().d("Username ${event.username}");
    emit(state.copyWith(username: event.username));
  }

  void _passwordEvent(PasswordEvent event, Emitter<AuthState> emit) {
    //Logger().d("Password ${event.password}");
    emit(state.copyWith(password: event.password));
  }
}
