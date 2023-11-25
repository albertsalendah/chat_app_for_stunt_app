import 'dart:developer';

import 'package:chat_app_for_stunt_app/models/api_massage.dart';
import 'package:chat_app_for_stunt_app/models/user.dart';
import 'package:dio/dio.dart';

import '../../utils/config.dart';

class LupaPasswordApi {
  LupaPasswordApi();
  static const String link = Configs.LINK;
  final Dio dio = Dio();

  Future<bool> sendEmail(
      {required String to,
      required String code,
      required String subject}) async {
    try {
      final response = await dio.post(
        '${link}send_email',
        data: {'to': to, "code": code, "subject": subject},
      );
      return response.data['status'];
    } on DioException catch (error) {
      if (error.response != null) {
        log(error.response!.data['error']);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        log(error.requestOptions.toString());
        log(error.message.toString());
      }
      return false;
    }
  }

  Future<User> getDataUser({required String noHp}) async {
    User data = User();
    try {
      final response = await dio.get(
        '${link}get_user_byNo',
        data: {'noHp': noHp},
      );
      if (response.data != null) {
        data = User.fromJson(response.data);
      }
      return data;
    } on DioException catch (error) {
      if (error.response != null) {
        log(error.response!.data['error']);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        log(error.requestOptions.toString());
        log(error.message.toString());
      }
      return data;
    }
  }

  Future<API_Message> updatePassword(
      {required String userID, required String password}) async {
    try {
      final response = await dio.post(
        '${link}reset_password',
        data: {
          'userID': userID,
          "password": password,
        },
      );
      return API_Message(status: true, message: response.data['message']);
    } on DioException catch (error) {
      if (error.response != null) {
        log(error.response!.data['error']);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        log(error.requestOptions.toString());
        log(error.message.toString());
      }
      return API_Message(status: false, message: error.message.toString());
    }
  }
}
