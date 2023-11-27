// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:chat_app_for_stunt_app/utils/random_String.dart';
import 'package:dio/dio.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import '../models/message_model.dart';
import '../models/user.dart';
import 'config.dart';

class SqliteHelper {
  final Dio dio = Dio();
  static const String link = Configs.LINK;
  static Database? _database;
  static const String tableName = 'messages';

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<String> get fullPath async {
    log('DataBase Created');
    String databasePath = await getDatabasesPath();
    String fullpath = path.join(databasePath, 'stunt_app.db');
    return fullpath;
  }

  Future<Database> initDatabase() async {
    final fullpath = await fullPath;
    return openDatabase(
      fullpath,
      version: 1,
      singleInstance: true,
      onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE $tableName ( id_message VARCHAR(128) PRIMARY KEY, conversation_id VARCHAR(128),id_sender VARCHAR(32),id_receiver VARCHAR(32), tanggal_kirim DATETIME,jam_kirim VARCHAR(10),message VARCHAR(255), image LONGTEXT NULL, messageRead INTEGER(1))');
        await db.execute('PRAGMA cache_size = -100000000;');
        log('Table $tableName created successfully!');
      },
    );
  }

  Future<MessageModel> sendMessage(
      {required String conversation_id,
      required String id_sender,
      required String id_receiver,
      required String tanggal_kirim,
      required String jam_kirim,
      required String message,
      String? image,
      int? messageRead}) async {
    String id_message = RandomString().makeId(128);
    final db = await database;
    if (conversation_id != '$id_sender-$id_sender') {
      String query =
          "INSERT INTO messages(id_message, conversation_id, id_sender, id_receiver, tanggal_kirim, jam_kirim, message, image, messageRead) VALUES (?,?,?,?,?,?,?,?,?)";
      final result = await db.rawInsert(query, [
        id_message,
        conversation_id,
        id_sender,
        id_receiver,
        tanggal_kirim,
        jam_kirim,
        message,
        image,
        messageRead
      ]);
      List<MessageModel> res = [];
      if (result != 0) {
        const queryM = 'SELECT * FROM messages WHERE id_message = ?;';
        List<Map<String, dynamic>> result1 =
            await db.rawQuery(queryM, [id_message]);
        res = result1.map((e) {
          return MessageModel(
            idmessage: e['id_message'],
            idsender: e['id_sender'],
            idreceiver: e['id_receiver'],
            tanggalkirim: e['tanggal_kirim'],
            jamkirim: e['jam_kirim'],
            message: e['message'],
            image: e['image'],
            messageRead: e['messageRead'],
          );
        }).toList();
        return res.first;
      } else {
        return MessageModel();
      }
    }
    return MessageModel();
  }

  Future<int> saveNewMessage(
      {required String id_message,
      required String conversation_id,
      required String id_sender,
      required String id_receiver,
      required String tanggal_kirim,
      required String jam_kirim,
      required String message,
      String? image,
      int? messageRead}) async {
    final db = await database;
    String query =
        "INSERT INTO messages(id_message, conversation_id,id_sender, id_receiver, tanggal_kirim, jam_kirim, message, image, messageRead) VALUES (?,?,?,?,?,?,?,?,?)";
    final result = await db.rawInsert(query, [
      id_message,
      conversation_id,
      id_sender,
      id_receiver,
      tanggal_kirim,
      jam_kirim,
      message,
      image,
      messageRead
    ]);
    return result;
  }

  Future<void> updateStatusChat(
      {int? messageRead, required String id_message}) async {
    final db = await database;
    const query = 'UPDATE messages SET messageRead = ? WHERE id_message = ?;';
    int result = await db.rawUpdate(query, [messageRead, id_message]);
    log('$result item Updated');
  }

  Future<List<MessageModel>> getListLatestMessage(
      {required String userID}) async {
    final db = await database;
    const query = '''
  SELECT m.*
  FROM messages m
  JOIN (
    SELECT conversation_id, MAX(datetime(tanggal_kirim)) AS max_date
    FROM messages
    WHERE conversation_id LIKE ?
    GROUP BY conversation_id
  ) latest
  ON m.conversation_id = latest.conversation_id AND datetime(m.tanggal_kirim) = latest.max_date
  ORDER BY datetime(m.tanggal_kirim) DESC;
''';

    List<Map<String, dynamic>> res = await db.rawQuery(query, ['%$userID%']);
    List<String> listUID =
        res.map((e) => e['conversation_id'].toString()).toList();
    List<String> parts = listUID
        .map((item) => item == userID
            ? item.split('-').elementAt(1)
            : item.split('-').elementAt(0))
        .toList();
    List<MessageModel> result = [];
    if (listUID.isNotEmpty) {
      List<User> users = await getDataUser(userID: parts);
      result = res.map((e) {
        User user = e['id_receiver'] != userID
            ? users.firstWhere(
                (element) => element.userID == e['id_receiver'],
                orElse: () => User(),
              )
            : users.firstWhere(
                (element) => element.userID == e['id_sender'],
                orElse: () => User(),
              );
        return MessageModel(
          idmessage: e['id_message'],
          conversationId: e['conversation_id'],
          idsender: e['id_sender'],
          idreceiver: e['id_receiver'],
          tanggalkirim: e['tanggal_kirim'],
          jamkirim: e['jam_kirim'],
          message: e['message'],
          image: e['image'],
          messageRead: e['messageRead'],
          namaReceiver: user.nama,
          ketReceiver: user.keterangan,
          fcm_token: user.fcm_token,
          fotoReceiver: user.foto,
        );
      }).toList();
      result.removeWhere(
          (element) => element.conversationId == '$userID-$userID');
    }
    return result;
  }

  Future<List<MessageModel>> countUnRead() async {
    final db = await database;
    const query = 'SELECT * FROM messages WHERE messageRead != 1';
    List<Map<String, dynamic>> count = await db.rawQuery(query);
    List<MessageModel> result = count.map((e) {
      return MessageModel(
        idmessage: e['id_message'],
        conversationId: e['conversation_id'],
        idsender: e['id_sender'],
        idreceiver: e['id_receiver'],
        tanggalkirim: e['tanggal_kirim'],
        jamkirim: e['jam_kirim'],
        message: e['message'],
        image: e['image'],
        messageRead: e['messageRead'],
      );
    }).toList();
    return result;
  }

  Future<List<MessageModel>> getIndividualMessage(
      {required String senderID, required String receiverID}) async {
    final db = await database;
    const query =
        'SELECT * FROM messages WHERE (id_sender = ? AND id_receiver = ?) OR (id_sender = ? AND id_receiver = ?) ORDER BY datetime(tanggal_kirim) DESC;';
    List<Map<String, dynamic>> res =
        await db.rawQuery(query, [senderID, receiverID, receiverID, senderID]);
    List<MessageModel> result = res.map((e) {
      return MessageModel(
        idmessage: e['id_message'],
        idsender: e['id_sender'],
        idreceiver: e['id_receiver'],
        tanggalkirim: e['tanggal_kirim'],
        jamkirim: e['jam_kirim'],
        message: e['message'],
        image: e['image'],
        messageRead: e['messageRead'],
      );
    }).toList();
    return result;
  }

  Future<void> deleteConversation({required String conversation_id}) async {
    final db = await database;
    const query = 'DELETE FROM messages WHERE conversation_id = ?;';
    int result = await db.rawDelete(query, [conversation_id]);
    if (result != 0) {
      await deleteConversationServer(conversation_id: conversation_id);
    }
    log('$result item deleted');
  }

  Future<void> deleteConversationServer(
      {required String conversation_id}) async {
    try {
      final response = await dio.post(
        '${link}delete_conversation',
        data: {'conversation_id': conversation_id},
      );
      if (response.data != null) {
        log('Hapus Single Chat : ${response.data['message']}');
      }
    } on DioException catch (error) {
      if (error.response != null) {
        log(error.response!.data['error']);
      } else {
        log(error.requestOptions.toString());
        log(error.message.toString());
      }
    }
  }

  Future<void> deleteSingleChat({required String id_message}) async {
    final db = await database;
    const query = 'DELETE FROM messages WHERE id_message = ?;';
    int result = await db.rawDelete(query, [id_message]);
    if (result != 0) {
      await deleteSingleChatServer(id_message: id_message);
    }
    log('$result item deleted');
  }

  Future<void> deleteSingleChatServer({required String id_message}) async {
    try {
      final response = await dio.post(
        '${link}delete_single_chat',
        data: {'id_message': id_message},
      );
      if (response.data != null) {
        log('Hapus Single Chat : ${response.data['message']}');
      }
    } on DioException catch (error) {
      if (error.response != null) {
        log(error.response!.data['error']);
      } else {
        log(error.requestOptions.toString());
        log(error.message.toString());
      }
    }
  }

  Future<List<User>> getDataUser({required List<String> userID}) async {
    List<User> data = [];
    try {
      final response = await dio.get(
        '${link}get_data_user_message',
        data: {'userID': userID},
      );
      if (response.data != null) {
        data = response.data != null
            ? (response.data as List)
                .map((userJson) => User.fromJson(userJson))
                .toList()
            : [];
      }
      return data;
    } on DioException catch (error) {
      if (error.response != null) {
        log(error.response!.data['error']);
      } else {
        log(error.requestOptions.toString());
        log(error.message.toString());
      }
      return data;
    }
  }
}
