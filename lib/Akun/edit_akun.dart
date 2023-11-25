// ignore_for_file: use_build_context_synchronously

import 'package:chat_app_for_stunt_app/LupaPassword/lupa_password_api.dart';
import 'package:chat_app_for_stunt_app/custom_widget/popUpConfirmCode.dart';
import 'package:chat_app_for_stunt_app/custom_widget/popUpLoading.dart';
import 'package:chat_app_for_stunt_app/utils/random_String.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../custom_widget/popup_error.dart';
import '../../models/user.dart';
import '../../utils/SessionManager.dart';
import '../Bloc/Bloc/AllBloc.dart';
import '../custom_widget/popup_success.dart';
import '../models/api_massage.dart';
import 'edit_akun_api.dart';

class EditAkun extends StatefulWidget {
  final String label;
  final String no;
  final String email;
  final String keterangan;
  const EditAkun(
      {super.key,
      required this.label,
      required this.no,
      required this.email,
      required this.keterangan});

  @override
  State<EditAkun> createState() => _EditAkunState();
}

class _EditAkunState extends State<EditAkun> {
  User user = User();
  String token = '';
  EditAkunApi api = EditAkunApi();
  LupaPasswordApi apiPass = LupaPasswordApi();
  TextEditingController noWA = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController keterangan = TextEditingController();
  TextEditingController passLama = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController passConfirm = TextEditingController();
  bool cekPassLama = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      user = await fetch_user();
      token = await SessionManager.getToken() ?? '';
      setData();
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

  void setData() {
    noWA.text = widget.no;
    email.text = widget.email;
    keterangan.text = widget.keterangan;
  }

  Future<void> updateNo() async {
    if (noWA.text.isNotEmpty) {
      API_Message result = await api.updateNo(
          userID: user.userID ?? '', no_hp: noWA.text, token: token);
      if (result.status) {
        await fetch_Data();
        showDialog(
          context: context,
          builder: (context) =>
              PopUpSuccess(message: result.message.toString()),
        ).then((value) {
          Navigator.pop(context);
        });
      } else {
        showDialog(
            context: context,
            builder: (context) => PopUpError(
                  message: result.message.toString(),
                ));
      }
    } else {
      showDialog(
          context: context,
          builder: (context) => const PopUpError(
                message: "Kolom Nomer WA tidak Boleh Kosong",
              ));
    }
  }

  Future<void> updateKeterangan() async {
    if (keterangan.text.isNotEmpty) {
      API_Message result = await api.updateKeterangan(
          userID: user.userID.toString(),
          keterangan: keterangan.text,
          token: token);
      if (result.status) {
        await fetch_Data();
        showDialog(
          context: context,
          builder: (context) =>
              PopUpSuccess(message: result.message.toString()),
        ).then((value) {
          Navigator.pop(context);
        });
      } else {
        showDialog(
            context: context,
            builder: (context) => PopUpError(
                  message: result.message.toString(),
                ));
      }
    } else {
      showDialog(
          context: context,
          builder: (context) => const PopUpError(
                message: "Kolom Specialist tidak Boleh Kosong",
              ));
    }
  }

