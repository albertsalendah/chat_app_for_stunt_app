// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:chat_app_for_stunt_app/models/contact_model.dart';
import 'package:chat_app_for_stunt_app/models/user.dart';
import 'package:chat_app_for_stunt_app/utils/SessionManager.dart';
import 'package:chat_app_for_stunt_app/utils/formatTgl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Akun/edit_akun_api.dart';
import '../Bloc/KonsultasiBloc/konsultasiBloc.dart';
import '../Chats/chat_page.dart';
import '../models/message_model.dart';
import '../utils/sqlite_helper.dart';

class ChatCard extends StatefulWidget {
  final MessageModel messageModel;
  final int totalUnread;
  final Contact contact;
  const ChatCard(
      {super.key,
      required this.messageModel,
      required this.totalUnread,
      required this.contact});

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  EditAkunApi editAkunApi = EditAkunApi();
  SqliteHelper sqlite = SqliteHelper();
  User user = User();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      user = await SessionManager.getUser();
      context.read<KonsultasiBloc>().getDaftarKontak();
      if (widget.contact.contact_id == null) {
        context.read<KonsultasiBloc>().getDaftarKontak();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
                //senderID: widget.messageModel.idreceiver,
                receverID: widget.contact.contact_id,
                receiverNama: widget.contact.nama,
                receiverFoto: widget.contact.foto,
                receiverFCM: widget.contact.fcm_token),
          ),
        );
      },
      onLongPress: () {
        final RenderBox overlay =
            Overlay.of(context).context.findRenderObject() as RenderBox;
        final RenderBox card = context.findRenderObject() as RenderBox;
        final Offset position =
            card.localToGlobal(Offset.zero, ancestor: overlay);
        showMenu(
          context: context,
          position: RelativeRect.fromLTRB(position.dx, position.dy, 0, 0),
          items: [
            PopupMenuItem(
              value: 'hapus',
              onTap: () async {
                await sqlite
                    .deleteConversation(
                        conversation_id:
                            widget.messageModel.conversationId.toString())
                    .then((value) async {
                  await context
                      .read<KonsultasiBloc>()
                      .getLatestMesage(userID: user.userID.toString());
                });
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.centerLeft,
        width: double.infinity,
        height: 76 * fem,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xfff0f0f0)),
          color: const Color(0xffffffff),
          borderRadius: BorderRadius.circular(12 * fem),
          boxShadow: [
            BoxShadow(
              color: const Color(0x0f1b253e),
              offset: Offset(0 * fem, 2 * fem),
              blurRadius: 3.5 * fem,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 45 * fem,
                height: double.infinity,
                child: CircleAvatar(
                  radius: 39.0 * fem,
                  backgroundImage: widget.contact.foto != null &&
                          widget.contact.foto!.isNotEmpty
                      ? FileImage(File(widget.contact.foto.toString()))
                          as ImageProvider
                      : const AssetImage('assets/images/group-1-jAH.png'),
                ),
              ),
            ),
            Container(
              height: 74,
              width: 310,
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.contact.nama ?? '',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 18 * ffem,
                            fontWeight: FontWeight.w600,
                            height: 1.2125 * ffem / fem,
                            color: const Color(0xff161f35),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          FormatTgl().formatSpecialDate(
                              widget.messageModel.tanggalkirim),
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.messageModel.message ?? '',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 16 * ffem,
                            fontWeight: FontWeight.w400,
                            height: 1.6666666667 * ffem / fem,
                            color: const Color(0xff707070),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Visibility(
                            visible: widget.totalUnread > 0,
                            child: Container(
                                width: 22 * fem,
                                height: 22 * fem,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    border: Border.all(color: Colors.white),
                                    borderRadius:
                                        BorderRadius.circular(22 * fem)),
                                child: Text(
                                  widget.totalUnread.toString(),
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.white),
                                )),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
