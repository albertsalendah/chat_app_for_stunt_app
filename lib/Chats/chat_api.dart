// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:chat_app_for_stunt_app/Bloc/SocketBloc/socket_bloc.dart';
import 'package:chat_app_for_stunt_app/models/message_model.dart';
import 'package:chat_app_for_stunt_app/models/user.dart';
import 'package:chat_app_for_stunt_app/utils/SessionManager.dart';
import 'package:chat_app_for_stunt_app/utils/config.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../Bloc/KonsultasiBloc/konsultasiBloc.dart';
import '../main.dart';
import 'package:path_provider/path_provider.dart';

import '../utils/sqlite_helper.dart';

class ChatApi {
  ChatApi();
  String link = Configs.LINK;
  final Dio dio = Dio();
  SqliteHelper sqlite = SqliteHelper();
  User user = User();

  void getLatestMessageFromServer(
      {required String senderID, required String receiverID}) async {
    user = await SessionManager.getUser();
    List<MessageModel> data = [];
    try {
      final response = await dio.get(
        '${link}get_latest_self_message',
        data: {'userID': senderID},
      );
      if (response.data != null) {
        data = response.data != null
            ? (response.data as List)
                .map((userJson) => MessageModel.fromJson(userJson))
                .toList()
            : [];
      }
    } on DioException catch (error) {
      if (error.response != null) {
        log('Get Data Anak : ${error.response!.data['error']}');
      } else {
        log('Get Data Anak : ${error.requestOptions.toString()}');
        log('Get Data Anak : ${error.message.toString()}');
      }
    }

    if (data.isNotEmpty) {
      String imagePath = await saveBase64Image(base64String: data.first.image);
      await sqlite
          .saveNewMessage(
              id_message: data.first.idmessage.toString(),
              conversation_id: data.first.conversationId.toString(),
              id_sender: data.first.idsender.toString(),
              id_receiver: data.first.idreceiver.toString(),
              tanggal_kirim: DateFormat('yyyy-MM-dd HH:mm:ss')
                  .format(DateTime.parse(data.first.tanggalkirim.toString())),
              jam_kirim: data.first.jamkirim.toString(),
              message: data.first.message.toString(),
              image: imagePath,
              messageRead: data.first.messageRead)
          .then((res) async {
        if (res != 0) {
          if (navigatorKey.currentContext != null) {
            final socketBloc = BlocProvider.of<SocketProviderBloc>(
                navigatorKey.currentContext!);
            final konsultasiBloc =
                BlocProvider.of<KonsultasiBloc>(navigatorKey.currentContext!);
            socketBloc.messageReceive(
                messageId: data.first.idmessage.toString(),
                senderID: senderID,
                receiverID: receiverID);
            konsultasiBloc.getLatestMesage(userID: user.userID.toString());
            await SessionManager.getCurrentPage().then((currentPage) async {
              log('CURRENT PAGE : $currentPage');
              if (currentPage != null &&
                  currentPage.isNotEmpty &&
                  currentPage == receiverID) {
                await konsultasiBloc.getIndividualMessage(
                    senderID: user.userID.toString(),
                    receiverID: receiverID.toString());
              }
            });
          } else {
            SocketProviderBloc socketBloc = SocketProviderBloc();
            socketBloc.connectSocket(userID: senderID);
            socketBloc.messageReceive(
                messageId: data.first.idmessage.toString(),
                senderID: senderID,
                receiverID: receiverID);
          }
          sqlite.deleteSingleChatServer(
              id_message: data.first.idmessage.toString());
        }
      });
    }
  }

  Future<MessageModel> sendMessage(
      {required String id_sender,
      required String id_receiver,
      required String message,
      required String image,
      required String fcm_token,
      required String title}) async {
    String imagePath = await saveBase64Image(base64String: image);
    MessageModel res = await sqlite.sendMessage(
        conversation_id: '$id_receiver-$id_sender',
        id_sender: id_sender,
        id_receiver: id_receiver,
        tanggal_kirim: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
        jam_kirim: DateFormat.Hm().format(DateTime.now()),
        message: message,
        image: imagePath,
        messageRead: null);
    if (res.idmessage != null && res.idmessage!.isNotEmpty) {
      return res;
    } else {
      return MessageModel();
    }
  }

  Future<void> saveMesagetoServer(
      {required MessageModel entry,
      required String fcm_token,
      required String title}) async {
    String image = await fileToBase64(entry.image.toString());
    try {
      final response = await dio.post(
        '${link}send_message',
        data: {
          "id_message": entry.idmessage,
          "conversation_id": '${entry.idreceiver}-${entry.idsender}',
          "id_sender": entry.idsender,
          "id_receiver": entry.idreceiver,
          "tanggal_kirim": entry.tanggalkirim,
          "jam_kirim": entry.jamkirim,
          "message": entry.message,
          "image": image,
          "messageRead": 0,
          "fcm_token": fcm_token,
          "title": title,
        },
      );
      // await sqlite.updateStatusChat(
      //     messageRead: 0, id_message: entry.idmessage.toString());
      log('Server Message : ${response.data['message']}');
    } on DioException catch (error) {
      if (error.response != null) {
        log(error.response!.data['error']);
      } else {
        log(error.requestOptions.toString());
        log(error.message.toString());
      }
      await sqlite.updateStatusChat(
          messageRead: null, id_message: entry.idmessage.toString());
    }
  }

  Future<String> fileToBase64(String path) async {
    String base64Image = '';
    if (path.isNotEmpty) {
      File imageFile = File(path);
      List<int> imageBytes = imageFile.readAsBytesSync();
      base64Image = base64Encode(imageBytes);
    }
    return base64Image;
  }

  Future<String> saveBase64Image({String? base64String}) async {
    if (base64String != null && base64String.isNotEmpty) {
      Uint8List bytes = base64.decode(base64String);
      String dir = (await getApplicationDocumentsDirectory()).path;
      File file = File('$dir/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await file.writeAsBytes(bytes);
      return file.path;
    } else {
      return '';
    }
  }
}
