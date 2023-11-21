// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:dio/dio.dart';
import '../../models/api_massage.dart';
import '../../utils/config.dart';
import '../models/rekomendasiMenuMakan.dart';

class MenuMakanAPI {
  MenuMakanAPI();

  static const String link = Configs.LINK;
  final Dio dio = Dio();

  Future<List<RekomendasiMenuMakan>> getListMenuMakan(
      {required String user_id, required String token}) async {
    List<RekomendasiMenuMakan> data = [];
    try {
      dio.options.headers['x-access-token'] = token;
      final response = await dio.get(
        '${link}list_rekomendasi_menu_makan',
        data: {'user_id': user_id},
      );
      if (response.data != null) {
        data = response.data != null
            ? (response.data as List)
                .map((userJson) => RekomendasiMenuMakan.fromJson(userJson))
                .toList()
            : [];
      }
      return data;
    } on DioException catch (error) {
      if (error.response != null) {
        log('Get Data Anak : ${error.response!.data['error']}');
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        log('Get Data Anak : ${error.requestOptions.toString()}');
        log('Get Data Anak : ${error.message.toString()}');
      }
      return data;
    }
  }

  Future<API_Massage> addMenuMakan(
      {required String user_id,
      required int menu_makan,
      required String jam_makan,
      String? makan_pokok,
      String? jumlah_mk,
      String? satuan_mk,
      String? sayur,
      String? jumlah_sayur,
      String? satuan_sayur,
      String? lauk_hewani,
      String? jumlah_lauk_hewani,
      String? satuan_lauk_hewani,
      String? lauk_nabati,
      String? jumlah_lauk_nabati,
      String? satuan_lauk_nabati,
      String? buah,
      String? jumlah_buah,
      String? satuan_buah,
      String? minuman,
      String? jumlah_minuman,
      String? satuan_minuman,
      required String token}) async {
    try {
      dio.options.headers['x-access-token'] = token;
      final response = await dio.post(
        '${link}tambah_rekomendasi_menu_makan',
        data: {
          'user_id': user_id,
          'menu_makan': menu_makan,
          'jam_makan': jam_makan,
          'makanan_pokok': makan_pokok,
          'jumlah_mk': jumlah_mk,
          'satuan_mk': satuan_mk,
          'sayur': sayur,
          'jumlah_sayur': jumlah_sayur,
          'satuan_sayur': satuan_sayur,
          'lauk_hewani': lauk_hewani,
          'jumlah_lauk_hewani': jumlah_lauk_hewani,
          'satuan_lauk_hewani': satuan_lauk_hewani,
          'lauk_nabati': lauk_nabati,
          'jumlah_lauk_nabati': jumlah_lauk_nabati,
          'satuan_lauk_nabati': satuan_lauk_nabati,
          'buah': buah,
          'jumlah_buah': jumlah_buah,
          'satuan_buah': satuan_buah,
          'minuman': minuman,
          'jumlah_minuman': jumlah_minuman,
          'satuan_minuman': satuan_minuman
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

  Future<API_Massage> updateMenuMakan(
      {required String id_menu,
      required int menu_makan,
      required String jam_makan,
      String? makan_pokok,
      String? jumlah_mk,
      String? satuan_mk,
      String? sayur,
      String? jumlah_sayur,
      String? satuan_sayur,
      String? lauk_hewani,
      String? jumlah_lauk_hewani,
      String? satuan_lauk_hewani,
      String? lauk_nabati,
      String? jumlah_lauk_nabati,
      String? satuan_lauk_nabati,
      String? buah,
      String? jumlah_buah,
      String? satuan_buah,
      String? minuman,
      String? jumlah_minuman,
      String? satuan_minuman,
      required String token}) async {
    try {
      dio.options.headers['x-access-token'] = token;
      final response = await dio.post(
        '${link}update_rekomendasi_menu_makan',
        data: {
          'id_menu': id_menu,
          'menu_makan': menu_makan,
          'jam_makan': jam_makan,
          'makan_pokok': makan_pokok,
          'jumlah_mk': jumlah_mk,
          'satuan_mk': satuan_mk,
          'sayur': sayur,
          'jumlah_sayur': jumlah_sayur,
          'satuan_sayur': satuan_sayur,
          'lauk_hewani': lauk_hewani,
          'jumlah_lauk_hewani': jumlah_lauk_hewani,
          'satuan_lauk_hewani': satuan_lauk_hewani,
          'lauk_nabati': lauk_nabati,
          'jumlah_lauk_nabati': jumlah_lauk_nabati,
          'satuan_lauk_nabati': satuan_lauk_nabati,
          'buah': buah,
          'jumlah_buah': jumlah_buah,
          'satuan_buah': satuan_buah,
          'minuman': minuman,
          'jumlah_minuman': jumlah_minuman,
          'satuan_minuman': satuan_minuman
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
