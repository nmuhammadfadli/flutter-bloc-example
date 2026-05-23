import 'package:equatable/equatable.dart';

import '../../../core/models/load_status.dart';

class LoginState extends Equatable {
  final String username;
  final String password;
  final LoadStatus status;
  final String? message;
  final bool isAuthenticated;
  final String? savedUsername;
  final bool sessionLoaded;

  const LoginState({
    required this.username,
    required this.password,
    required this.status,
    required this.isAuthenticated,
    required this.sessionLoaded,
    this.message,
    this.savedUsername,
  });

  const LoginState.initial()
      : username = '',
        password = '',
        status = LoadStatus.initial,
        message = null,
        isAuthenticated = false,
        savedUsername = null,
        sessionLoaded = false;

  bool get isUsernameValid => username.trim().isNotEmpty;

  bool get isPasswordValid => password.length >= 6;

  bool get canSubmit =>
      isUsernameValid && isPasswordValid;

  LoginState copyWith({
    String? username,
    String? password,
    LoadStatus? status,
    String? message,
    bool? isAuthenticated,
    String? savedUsername,
    bool? sessionLoaded,
  }) {
    return LoginState(
      username: username ?? this.username,
      password: password ?? this.password,
      status: status ?? this.status,
      message: message,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      savedUsername: savedUsername ?? this.savedUsername,
      sessionLoaded: sessionLoaded ?? this.sessionLoaded,
    );
  }

  @override
  List<Object?> get props => [username, password, status, message, isAuthenticated, savedUsername, sessionLoaded];
}
