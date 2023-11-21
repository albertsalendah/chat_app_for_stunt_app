import 'dart:developer';

import 'package:dio/dio.dart';
import '../../models/api_massage.dart';
import '../../models/user.dart';
import '../../utils/config.dart';

class EditAkunApi {
  EditAkunApi();

  static const String link = Configs.LINK;
  final Dio dio = Dio();
  User data = User();

  Future<User> getDataUser(
      {required String userID, required String token}) async {
    try {
      dio.options.headers['x-access-token'] = token;
      final response = await dio.get(
        '${link}get_data_user',
        data: {'userID': userID},
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

  Future<API_Massage> updateNo(
      {required String userID,
      required String no_hp,
      required String token}) async {
    try {
      dio.options.headers['x-access-token'] = token;
      final response = await dio.post(
        '${link}update_nomor',
        data: {
          'userID': userID,
          "no_hp": no_hp,
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

  Future<API_Massage> updateKeterangan(
      {required String userID,
      required String keterangan,
      required String token}) async {
    try {
      dio.options.headers['x-access-token'] = token;
      final response = await dio.post(
        '${link}update_keterangan',
        data: {
          'userID': userID,
          "keterangan": keterangan,
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

  Future<API_Massage> updateEmail(
      {required String userID,
      required String email,
      required String token}) async {
    try {
      dio.options.headers['x-access-token'] = token;
      final response = await dio.post(
        '${link}update_email',
        data: {
          'userID': userID,
          "email": email,
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

  Future<API_Massage> updateFoto(
      {required String userID, String? foto, required String token}) async {
    try {
      dio.options.headers['x-access-token'] = token;
      final response = await dio.post(
        '${link}update_foto',
        data: {
          'userID': userID,
          "foto": foto,
        },
      );
      return API_Massage(status: true, message: response.data['message']);
    } on DioException catch (error) {
      if (error.response != null) {
        log('Update Foto : ${error.response!.data['error']}');
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        log(error.requestOptions.toString());
        log(error.message.toString());
      }
      return API_Massage(status: false, message: error.message.toString());
    }
  }

  Future<API_Massage> updatePassword(
      {required String userID,
      required String password,
      required String token}) async {
    try {
      dio.options.headers['x-access-token'] = token;
      final response = await dio.post(
        '${link}update_password',
        data: {
          'userID': userID,
          "password": password,
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

  Future<API_Massage> cekPasswordLama(
      {required String noHp,
      required String password,
      required String token}) async {
    try {
      dio.options.headers['x-access-token'] = token;
      final response = await dio.post(
        '${link}cek_password',
        data: {
          'no_hp': noHp,
          'password': password,
        },
      );
      return API_Massage(status: true, message: response.data['massage']);
    } on DioException catch (error) {
      if (error.response != null) {
        log(error.response!.data['error']);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        log(error.requestOptions.toString());
        log(error.message.toString());
      }
      return API_Massage(status: false, message: error.response!.data['error']);
    }
  }

  Future<API_Massage> hapusAkun(
      {required String userID, required String token}) async {
    try {
      dio.options.headers['x-access-token'] = token;
      final response = await dio.post(
        '${link}hapus_akun',
        data: {'userID': userID},
      );
      return API_Massage(status: true, message: response.data['massage']);
    } on DioException catch (error) {
      if (error.response != null) {
        log(error.response!.data['error']);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        log(error.requestOptions.toString());
        log(error.message.toString());
      }
      return API_Massage(status: false, message: error.response!.data['error']);
    }
  }
}
