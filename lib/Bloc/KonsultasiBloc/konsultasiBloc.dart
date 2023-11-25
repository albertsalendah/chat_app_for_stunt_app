import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Chats/chat_api.dart';
import '../../models/message_model.dart';
import '../../utils/config.dart';
import 'konsultasiState.dart';

class KonsultasiBloc extends Cubit<KonsultasiState> {
  KonsultasiBloc() : super(DataInitialState());
  static const String link = Configs.LINK;
  ChatApi konsultasiAPI = ChatApi();

  getLatestMesage({required String userID, required String token}) async {
    List<MessageModel> list =
        await konsultasiAPI.getListLatestMessage(userID: userID, token: token);
    emit(ListLatestMesasage(list));
  }

  getIndividualMessage(
      {required String senderID,
      required String receiverID,
      required String token}) async {
    List<MessageModel> list = await konsultasiAPI.getIndividualMessage(
        senderID: senderID, receiverID: receiverID, token: token);
    emit(ListIndividualMesasage(list));
  }
}
