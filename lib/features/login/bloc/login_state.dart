import 'package:equatable/equatable.dart';

import '../../../core/models/load_status.dart';

class LoginState extends Equatable {
  final String email;
  final String password;
  final LoadStatus status;
  final String? message;

  const LoginState({
    required this.email,
    required this.password,
    required this.status,
    this.message,
  });

  const LoginState.initial()
    : email = '',
      password = '',
      status = LoadStatus.initial,
      message = null;

  bool get isEmailValid => RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(email);
  bool get isPasswordValid => password.length >= 6;
  bool get canSubmit => isEmailValid && isPasswordValid;

  LoginState copyWith({
    String? email,
    String? password,
    LoadStatus? status,
    String? message,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      message: message,
    );
  }

  @override
  List<Object?> get props => [email, password, status, message];
}
