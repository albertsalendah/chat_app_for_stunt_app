import 'dart:developer';
import 'package:chat_app_for_stunt_app/Bloc/KonsultasiBloc/konsultasiBloc.dart';
import 'package:chat_app_for_stunt_app/Bloc/SocketBloc/socket_state.dart';
import 'package:chat_app_for_stunt_app/main.dart';
import 'package:chat_app_for_stunt_app/utils/config.dart';
import 'package:chat_app_for_stunt_app/utils/sqlite_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketProviderBloc extends Cubit<SocketState> {
  SocketProviderBloc() : super(SocketConnectingState());
  static const String link = Configs.LINK;
  IO.Socket? socket;
  SqliteHelper sqlite = SqliteHelper();

  connectSocket({required String userID}) {
    try {
      socket = IO.io(Configs.LINK, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
      });
      socket?.connect();
      socket?.onConnect((data) {
        log('Socket Connected');
        socket?.emit('signIn', userID);
      });
      socket?.on('userConnected', (data) {
        String userId = data['userId'] ?? '';
        emit(UserConnected(userId));
      });
      socket?.on('userDisconnected', (data) {
        String userId = data['userId'] ?? '';
        emit(UserDisonnected(userId));
      });
      socket?.on('typing', (data) {
        bool isTyping = data['isTyping'] ?? false;
        emit(UserTyping(isTyping));
      });
      socket?.on('messageReceive', (data) async {
        String messageId = data['messageId'] ?? '';
        String senderID = data['senderID'];
        String receiverID = data['receiverID'];
        await sqlite
            .updateStatusChat(messageRead: 0, id_message: messageId)
            .then((value) async {
          if (navigatorKey.currentContext != null) {
            final konsultasiBloc =
                BlocProvider.of<KonsultasiBloc>(navigatorKey.currentContext!);
            await konsultasiBloc.getIndividualMessage(
                senderID: senderID.toString(),
                receiverID: receiverID.toString());
          }
        });
      });
      socket?.on('messageRead', (data) async {
        String messageId = data['messageId'] ?? '';
        String senderID = data['senderID'];
        String receiverID = data['receiverID'];
        await sqlite
            .updateStatusChat(messageRead: 1, id_message: messageId)
            .then((value) async {
          if (navigatorKey.currentContext != null) {
            final konsultasiBloc =
                BlocProvider.of<KonsultasiBloc>(navigatorKey.currentContext!);
            await konsultasiBloc.getIndividualMessage(
                senderID: senderID.toString(),
                receiverID: receiverID.toString());
          }
        });
      });
    } catch (e) {
      log('SOCKET ERROR : $e');
    }
  }

  disconnectSocket() {
    socket?.disconnect();
    log('Socket Disconnected');
  }

  userTyping({required bool isTyping, required String receiverID}) {
    socket?.emit('typing', {'isTyping': isTyping, 'receiverID': receiverID});
  }

  messageReceive(
      {required String messageId,
      required String senderID,
      required String receiverID}) async {
    socket?.emit('messageReceive', {
      'messageId': messageId,
      'senderID': senderID,
      'receiverID': receiverID
    });
  }

  messageRead(
      {required String messageId,
      required String senderID,
      required String receiverID}) {
    socket?.emit('messageRead', {
      'messageId': messageId,
      'senderID': senderID,
      'receiverID': receiverID
    });
  }
}
