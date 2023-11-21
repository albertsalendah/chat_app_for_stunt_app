// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mime/mime.dart';
import 'dart:math' as math;
import '../../custom_widget/blue_header_01.dart';
import '../../custom_widget/popup_error.dart';
import '../../custom_widget/popup_success.dart';
import '../../models/api_massage.dart';
import '../navigation_bar.dart';
import '../utils/firebase_api.dart';
import 'login.dart';
import 'login_register_api.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool passwordVisible = false;
  Login_Register_Api api = Login_Register_Api();
  TextEditingController nama = TextEditingController();
  TextEditingController no_wa = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController keterangan = TextEditingController();
  List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());
  List<PlatformFile> picked_foto = [];
  Uint8List? imagebytes;
  String foto = '';

  void clear_field() {
    nama.text = '';
    no_wa.text = '';
    email.text = '';
    pass.text = '';
  }

  @override
  void dispose() {
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
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
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Column(
              children: [
                const Blue_Header_01(
                    text1: 'Daftar Akun',
                    text2:
                        'Untuk mendaftarkan akun anda, silahkan mengisi data dibawah ini'),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom / 2),
                    reverse: true,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        GestureDetector(
                          onTap: () {
                            pickPicture();
                          },
                          child: imagebytes != null
                              ? CircleAvatar(
                                  radius: 45.0,
                                  backgroundImage: MemoryImage(imagebytes!),
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      width: 90,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withAlpha(200),
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(65),
                                          bottomRight: Radius.circular(65),
                                        ),
                                      ),
                                      child: const Center(
                                          child: Text(
                                        'Foto',
                                        style: TextStyle(color: Colors.black),
                                      )),
                                    ),
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 45.0,
                                  backgroundImage: const AssetImage(
                                      'assets/images/group-115.png'),
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      width: 90,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withAlpha(200),
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(65),
                                          bottomRight: Radius.circular(65),
                                        ),
                                      ),
                                      child: const Center(
                                          child: Text(
                                        'Foto',
                                        style: TextStyle(color: Colors.black),
                                      )),
                                    ),
                                  ),
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Nama"),
                              ),
                              TextFormField(
                                  controller: nama,
                                  focusNode: focusNodes[0],
                                  onEditingComplete: () =>
                                      focusNodes[1].requestFocus(),
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                      hintText: 'masukkan nama lengkap',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)))),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Specialist"),
                              ),
                              TextFormField(
                                  controller: keterangan,
                                  focusNode: focusNodes[1],
                                  onEditingComplete: () =>
                                      focusNodes[2].requestFocus(),
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                      hintText: 'Contoh : Pakar Gizi',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)))),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('No. WhatsApp'),
                              ),
                              TextFormField(
                                  controller: no_wa,
                                  focusNode: focusNodes[2],
                                  onEditingComplete: () =>
                                      focusNodes[3].requestFocus(),
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  decoration: InputDecoration(
                                      hintText: 'No. WhatsApp',
                                      prefixIcon: const Padding(
                                        padding:
                                            EdgeInsets.only(left: 8, right: 5),
                                        child: Text(
                                          '+62 |',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      prefixIconConstraints:
                                          const BoxConstraints(
                                              minWidth: 0, minHeight: 0),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)))),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Email'),
                              ),
                              TextFormField(
                                  controller: email,
                                  focusNode: focusNodes[3],
                                  onEditingComplete: () =>
                                      focusNodes[4].requestFocus(),
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                      hintText: 'Email',
                                      prefixIcon: const Icon(
                                        Icons.email_outlined,
                                        color: Colors.grey,
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)))),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Kata Sandi'),
                              ),
                              TextFormField(
                                  controller: pass,
                                  focusNode: focusNodes[4],
                                  onEditingComplete: () =>
                                      focusNodes[5].requestFocus(),
                                  obscureText: !passwordVisible,
                                  decoration: InputDecoration(
                                      hintText: 'masukkan kata sandi',
                                      prefixIcon: const Icon(
                                        Icons.lock_outline,
                                        color: Colors.grey,
                                      ),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            passwordVisible = !passwordVisible;
                                          });
                                        },
                                        icon: Icon(
                                          !passwordVisible
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 10, 18, 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                          height: 60,
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.only(bottom: 10),
                          child: ElevatedButton(
                            focusNode: focusNodes[5],
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                backgroundColor: const Color(0xff3f7af6)),
                            onPressed: () async {
                              if (no_wa.text.isNotEmpty &&
                                  pass.text.isNotEmpty &&
                                  email.text.isNotEmpty &&
                                  nama.text.isNotEmpty) {
                                String? fcm_token =
                                    await FirebaseApi().getTokenFCM();
                                if (fcm_token != null) {
                                  API_Massage result = await api.registerUser(
                                      nama: nama.text,
                                      noHp: no_wa.text,
                                      email: email.text,
                                      password: pass.text,
                                      fcm_token: fcm_token,
                                      foto: foto,
                                      keterangan: keterangan.text);
                                  if (result.status) {
                                    showDialog(
                                        context: context,
                                        builder: (context) => PopUpSuccess(
                                            message: result.message
                                                .toString())).then(
                                      (value) async {
                                        API_Massage result = await api.login(
                                            noHp: no_wa.text,
                                            password: pass.text);
                                        if (result.status) {
                                          Navigator.pop(context);
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const Navigationbar(index: 0),
                                            ),
                                          );
                                          clear_field();
                                        }
                                      },
                                    );
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (context) => PopUpError(
                                          message: result.message.toString()),
                                    );
                                    clear_field();
                                  }
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) => const PopUpError(
                                        message: 'Koneksi Ke Server Gagal'),
                                  );
                                  clear_field();
                                }
                              } else {
                                if (nama.text.isEmpty) {
                                  focusNodes[0].requestFocus();
                                } else if (no_wa.text.isEmpty) {
                                  focusNodes[2].requestFocus();
                                } else if (email.text.isEmpty) {
                                  focusNodes[3].requestFocus();
                                } else if (pass.text.isEmpty) {
                                  focusNodes[4].requestFocus();
                                }
                                showDialog(
                                  context: context,
                                  builder: (context) => const PopUpError(
                                      message: 'Isi Semua Kolom'),
                                );
                              }
                            },
                            child: Center(
                              child: Text(
                                'Daftar Sekarang',
                                style: TextStyle(fontSize: 16 * ffem),
                              ),
                            ),
                          )),
                      RichText(
                        // sudahpunyaakunmasukdisiniZgM (316:2492)
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 14 * ffem,
                            fontWeight: FontWeight.w400,
                            height: 1.2125 * ffem / fem,
                            color: const Color(0xff707070),
                          ),
                          children: [
                            const TextSpan(
                              text: 'Sudah punya akun? Masuk ',
                            ),
                            TextSpan(
                              text: 'disini',
                              style: TextStyle(
                                fontSize: 14 * ffem,
                                fontWeight: FontWeight.w700,
                                height: 1.2125 * ffem / fem,
                                color: const Color(0xff3f7af6),
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Login()),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
