// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:chat_app_for_stunt_app/Chats/daftar_kontak.dart';
import 'package:chat_app_for_stunt_app/models/contact_model.dart';
import 'package:chat_app_for_stunt_app/utils/sqlite_helper.dart';
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

class _ChatListState extends State<ChatList> with WidgetsBindingObserver {
  User user = User();
  String token = '';
  List<MessageModel> listMessage = [];
  List<MessageModel> unreadlist = [];
  List<Contact> daftarKontak = [];
  SqliteHelper sqlite = SqliteHelper();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      user = await SessionManager.getUser();
      token = await SessionManager.getToken() ?? '';
      await fetchData();
      if (listMessage.isEmpty) {
        await fetchData();
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        log('CHAT LIST PAGE INACTIVE');
        break;
      case AppLifecycleState.resumed:
        fetchData();
        log('CHAT LIST PAGE RESUMED');
        break;
      case AppLifecycleState.paused:
        log('CHAT LIST PAGE PAUSED');
        break;
      case AppLifecycleState.detached:
        log('CHAT LIST PAGE  DETACHED');
        break;
      case AppLifecycleState.hidden:
        log('CHAT LIST PAGE  HIDDEN');
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  Future<void> fetchData() async {
    context
        .read<KonsultasiBloc>()
        .getLatestMesage(userID: user.userID.toString());
    await context.read<KonsultasiBloc>().getDaftarKontak();
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
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
                unreadlist = state.listAllUnread;
                log('Message List : ${listMessage.length}');
              } else if (state is DaftarKontakLoaded) {
                daftarKontak = state.daftarkontak;
              }
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: con(fem, ffem),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await fetchData();
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: listMessage.length,
                        itemBuilder: (context, index) {
                          var count = unreadlist.where((element) =>
                              element.conversationId ==
                              listMessage[index].conversationId);
                          String id = listMessage[index].idreceiver.toString();
                          if (listMessage[index].idreceiver.toString() ==
                              user.userID.toString()) {
                            id = listMessage[index].idsender.toString();
                          }
                          return Column(
                            children: [
                              ChatCard(
                                  messageModel: listMessage[index],
                                  totalUnread: count.length,
                                  contact: daftarKontak.firstWhere(
                                      (element) => element.contact_id == id,
                                      orElse: () => Contact())),
                              const SizedBox(
                                height: 8,
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
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
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Container(
            // frame41zVP (355:15129)
            margin: EdgeInsets.fromLTRB(0 * fem, 0.5 * fem, 108 * fem, 0 * fem),
            child: Container(
              margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 2 * fem),
              child: Text(
                'Daftar Kontak',
                style: TextStyle(
                  fontSize: 16 * ffem,
                  fontWeight: FontWeight.w600,
                  height: 1.2125 * ffem / fem,
                  color: const Color(0xff161f35),
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DaftarKontak()),
            );
          },
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
