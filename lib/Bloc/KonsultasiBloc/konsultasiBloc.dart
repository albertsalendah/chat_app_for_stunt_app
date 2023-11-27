import 'package:chat_app_for_stunt_app/utils/sqlite_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Chats/chat_api.dart';
import '../../models/message_model.dart';
import '../../utils/config.dart';
import 'konsultasiState.dart';

class KonsultasiBloc extends Cubit<KonsultasiState> {
  KonsultasiBloc() : super(DataInitialState());
  static const String link = Configs.LINK;
  SqliteHelper sqlite = SqliteHelper();
  ChatApi konsultasiAPI = ChatApi();

  getLatestMesage({required String userID}) async {
    List<MessageModel> list =
        await konsultasiAPI.getListLatestMessage(userID: userID);
    List<MessageModel> list2 = await sqlite.countUnRead();
    emit(ListLatestMesasage(list, list2));
  }

  getIndividualMessage(
      {required String senderID, required String receiverID}) async {
    List<MessageModel> list = await konsultasiAPI.getIndividualMessage(
        senderID: senderID, receiverID: receiverID);
    emit(ListIndividualMesasage(list));
  }
}
