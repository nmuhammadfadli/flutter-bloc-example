import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/load_status.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState.initial()) {
    on<LoginEmailChanged>(
      (event, emit) => emit(
        state.copyWith(
          email: event.email,
          status: LoadStatus.initial,
          message: null,
        ),
      ),
    );
    on<LoginPasswordChanged>(
      (event, emit) => emit(
        state.copyWith(
          password: event.password,
          status: LoadStatus.initial,
          message: null,
        ),
      ),
    );
    on<LoginSubmitted>((event, emit) {
      if (!state.canSubmit) {
        emit(
          state.copyWith(
            status: LoadStatus.failure,
            message: 'Email atau password belum valid.',
          ),
        );
        return;
      }
      emit(state.copyWith(status: LoadStatus.loading, message: null));
      emit(state.copyWith(status: LoadStatus.success, message: 'Login valid.'));
    });
  }
}
