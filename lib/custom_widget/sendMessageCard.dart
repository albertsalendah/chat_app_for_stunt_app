// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Bloc/KonsultasiBloc/konsultasiBloc.dart';
import '../models/message_model.dart';
import '../utils/sqlite_helper.dart';

class SendMessageCard extends StatelessWidget {
  final MessageModel message;
  const SendMessageCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    SqliteHelper sqlite = SqliteHelper();
    final maxWidth = MediaQuery.of(context).size.width - 45;
    final isImagePresent =
        message.image != null && message.image.toString().isNotEmpty;
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: GestureDetector(
          onLongPress: () async {
            final RenderBox overlay =
                Overlay.of(context).context.findRenderObject() as RenderBox;
            final RenderBox card = context.findRenderObject() as RenderBox;
            final Offset position =
                card.localToGlobal(Offset.zero, ancestor: overlay);
            showMenu(
              context: context,
              position: RelativeRect.fromLTRB(1, position.dy, 0, 0),
              items: [
                PopupMenuItem(
                  value: 'hapus',
                  onTap: () async {
                    await sqlite.deleteSingleChat(
                        id_message: message.idmessage.toString());
                    await context.read<KonsultasiBloc>().getIndividualMessage(
                        senderID: message.idsender.toString(),
                        receiverID: message.idreceiver.toString());
                  },
                  child: const Text('Hapus'),
                ),
              ],
            );
          },
          child: Card(
            color: const Color.fromARGB(255, 81, 136, 253),
            elevation: 1,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            )),
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Column(
              children: [
                if (isImagePresent) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(File(message.image.toString()))),
                  )
                ],
                Stack(children: [
                  if (isImagePresent) ...[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 60, 20),
                        child: Text(
                          message.message.toString(),
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ] else ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 60, 25),
                      child: Text(
                        message.message.toString(),
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                  Positioned(
                    bottom: 4,
                    right: 10,
                    child: Row(
                      children: [
                        Text(
                          message.jamkirim.toString(),
                          style: const TextStyle(
                              fontSize: 13, color: Colors.white),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Visibility(
                          visible: message.messageRead != null,
                          replacement:
                              const Icon(Icons.done, color: Colors.grey),
                          child: Icon(Icons.done_all,
                              size: 20,
                              color: message.messageRead == 0
                                  ? Colors.grey
                                  : Colors.white),
                        )
                      ],
                    ),
                  )
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
