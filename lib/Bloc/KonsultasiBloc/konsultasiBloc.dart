// ignore_for_file: non_constant_identifier_names
import 'package:chat_app_for_stunt_app/models/contact_model.dart';
import 'package:chat_app_for_stunt_app/utils/sqlite_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Chats/chat_api.dart';
import '../../utils/config.dart';
import 'konsultasiState.dart';

class KonsultasiBloc extends Cubit<KonsultasiState> {
  KonsultasiBloc() : super(DataInitialState());
  static const String link = Configs.LINK;
  SqliteHelper sqlite = SqliteHelper();
  ChatApi konsultasiAPI = ChatApi();

  Future<void> getLatestMesage({required String userID}) async {
    await sqlite.getListLatestMessage(userID: userID).then((list) async {
      await sqlite.countUnRead(userID).then((list2) {
        emit(ListLatestMesasage(list, list2));
      });
    });
  }

  Future<void> getIndividualMessage(
      {required String senderID, required String receiverID}) async {
    await sqlite
        .getIndividualMessage(senderID: senderID, receiverID: receiverID)
        .then((value) {
      emit(ListIndividualMesasage(value));
    });
  }

  Future<void> getDaftarKontak() async {
    await sqlite.getAllcontact().then((value) {
      emit(DaftarKontakLoaded(value));
    });
  }

  getKontak({required String contact_id}) async {
    Contact list = await sqlite.getdetailcontact(contact_id: contact_id);
    emit(KontakLoaded(list));
  }
}
