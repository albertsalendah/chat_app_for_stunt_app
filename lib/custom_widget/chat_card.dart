// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Akun/edit_akun_api.dart';
import '../Bloc/KonsultasiBloc/konsultasiBloc.dart';
import '../Chats/chat_page.dart';
import '../models/message_model.dart';
import '../utils/SessionManager.dart';
import '../utils/sqlite_helper.dart';

class ChatCard extends StatefulWidget {
  final MessageModel messageModel;
  const ChatCard({
    super.key,
    required this.messageModel,
  });

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  EditAkunApi editAkunApi = EditAkunApi();
  SqliteHelper sqlite = SqliteHelper();
  String token = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      token = await SessionManager.getToken() ?? '';
      setState(() {});
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
              senderID: widget.messageModel.idreceiver,
              receverID: widget.messageModel.idsender,
              receiverNama: widget.messageModel.namaReceiver,
              receiverKet: widget.messageModel.ketReceiver,
              receiverFoto: widget.messageModel.fotoReceiver,
              receiverFCM: widget.messageModel.fcm_token,
            ),
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
                await sqlite.deleteConversation(
                    conversation_id:
                        widget.messageModel.conversationId.toString());
                await context.read<KonsultasiBloc>().getLatestMesage(
                    userID: widget.messageModel.idsender.toString(),
                    token: token);
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(16 * fem, 16 * fem, 0 * fem, 0 * fem),
        width: double.infinity,
        height: 72 * fem,
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
        child: SizedBox(
          width: 348 * fem,
          height: 94 * fem,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin:
                    EdgeInsets.fromLTRB(0 * fem, 0.5 * fem, 73 * fem, 0 * fem),
                height: 41 * fem,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 11 * fem, 0 * fem),
                      width: 45 * fem,
                      height: double.infinity,
                      child: widget.messageModel.fotoReceiver != null &&
                              widget.messageModel.fotoReceiver!.isNotEmpty
                          ? CircleAvatar(
                              radius: 39.0 * fem,
                              backgroundImage: MemoryImage(
                                base64Decode(
                                  widget.messageModel.fotoReceiver.toString(),
                                ),
                              ),
                            )
                          : CircleAvatar(
                              radius: 45.0 * fem,
                              backgroundImage: const AssetImage(
                                  'assets/images/group-1-jAH.png'),
                            ),
                    ),
                    SizedBox(
                      height: double.infinity,
                      width: 185,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(
                                0 * fem, 0 * fem, 0 * fem, 2 * fem),
                            child: Text(
                              widget.messageModel.namaReceiver ?? '',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 14 * ffem,
                                fontWeight: FontWeight.w600,
                                height: 1.2125 * ffem / fem,
                                color: const Color(0xff161f35),
                              ),
                            ),
                          ),
                          Text(
                            widget.messageModel.message ?? '',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 12 * ffem,
                              fontWeight: FontWeight.w400,
                              height: 1.6666666667 * ffem / fem,
                              color: const Color(0xff707070),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                      Icons.chat_outlined,
                      color: Colors.grey,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
