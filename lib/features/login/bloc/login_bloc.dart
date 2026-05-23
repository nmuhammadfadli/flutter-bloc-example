import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/load_status.dart';
import '../data/session_repository.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final SessionRepository sessionRepository;

  LoginBloc(this.sessionRepository) : super(const LoginState.initial()) {
    on<LoginStarted>(_onStarted);
    on<LoginUsernameChanged>(_onUsernameChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
    on<LoginLoggedOut>(_onLoggedOut);
  }

  Future<void> _onStarted(LoginStarted event, Emitter<LoginState> emit) async {
    emit(state.copyWith(status: LoadStatus.loading, message: null));
    final session = await sessionRepository.loadSession();
    if (session == null) {
      emit(state.copyWith(status: LoadStatus.initial, sessionLoaded: true));
      return;
    }

    emit(
      state.copyWith(
        status: LoadStatus.success,
        isAuthenticated: true,
        savedUsername: session.username,
        sessionLoaded: true,
        message: 'Session login berhasil dimuat dari sharedpreferences',
      ),
    );
  }

  void _onUsernameChanged(LoginUsernameChanged event, Emitter<LoginState> emit) {
    emit(
      state.copyWith(
        username: event.username,
        status: LoadStatus.initial,
        message: null,
      ),
    );
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(
      state.copyWith(
        password: event.password,
        status: LoadStatus.initial,
        message: null,
      ),
    );
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (!state.canSubmit) {
      emit(
        state.copyWith(
          status: LoadStatus.failure,
          message: 'Username atau password belum valid.',
        ),
      );
      return;
    }

    emit(state.copyWith(status: LoadStatus.loading, message: null));
    try {

  emit(
    state.copyWith(
      status: LoadStatus.loading,
      message: null,
    ),
  );

  final token = await sessionRepository.login(
    username: state.username,
    password: state.password,
  );

  await sessionRepository.saveSession(
    username: state.username,
    token: token,
  );

  emit(
    state.copyWith(
      status: LoadStatus.success,
      isAuthenticated: true,
      savedUsername: state.username,
      message: 'Login berhasil dari API.',
    ),
  );

} catch (e) {

  emit(
    state.copyWith(
      status: LoadStatus.failure,
      message: 'Username atau password salah',
    ),
  );
}

    emit(
      state.copyWith(
        status: LoadStatus.success,
        isAuthenticated: true,
        savedUsername: state.username,
        message:
            'Login berhasil',
      ),
    );
  }

  Future<void> _onLoggedOut(
    LoginLoggedOut event,
    Emitter<LoginState> emit,
  ) async {
    await sessionRepository.clearSession();
    final nextState = LoginState.initial().copyWith(
      status: LoadStatus.success,
      message: 'Berhasil logout',
      sessionLoaded: true,
    );
    emit(nextState);
  }
}
