// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Bloc/KonsultasiBloc/konsultasiBloc.dart';
import '../models/message_model.dart';
import '../utils/SessionManager.dart';
import '../utils/sqlite_helper.dart';

class ReceiveMessageCard extends StatelessWidget {
  final MessageModel message;
  const ReceiveMessageCard({super.key, required this.message});
  @override
  Widget build(BuildContext context) {
    SqliteHelper sqlite = SqliteHelper();
    if (message.image != null && message.image.toString().isNotEmpty) {
      return Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 45),
          child: GestureDetector(
            onLongPress: () async {
              String token = await SessionManager.getToken() ?? '';
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
                      await sqlite.deleteSingleChat(
                          id_message: message.idmessage.toString());
                      await context.read<KonsultasiBloc>().getIndividualMessage(
                          senderID: message.idsender.toString(),
                          receiverID: message.idreceiver.toString(),
                          token: token);
                    },
                    child: const Text('Hapus'),
                  ),
                ],
              );
            },
            child: Card(
              color: Colors.white,
              elevation: 1,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(10),
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              )),
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Column(
                children: [
                  if (message.image != null &&
                      message.image.toString().isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(File(message.image.toString()))
                          ),
                    )
                  ],
                  Stack(children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 60, 20),
                        child: Text(
                          message.message.toString(),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 4,
                      right: 10,
                      child: Text(
                        message.jamkirim.toString(),
                        style: const TextStyle(fontSize: 13),
                      ),
                    )
                  ]),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 45),
          child: GestureDetector(
            onLongPress: () async {
              String token = await SessionManager.getToken() ?? '';
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
                      await sqlite.deleteSingleChat(
                          id_message: message.idmessage.toString());
                      await context.read<KonsultasiBloc>().getIndividualMessage(
                          senderID: message.idsender.toString(),
                          receiverID: message.idreceiver.toString(),
                          token: token);
                    },
                    child: const Text('Hapus'),
                  ),
                ],
              );
            },
            child: Card(
              color: Colors.white,
              elevation: 1,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(10),
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              )),
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Stack(children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 60, 20),
                  child: Text(
                    message.message.toString(),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                Positioned(
                  bottom: 4,
                  right: 10,
                  child: Text(
                    message.jamkirim.toString(),
                    style: const TextStyle(fontSize: 13),
                  ),
                )
              ]),
            ),
          ),
        ),
      );
    }
  }
}
