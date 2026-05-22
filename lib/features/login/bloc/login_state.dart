import 'package:equatable/equatable.dart';

import '../../../core/models/load_status.dart';

class LoginState extends Equatable {
  final String email;
  final String password;
  final LoadStatus status;
  final String? message;
  final bool isAuthenticated;
  final String? savedEmail;
  final bool sessionLoaded;

  const LoginState({
    required this.email,
    required this.password,
    required this.status,
    required this.isAuthenticated,
    required this.sessionLoaded,
    this.message,
    this.savedEmail,
  });

  const LoginState.initial()
      : email = '',
        password = '',
        status = LoadStatus.initial,
        message = null,
        isAuthenticated = false,
        savedEmail = null,
        sessionLoaded = false;

  bool get isEmailValid => RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(email);
  bool get isPasswordValid => password.length >= 6;
  bool get canSubmit => isEmailValid && isPasswordValid;

  LoginState copyWith({
    String? email,
    String? password,
    LoadStatus? status,
    String? message,
    bool? isAuthenticated,
    String? savedEmail,
    bool? sessionLoaded,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      message: message,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      savedEmail: savedEmail ?? this.savedEmail,
      sessionLoaded: sessionLoaded ?? this.sessionLoaded,
    );
  }

  @override
  List<Object?> get props => [email, password, status, message, isAuthenticated, savedEmail, sessionLoaded];
}