  Future<void> updateEmail() async {
    if (email.text.isNotEmpty) {
      API_Message result = await api.updateEmail(
          userID: user.userID ?? '', email: email.text, token: token);
      if (result.status) {
        await fetch_Data();
        showDialog(
          context: context,
          builder: (context) =>
              PopUpSuccess(message: result.message.toString()),
        ).then((value) {
          Navigator.pop(context);
        });
      } else {
        showDialog(
          context: context,
          builder: (context) => PopUpError(
            message: result.message.toString(),
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => const PopUpError(
          message: "Kolom Email tidak Boleh Kosong",
        ),
      );
    }
  }

  Future<void> updatePassword() async {
    if (passConfirm.text.isNotEmpty &&
        pass.text.isNotEmpty &&
        passLama.text.isNotEmpty) {
      API_Message result = await api.updatePassword(
          userID: user.userID ?? '', password: passConfirm.text, token: token);
      if (result.status) {
        await fetch_Data();
        showDialog(
          context: context,
          builder: (context) =>
              PopUpSuccess(message: result.message.toString()),
        ).then((value) {
          Navigator.pop(context);
        });
      } else {
        showDialog(
            context: context,
            builder: (context) => PopUpError(
                  message: result.message.toString(),
                ));
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => const PopUpError(
          message: "Isi Semua Kolom",
        ),
      );
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
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.grey),
            title: Text(
              widget.label,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16 * fem,
                  color: Colors.black),
            ),
            leading: backbutton(fem, context),
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.always,
                child: Column(children: [
                  const SizedBox(
                    height: 16,
                  ),
                  if (widget.label == 'Ubah Nomer WA') ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.warning_rounded,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Text(
                              'Pastikan Gunakan Nomer Hanphone Yang Terdaftar Whatsapp',
                              softWrap: true,
                              style: TextStyle(
                                  fontSize: 12 * ffem, color: Colors.grey),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    textfield(fem, 'Nomer Wa', noWA),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                  if (widget.label == 'Ubah Email') ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Row(
                        children: [
                          const Icon(Icons.warning_rounded, color: Colors.grey),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Text(
                              'Pastikan Gunakan Email Yang Aktif',
                              softWrap: true,
                              style: TextStyle(
                                  fontSize: 12 * ffem, color: Colors.grey),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    textfield(fem, 'Email', email),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                  if (widget.label == 'Ubah Specialist') ...[
                    const SizedBox(
                      height: 16,
                    ),
                    textfield(fem, 'Specialist', keterangan),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                  if (widget.label == 'Ubah Password') ...[
                    textfield(fem, 'Password Lama', passLama),
                    const SizedBox(
                      height: 16,
                    ),
                    textfield(fem, 'Password Baru', pass),
                    const SizedBox(
                      height: 16,
                    ),
                    textfield(fem, 'Konfirmasi Password Baru', passConfirm),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                  SizedBox(
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: const Color(0xff3f7af6)),
                      onPressed: () async {
                        if (widget.label == 'Ubah Nomer WA') {
                          updateNo();
                        }
                        if (widget.label == 'Ubah Email') {
                          sendConfirmEmail();
                        }
                        if (widget.label == 'Ubah Specialist') {
                          updateKeterangan();
                        }
                        if (widget.label == 'Ubah Password') {
                          API_Message result = await api.cekPasswordLama(
                              noHp: user.nohp ?? '',
                              password: passLama.text,
                              token: token);
                          cekPassLama = result.status;

                          if (result.status) {
                            if (pass.text == passConfirm.text) {
                              updatePassword();
                            }
                          }
                          setState(() {});
                        }
                      },
                      child: Center(
                        child: Text(
                          'Simpan',
                          style: TextStyle(fontSize: 16 * ffem),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField textfield(
      double fem, String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (widget.label == 'Ubah Password') {
          if (value != null && value.isNotEmpty) {
            if (label == 'Password Lama') {
              if (cekPassLama) {
                return null;
              } else {
                return 'Password Lama Tidak Sesuai';
              }
            }
            if (label == 'Konfirmasi Password Baru') {
              if (pass.text == value) {
                return null;
              } else {
                return 'Pastikan Kolom Password Baru Dan Konfirmasi Password Baru Sama';
              }
            } else {
              return null;
            }
          } else {
            return null;
          }
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: GestureDetector(
          onTap: () {
            if (widget.label == 'Ubah Nomer WA') {
              noWA.text = '';
            }
            if (widget.label == 'Ubah Email') {
              email.text = '';
            }
            if (widget.label == 'Ubah Specialist') {
              keterangan.text = '';
            }
            if (widget.label == 'Ubah Password') {
              if (label == 'Password Lama') {
                passLama.text = '';
              }
              if (label == 'Password Baru') {
                pass.text = '';
              }
              if (label == 'Konfirmasi Password Baru') {
                passConfirm.text = '';
              }
            }
          },
          child: const Icon(
            Icons.close,
            color: Colors.grey,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            8,
          ),
        ),
      ),
    );
  }

  void sendConfirmEmail() async {
    String code = RandomString().makeId(6);
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const PopUpLoading();
        });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('randomCode', code);
    bool result = await apiPass.sendEmail(
        to: email.text, code: code, subject: 'Konfirmasi Email StuntApp');
    if (result) {
      Navigator.pop(context);
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (con) {
            return GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: PopUpConfirmCode(
                email: email.text,
                onPressed: (String code) {
                  SharedPreferences.getInstance().then((prefs) async {
                    String storedCode = prefs.getString('randomCode') ?? '';
                    if (code == storedCode) {
                      updateEmail();
                      prefs.remove('randomCode');
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => const PopUpError(
                            message: 'Kode yang anda masukkan salah'),
                      );
                    }
                  });
                },
              ),
            );
          });
    } else {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) =>
            const PopUpError(message: 'Email Tidak Ditemukan'),
      );
    }
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
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => const Navigationbar(
              //             index: 3,
              //           )),
              // );
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
