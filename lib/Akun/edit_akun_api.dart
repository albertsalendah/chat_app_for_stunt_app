import 'dart:developer';
import 'dart:typed_data';

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

  Future<API_Message> updateNo(
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
      return API_Message(status: true, message: response.data['message']);
    } on DioException catch (error) {
      if (error.response != null) {
        log(error.response!.data['error']);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        log(error.requestOptions.toString());
        log(error.message.toString());
      }
      return API_Message(status: false, message: error.response?.data['error']);
    }
  }

  Future<API_Message> updateKeterangan(
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

  Future<API_Message> updateEmail(
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
      return API_Message(status: true, message: response.data['message']);
    } on DioException catch (error) {
      if (error.response != null) {
        log(error.response!.data['error']);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        log(error.requestOptions.toString());
        log(error.message.toString());
      }
      return API_Message(status: false, message: error.response?.data['error']);
    }
  }

  Future<API_Message> updateFoto(
      {required String userID,
      required String oldpath,
      Uint8List? foto,
      required String token}) async {
    try {
      dio.options.headers['x-access-token'] = token;
      FormData formData = FormData.fromMap({
        'userID': userID,
        'oldpath': oldpath,
        'foto': foto != null
            ? MultipartFile.fromBytes(foto, filename: '$userID.jpg')
            : null,
      });
      final response = await dio.post(
        '${link}update_foto',
        data: formData,
      );
      return API_Message(status: true, message: response.data['message']);
    } on DioException catch (error) {
      if (error.response != null) {
        log('Update Foto : ${error.response!.data['error']}');
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        log(error.requestOptions.toString());
        log(error.message.toString());
      }
      return API_Message(status: false, message: error.message.toString());
    }
  }

  Future<API_Message> updatePassword(
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

  Future<API_Message> cekPasswordLama(
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
      return API_Message(status: true, message: response.data['massage']);
    } on DioException catch (error) {
      if (error.response != null) {
        log(error.response!.data['error']);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        log(error.requestOptions.toString());
        log(error.message.toString());
      }
      return API_Message(status: false, message: error.response!.data['error']);
    }
  }

  Future<API_Message> hapusAkun(
      {required String userID, required String token}) async {
    try {
      dio.options.headers['x-access-token'] = token;
      final response = await dio.post(
        '${link}hapus_akun',
        data: {'userID': userID},
      );
      return API_Message(status: true, message: response.data['massage']);
    } on DioException catch (error) {
      if (error.response != null) {
        log(error.response!.data['error']);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        log(error.requestOptions.toString());
        log(error.message.toString());
      }
      return API_Message(status: false, message: error.response!.data['error']);
    }
  }
}
