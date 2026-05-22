import 'package:shared_preferences/shared_preferences.dart';

class LoginSession {
  final String email;
  final String token;

  const LoginSession({required this.email, required this.token});
}

class SessionRepository {
  static const _emailKey = 'session_email';
  static const _tokenKey = 'session_token';

  Future<LoginSession?> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_emailKey);
    final token = prefs.getString(_tokenKey);
    if (email == null || token == null) return null;
    return LoginSession(email: email, token: token);
  }

  Future<void> saveSession({required String email, required String token}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email);
    await prefs.setString(_tokenKey, token);
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_emailKey);
    await prefs.remove(_tokenKey);
  }
}
