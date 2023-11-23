import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Bloc/KonsultasiBloc/konsultasiBloc.dart';
import '../Bloc/KonsultasiBloc/konsultasiState.dart';
import '../Login_Register/logout.dart';
import '../custom_widget/chat_card.dart';
import '../models/message_model.dart';
import '../models/user.dart';
import '../utils/SessionManager.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});
  static const route = '/chat-list';

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  User user = User();
  String token = '';
  List<MessageModel> listMessage = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      user = await SessionManager.getUser();
      token = await SessionManager.getToken() ?? '';
      await fetchData();
      if (listMessage.isEmpty) {
        await fetchData();
      }
    });
  }

  Future<void> fetchData() async {
    await context
        .read<KonsultasiBloc>()
        .getLatestMesage(userID: user.userID.toString(), token: token);
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.grey),
            title: Text(
              'Daftar Chat',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16 * fem,
                  color: Colors.black),
            ),
            actions: [settingbutton(fem, context)],
          ),
          body: BlocBuilder<KonsultasiBloc, KonsultasiState>(
            builder: (context, state) {
              if (state is DataInitialState) {
                return Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: 40 * fem,
                            width: 40 * fem,
                            child: const CircularProgressIndicator()),
                        const SizedBox(
                          height: 8,
                        ),
                        const Text('Memuat Data')
                      ]),
                );
              } else if (state is DataErrorState) {
                return Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error,
                          color: Colors.red,
                          size: 32 * fem,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(state.errorMessage)
                      ]),
                );
              } else if (state is ListLatestMesasage) {
                listMessage = state.listLatestMessage
                    .where((element) =>
                        element.conversationId !=
                        '${user.userID}-${user.userID}')
                    .toList();
                listMessage.sort((a, b) {
                  DateTime dateTimeA = DateTime.parse('${a.tanggalkirim}');
                  DateTime dateTimeB = DateTime.parse('${b.tanggalkirim}');
                  return dateTimeB.compareTo(dateTimeA);
                });
              }
              return SizedBox(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await fetchData();
                  },
                  child: ListView.builder(
                    itemCount: listMessage.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ChatCard(messageModel: listMessage[index]),
                          const SizedBox(
                            height: 8,
                          )
                        ],
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Container settingbutton(double fem, BuildContext context) {
    return Container(
      height: 40 * fem,
      width: 40 * fem,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8 * fem),
        border: Border.all(color: const Color(0xffe2e2e2)),
        color: const Color(0xffffffff),
      ),
      margin: EdgeInsets.only(
        left: 4 * fem,
        right: 4 * fem,
        bottom: 4 * fem,
        top: 8 * fem,
      ),
      child: PopupMenuButton(
        icon: const Icon(
          Icons.settings,
          color: Colors.grey,
        ),
        itemBuilder: (context) {
          return <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'logout',
              child: Row(
                children: [
                  Icon(
                    Icons.logout,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text('Logout'),
                ],
              ),
            ),
          ];
        },
        onSelected: (value) {
          if (value == 'logout') {
            showDialog(
              context: context,
              builder: (context) {
                return const PopUpLogout();
              },
            );
          }
        },
      ),
    );
  }

  Padding backbutton(double fem, BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0 * fem),
      child: Container(
        height: 20 * fem,
        width: 20 * fem,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffe2e2e2)),
          color: const Color(0xffffffff),
          borderRadius: BorderRadius.circular(8 * fem),
        ),
        child: IconButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const Navigationbar()),
              // );
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.grey,
              size: 16 * fem,
            )),
      ),
    );
  }

  Row con(double fem, double ffem) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Container(
            // frame41zVP (355:15129)
            margin: EdgeInsets.fromLTRB(0 * fem, 0.5 * fem, 108 * fem, 0 * fem),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  // listpakarkonsultangizivP3 (355:15033)
                  margin:
                      EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 2 * fem),
                  child: Text(
                    'List pakar konsultan Gizi',
                    style: TextStyle(
                      fontSize: 14 * ffem,
                      fontWeight: FontWeight.w600,
                      height: 1.2125 * ffem / fem,
                      color: Color(0xff161f35),
                    ),
                  ),
                ),
                Text(
                  // pilihpakarlakukankonsultasi1QV (355:15128)
                  'Pilih pakar & lakukan konsultasi',
                  style: TextStyle(
                    fontSize: 12 * ffem,
                    fontWeight: FontWeight.w400,
                    height: 1.6666666667 * ffem / fem,
                    color: Color(0xff707070),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Container(
              width: 35 * fem,
              height: 35 * fem,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8)),
              child: const Icon(
                Icons.list,
                color: Colors.grey,
              )),
        ),
      ],
    );
  }
}
