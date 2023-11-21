import 'dart:developer';
import 'package:chat_app_for_stunt_app/models/message_model.dart';
import 'package:chat_app_for_stunt_app/utils/config.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '../models/api_massage.dart';

class ChatApi {
  ChatApi();
  String link = Configs.LINK;
  final Dio dio = Dio();

  Future<List<MessageModel>> getListLatestMessage(
      {required String userID, required String token}) async {
    List<MessageModel> data = [];
    try {
      dio.options.headers['x-access-token'] = token;
      final response = await dio.get(
        '${link}get_latest_self_message_doc',
        data: {'userID': userID},
      );
      if (response.data != null) {
        data = response.data != null
            ? (response.data as List)
                .map((userJson) => MessageModel.fromJson(userJson))
                .toList()
            : [];
      } else {
        data = [];
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

  Future<List<MessageModel>> getIndividualMessage(
      {required String senderID,
      required String receiverID,
      required String token}) async {
    List<MessageModel> data = [];
    try {
      dio.options.headers['x-access-token'] = token;
      final response = await dio.get(
        '${link}get_individual_message',
        data: {'senderID': senderID, 'receiverID': receiverID},
      );
      if (response.data != null) {
        data = response.data != null
            ? (response.data as List)
                .map((userJson) => MessageModel.fromJson(userJson))
                .toList()
            : [];
      } else {
        data = [];
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

  Future<API_Massage> sendMessage(
      {required String id_sender,
      required String id_receiver,
      required String message,
      required String image,
      required String fcm_token,
      required String title,
      required String token}) async {
    try {
      dio.options.headers['x-access-token'] = token;
      final response = await dio.post(
        '${link}send_message',
        data: {
          "id_sender": id_sender,
          "id_receiver": id_receiver,
          "tanggal_kirim": DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
          "jam_kirim": DateFormat.Hm().format(DateTime.now()),
          "message": message,
          "image": image,
          "messageRead": 0,
          "fcm_token": fcm_token,
          "title": title,
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
