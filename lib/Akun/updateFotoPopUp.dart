// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:chat_app_for_stunt_app/custom_widget/popUpLoading.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mime/mime.dart';
import '../../models/user.dart';
import '../Bloc/Bloc/AllBloc.dart';
import '../custom_widget/popup_error.dart';
import '../models/api_massage.dart';
import 'edit_akun_api.dart';
import '../../utils/SessionManager.dart';

class UpdateFotoPopUp extends StatefulWidget {
  const UpdateFotoPopUp({super.key});

  @override
  State<UpdateFotoPopUp> createState() => _UpdateFotoPopUpState();
}

class _UpdateFotoPopUpState extends State<UpdateFotoPopUp> {
  EditAkunApi api = EditAkunApi();
  User user = User();
  String token = '';
  List<PlatformFile> picked_foto = [];
  Uint8List? imagebytes;
  String foto = '';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      user = await fetch_user();
      token = await SessionManager.getToken() ?? '';
      if (user.userID == null) {
        await fetch_Data();
      }
      setState(() {});
    });
  }

  Future<User> fetch_user() async {
    return await SessionManager.getUser();
  }

  Future<void> fetch_Data() async {
    await context
        .read<AllBloc>()
        .getUserData(userID: user.userID.toString(), token: token);
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
              imagebytes = picked_foto.first.bytes;
              if (imagebytes != null) {
                foto = base64Encode(imagebytes!);
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
    double baseWidth = 305;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20 * fem))),
      content: Wrap(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                // frame14ctR (345:2487)
                margin:
                    EdgeInsets.fromLTRB(5 * fem, 0 * fem, 5 * fem, 20 * fem),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        pickPicture();
                      },
                      child: CircleAvatar(
                        radius: 65.0,
                        backgroundImage: imagebytes != null
                            ? MemoryImage(imagebytes!) as ImageProvider
                            : const AssetImage('assets/images/group-115.png'),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 8),
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 0 * fem, 7 * fem),
                      child: Text(
                        'Tekan Foto Untuk Memilih Foto Baru',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16 * ffem,
                          height: 1.2125 * ffem / fem,
                          color: const Color(0xff161f35),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              backgroundColor: Colors.green),
                          onPressed: () async {
                            showDialog(
                              context: context,
                              builder: (context) => const PopUpLoading(),
                            );
                            API_Message result = await api.updateFoto(
                                userID: user.userID.toString(),
                                oldpath: user.foto.toString(),
                                foto: imagebytes,
                                token: token);
                            Navigator.pop(context);
                            if (result.status) {
                              imagebytes = null;
                              Navigator.pop(context);
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) => PopUpError(
                                    message: result.message.toString()),
                              );
                            }
                          },
                          child: const Text('Ganti Foto')),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Flexible(
                    flex: 1,
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              backgroundColor: Colors.red),
                          onPressed: () {
                            imagebytes = null;
                            Navigator.pop(context);
                          },
                          child: const Text('Batal')),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
