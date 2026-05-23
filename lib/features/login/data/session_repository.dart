import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginSession {
  final String username;
  final String token;

  const LoginSession({required this.username, required this.token});
}

class SessionRepository {
  static const _usernameKey = 'session_username';
  static const _tokenKey = 'session_token';

  Future<LoginSession?> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString(_usernameKey);
    final token = prefs.getString(_tokenKey);
    if (username == null || token == null) return null;
    return LoginSession(username: username, token: token);
  }

  Future<String> login({
  required String username,
  required String password,
}) async {
  final response = await http.post(
    Uri.parse('https://fakestoreapi.com/auth/login'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'username': username,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['token'];
  } else {
    throw Exception('Login gagal');
  }
}

  Future<void> saveSession({required String username, required String token}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameKey, username);
    await prefs.setString(_tokenKey, token);
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_usernameKey);
    await prefs.remove(_tokenKey);
  }
}
