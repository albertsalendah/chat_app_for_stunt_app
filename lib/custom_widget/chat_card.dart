import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import '../Akun/edit_akun_api.dart';
import '../Chats/chat_page.dart';
import '../models/message_model.dart';
import '../models/user.dart';

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
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
              receverID: widget.messageModel.idsender,
              receiverNama: widget.messageModel.namaReceiver,
              receiverKet: widget.messageModel.ketReceiver,
              receiverFoto: widget.messageModel.fotoReceiver,
              receiverFCM: widget.messageModel.fcm_token,
            ),
          ),
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
