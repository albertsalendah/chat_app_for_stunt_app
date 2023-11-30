import 'dart:convert';
import 'dart:io';

import 'package:chat_app_for_stunt_app/Bloc/KonsultasiBloc/konsultasiBloc.dart';
import 'package:chat_app_for_stunt_app/Bloc/SocketBloc/socket_bloc.dart';
import 'package:chat_app_for_stunt_app/Bloc/SocketBloc/socket_state.dart';
import 'package:chat_app_for_stunt_app/Chats/chat_page.dart';
import 'package:chat_app_for_stunt_app/models/contact_model.dart';
import 'package:chat_app_for_stunt_app/utils/sqlite_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactCard extends StatefulWidget {
  final Contact contact;
  const ContactCard({super.key, required this.contact});

  @override
  State<ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<ContactCard> {
  String foto = '';
  bool isOnline = false;
  SqliteHelper sqlite = SqliteHelper();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {});
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
              receverID: widget.contact.contact_id,
              receiverNama: widget.contact.nama,
              receiverFCM: widget.contact.fcm_token,
              receiverFoto: widget.contact.foto,
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
                await sqlite
                    .deleteContact(
                        contact_id: widget.contact.contact_id.toString())
                    .then((_) async {
                  await context.read<KonsultasiBloc>().getDaftarKontak();
                });
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
                    BlocBuilder<SocketProviderBloc, SocketState>(
                      builder: (context, state) {
                        if (state is UserConnected) {
                          if (widget.contact.contact_id ==
                              state.connectedUser) {
                            isOnline = true;
                          }
                        } else if (state is UserDisonnected) {
                          if (widget.contact.contact_id ==
                              state.disconnectedUser) {
                            isOnline = false;
                          }
                        }
                        return Container(
                          margin: EdgeInsets.only(right: 11 * fem),
                          width: 39 * fem,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xfff0f0f0)),
                            borderRadius: BorderRadius.circular(19.5 * fem),
                          ),
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 39.0 * fem,
                                backgroundImage: widget.contact.foto != null &&
                                        widget.contact.foto!.isNotEmpty
                                    ? FileImage(File(
                                            widget.contact.foto.toString()))
                                        as ImageProvider
                                    : const AssetImage(
                                        'assets/images/group-1-jAH.png'),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: SizedBox(
                                  width: 11 * fem,
                                  height: 11 * fem,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(4.5 * fem),
                                      color: isOnline
                                          ? const Color(0xff12b66a)
                                          : Colors.red,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 0 * fem, 2 * fem),
                      child: Text(
                        widget.contact.nama ?? '',
                        style: TextStyle(
                          fontSize: 14 * ffem,
                          fontWeight: FontWeight.w600,
                          height: 1.2125 * ffem / fem,
                          color: const Color(0xff161f35),
                        ),
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
