import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;
import 'package:chat_app_for_stunt_app/Chats/chat_api.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mime/mime.dart';

import '../../Bloc/KonsultasiBloc/konsultasiBloc.dart';
import '../../Bloc/KonsultasiBloc/konsultasiState.dart';
import '../../custom_widget/popup_error.dart';
import '../../custom_widget/receiveMessageCard.dart';
import '../../models/user.dart';
import '../../utils/SessionManager.dart';
import '../custom_widget/sendMessageCard.dart';
import '../models/api_massage.dart';
import '../models/message_model.dart';

class ChatPage extends StatefulWidget {
  final receverID;
  final receiverNama;
  final receiverKet;
  final receiverFoto;
  final receiverFCM;
  const ChatPage(
      {super.key,
      required this.receverID,
      required this.receiverNama,
      required this.receiverKet,
      required this.receiverFoto,
      required this.receiverFCM});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ChatApi api = ChatApi();
  final TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool isEmojiVisible = false;
  User user = User();
  String token = '';
  FocusNode focusNode = FocusNode();
  List<MessageModel> listMessage = [];
  List<PlatformFile> picked_foto = [];
  String foto = '';

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
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          isEmojiVisible = false;
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  void onEmojiSelected(Emoji emoji) {
    setState(() {
      messageController.text = messageController.text + emoji.emoji;
    });
  }

  Future<void> fetchData() async {
    await context.read<KonsultasiBloc>().getIndividualMessage(
        senderID: user.userID.toString(),
        receiverID: widget.receverID.toString(),
        token: token);
  }

  void pickPicture() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          allowMultiple: false, type: FileType.image, withData: true);

      if (result != null && result.files.single.path != null) {
        picked_foto = result.files;
        String? mimeType = lookupMimeType(picked_foto.first.name);
        double sizeInMB = picked_foto.first.size / math.pow(1024, 2);

        setState(() {
          if (mimeType?.startsWith('image') == true) {
            if (sizeInMB <= 11) {
              if (picked_foto.first.bytes != null) {
                foto = base64Encode(picked_foto.first.bytes!);
              }
            } else {
              showDialog(
                context: context,
                builder: (context) =>
                    const PopUpError(message: 'File Terlalu Besar (10 MB) MAX'),
              );
            }
          }
        });
      }
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return SafeArea(
        child: GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        setState(() {
          isEmojiVisible = false;
        });
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 234, 243, 247),
        appBar: AppBar(
            backgroundColor: Colors.white,
            shadowColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.grey),
            title: Text(
              'Konsultasi Gizi',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16 * fem,
                  color: Colors.black),
            ),
            leading: backbutton(fem, context)),
        body: Column(children: [
          header(fem, ffem),
          BlocBuilder<KonsultasiBloc, KonsultasiState>(
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
              } else if (state is ListIndividualMesasage) {
                listMessage = state.listIndividualMessage;
              }
              return Expanded(
                child: SizedBox(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await fetchData();
                    },
                    child: ListView.builder(
                      shrinkWrap: true,
                      reverse: true,
                      itemCount: listMessage.length,
                      itemBuilder: (context, index) {
                        if (user.userID.toString() ==
                            listMessage[index].idsender) {
                          return SendMessageCard(message: listMessage[index]);
                        } else {
                          return ReceiveMessageCard(
                            message: listMessage[index],
                          );
                        }
                      },
                    ),
                  ),
                ),
              );
            },
          ),
          Container(
            alignment: Alignment.bottomCenter,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Container(
              margin: const EdgeInsets.only(top: 4, bottom: 4),
              padding: const EdgeInsets.only(right: 8, left: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                        focusNode: focusNode,
                        controller: messageController,
                        maxLines: 5,
                        minLines: 1,
                        decoration: InputDecoration(
                          hintText: 'Message',
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30)),
                          prefixIcon: InkWell(
                            onTap: () {
                              focusNode.unfocus();
                              focusNode.canRequestFocus = false;
                              setState(() {
                                isEmojiVisible = !isEmojiVisible;
                              });
                            },
                            child: const Icon(
                              Icons.emoji_emotions_outlined,
                              color: Colors.grey,
                            ),
                          ),
                          suffixIcon: InkWell(
                            onTap: () {
                              pickPicture();
                            },
                            child: const Icon(
                              Icons.attachment,
                              color: Colors.grey,
                            ),
                          ),
                        )),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  GestureDetector(
                    onTap: () async {
                      // listMessage.add(
                      //   MessageModel(
                      //     idmessage: '',
                      //     idsender: user.userID,
                      //     idreceiver: widget.sender.userID,
                      //     tanggalkirim:
                      //         DateFormat('yyyy-MM-dd').format(DateTime.now()),
                      //     jamkirim: DateFormat.Hm().format(DateTime.now()),
                      //     message: messageController.text,
                      //     image: foto,
                      //     messageRead: 0,
                      //   ),
                      // );
                      API_Massage result = await api.sendMessage(
                          id_sender: user.userID.toString(),
                          id_receiver: widget.receverID.toString(),
                          message: messageController.text,
                          image: foto,
                          fcm_token: widget.receiverFCM.toString(),
                          title: user.nama.toString(),
                          token: token);
                      if (result.status) {
                        await fetchData();
                      }
                      FocusManager.instance.primaryFocus?.unfocus();
                      foto = '';
                      messageController.clear();
                    },
                    child: const CircleAvatar(
                      child: Icon(Icons.send),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Offstage(
            offstage: !isEmojiVisible,
            child: AnimatedSize(
              duration: const Duration(milliseconds: 300),
              child: SizedBox(
                height: (focusNode.hasFocus) ? 0 : 300,
                child: emojiSelect(),
              ),
            ),
          )
        ]),
      ),
    ));
  }

  Container header(double fem, double ffem) {
    return Container(
      padding: EdgeInsets.fromLTRB(16 * fem, 16 * fem, 0 * fem, 0 * fem),
      width: double.infinity,
      height: 72 * fem,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xfff0f0f0)),
        color: const Color(0xffffffff),
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
              height: 39 * fem,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        0 * fem, 0 * fem, 11 * fem, 0 * fem),
                    width: 45 * fem,
                    height: double.infinity,
                    child: widget.receiverFoto != null &&
                            widget.receiverFoto!.isNotEmpty
                        ? CircleAvatar(
                            radius: 39.0 * fem,
                            backgroundImage: MemoryImage(
                              base64Decode(
                                widget.receiverFoto.toString(),
                              ),
                            ),
                          )
                        : CircleAvatar(
                            radius: 45.0 * fem,
                            backgroundImage: const AssetImage(
                                'assets/images/group-1-jAH.png'),
                          ),
                  ),
                  Container(
                    margin:
                        EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 2 * fem),
                    child: Text(
                      widget.receiverNama ?? '',
                      style: TextStyle(
                        fontSize: 16 * ffem,
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
                    Icons.error_outline,
                    color: Colors.grey,
                  )),
            )
          ],
        ),
      ),
    );
  }

  EmojiPicker emojiSelect() {
    return EmojiPicker(
      textEditingController: messageController,
      onEmojiSelected: (category, emoji) => onEmojiSelected(emoji),
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
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.grey,
              size: 16 * fem,
            )),
      ),
    );
  }
}
