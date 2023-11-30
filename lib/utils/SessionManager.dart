// ignore_for_file: file_names

import 'dart:convert';

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
//import 'dart:html';

class SessionManager {
  static const String _keyToken = 'token';
  static const String _keyLastActive = 'last_active';
  static const String _keyUser = 'user_data';
  static const String _keyDataAnak = 'data_anak';

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
    await updateLastActive();
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  static Future<void> updateLastActive() async {
    final prefs = await SharedPreferences.getInstance();
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    await prefs.setInt(_keyLastActive, currentTime);
  }

  static Future<bool> isUserLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  static Future<bool> isSessionExpired() async {
    final prefs = await SharedPreferences.getInstance();
    bool isExpired = false;
    if (prefs.getString('token') != null) {
      isExpired = JwtDecoder.isExpired(prefs.getString('token')!);
    }
    return isExpired;
  }

  static Future<bool> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyLastActive);
    await prefs.remove(_keyUser);
    await prefs.remove(_keyDataAnak);
    bool check = await isUserLoggedIn();
    if (check) {
      return true;
    } else {
      return false;
    }
  }

  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUser, json.encode(user));
  }

  static Future<User> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString(_keyUser);
    try {
      if (userJson != null) {
        User user = User.fromJson(json.decode(userJson));
        return user;
      } else {
        return User();
      }
    } catch (e) {
      return User();
    }
  }

  static Future<void> removeUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUser);
  }

  static Future<void> saveCurrentPage(String receiverId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentPage', receiverId);
  }

  static Future<String?> getCurrentPage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('currentPage');
  }

  static Future<void> removeCurrentPage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('currentPage');
  }
}
