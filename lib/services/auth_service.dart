import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import '../core/constants/app_constants.dart';
import '../models/user_profile.dart';

class AuthService {
  static final _supabase = Supabase.instance.client;

  static String get apiBaseUrl {
    if (kIsWeb) return AppConstants.apiBaseUrlWeb;
    return AppConstants.apiBaseUrlAndroid;
  }

  static Session? get currentSession => _supabase.auth.currentSession;

  static User? get currentUser => _supabase.auth.currentUser;

  static Future<void> login({
    required String email,
    required String password,
  }) async {
    await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  static Future<void> signup({
    required String email,
    required String password,
    required String name,
  }) async {
    await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {'name': name},
    );
  }

  static Future<void> logout() async {
    await _supabase.auth.signOut();
  }

  static Future<UserProfile?> fetchProfile() async {
    final session = currentSession;
    if (session == null) return null;

    final response = await http.get(
      Uri.parse('$apiBaseUrl/profile'),
      headers: {
        'Authorization': 'Bearer ${session.accessToken}',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch profile');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return UserProfile.fromJson(data['profile'] as Map<String, dynamic>);
  }

  static Future<void> updateStats(String decision) async {
    final session = currentSession;
    if (session == null) return;

    await http.post(
      Uri.parse('$apiBaseUrl/update-stats'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${session.accessToken}',
      },
      body: jsonEncode({'decision': decision}),
    );
  }
}
