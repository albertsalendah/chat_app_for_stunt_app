// ignore_for_file: non_constant_identifier_names

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Akun/edit_akun_api.dart';
import '../../MenuAsupan/menu_makan_api.dart';
import '../../models/rekomendasiMenuMakan.dart';
import '../../models/user.dart';
import '../../utils/config.dart';
import 'AllState.dart';

class AllBloc extends Cubit<AllState> {
  AllBloc() : super(DataInitialState());
  static const String link = Configs.LINK;

  EditAkunApi akunAPI = EditAkunApi();
  MenuMakanAPI menuMakanAPI = MenuMakanAPI();

  getUserData({required String userID, required String token}) async {
    User user = await akunAPI.getDataUser(userID: userID, token: token);
    emit(UserDataLoaded(user));
  }

  getListRekomendasi({required String user_id, required String token}) async {
    List<RekomendasiMenuMakan> list =
        await menuMakanAPI.getListMenuMakan(user_id: user_id, token: token);
    emit(ListRekomendasiMenuLoaded(list));
  }
}
