// ignore_for_file: camel_case_types, non_constant_identifier_names
import 'dart:developer';

import 'package:dio/dio.dart';

import '../../models/api_massage.dart';
import '../../utils/SessionManager.dart';
import '../../utils/config.dart';
import '../../utils/firebase_api.dart';
import '../models/user.dart';

class Login_Register_Api {
  Login_Register_Api();
  static const String link = Configs.LINK;
  final Dio dio = Dio();

  Future<API_Massage> login({
    required String noHp,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        '${link}login',
        data: {'no_hp': noHp, 'password': password, 'health_worker': true},
      );
      dynamic token = response.data['token'];
      User user = User.fromJson(response.data['user']);
      String? fcm_token = await FirebaseApi().getTokenFCM();
      if (fcm_token != null) {
        if (user.fcm_token != fcm_token) {
          updateTokenFCM(userID: user.userID ?? '', fcm_token: fcm_token);
          log('Updated Token');
        }
      }
      await SessionManager.saveToken(token);
      await SessionManager.saveUser(user);
      return API_Massage(status: true, message: '');
    } on DioException catch (error) {
      if (error.response != null) {
        log(error.response!.data['error'].toString());
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        log(error.requestOptions.toString());
        log(error.message.toString());
      }
      return API_Massage(status: false, message: error.response!.data['error']);
    }
  }

  Future<API_Massage> registerUser(
      {required String nama,
      required String noHp,
      required String email,
      required String password,
      String? fcm_token,
      String? foto,
      String? keterangan}) async {
    try {
      final response = await dio.post(
        '${link}register',
        data: {
          'nama': nama,
          'no_hp': noHp,
          'email': email,
          'password': password,
          'fcm_token': fcm_token,
          'foto': foto,
          'keterangan': keterangan,
          'health_worker': true
        },
      );
      return API_Massage(status: true, message: response.data['message']);
    } on DioException catch (error) {
      log('Error registering user: $error');
      return API_Massage(status: false, message: error.response!.data['error']);
    }
  }

  Future<API_Massage> updateTokenFCM(
      {required String userID, required String fcm_token}) async {
    try {
      final response = await dio.post(
        '${link}update_token_fcm',
        data: {
          'userID': userID,
          "fcm_token": fcm_token,
        },
      );
      return API_Massage(status: true, message: response.data['message']);
    } on DioException catch (error) {
      if (error.response != null) {
        log(error.response!.data['error']);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        log(error.requestOptions.toString());
        log(error.message.toString());
      }
      return API_Massage(status: false, message: error.message.toString());
    }
  }
}
