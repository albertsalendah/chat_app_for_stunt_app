import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/message_model.dart';

class SendMessageCard extends StatelessWidget {
  final MessageModel message;
  const SendMessageCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    if (message.image != null && message.image.toString().isNotEmpty) {
      return Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 45),
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
                if (message.image != null &&
                    message.image.toString().isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.memory(
                          base64Decode(message.image.toString()),
                        )),
                  )
                ],
                Stack(children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 60, 20),
                      child: Text(
                        message.message.toString(),
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
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
                        Icon(Icons.done_all,
                            size: 20,
                            color: message.messageRead == 0
                                ? Colors.grey
                                : Colors.white)
                      ],
                    ),
                  )
                ]),
              ],
            ),
          ),
        ),
      );
    } else {
      return Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 45),
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
            child: Stack(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 60, 20),
                child: Text(
                  message.message.toString(),
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Row(
                  children: [
                    Text(
                      message.jamkirim.toString(),
                      style: const TextStyle(fontSize: 13, color: Colors.white),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Icon(Icons.done_all,
                        size: 20,
                        color: message.messageRead == 0
                            ? Colors.grey
                            : Colors.white)
                  ],
                ),
              )
            ]),
          ),
        ),
      );
    }
  }
}
