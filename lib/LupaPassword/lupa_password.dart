// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:chat_app_for_stunt_app/custom_widget/popUpLoading.dart';
import 'package:chat_app_for_stunt_app/custom_widget/popup_error.dart';
import 'package:chat_app_for_stunt_app/custom_widget/popup_success.dart';
import 'package:chat_app_for_stunt_app/models/api_massage.dart';
import 'package:chat_app_for_stunt_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/random_String.dart';
import 'lupa_password_api.dart';

class LupaPassword extends StatefulWidget {
  const LupaPassword({super.key});

  @override
  State<LupaPassword> createState() => _LupaPasswordState();
}

class _LupaPasswordState extends State<LupaPassword> {
  LupaPasswordApi api = LupaPasswordApi();
  TextEditingController noController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController passConfirm = TextEditingController();
  int countdown = 300;
  late Timer timer;
  bool confirmCode = false;
  bool showResetForm = false;
  bool resend = false;
  User user = User();

  @override
  void initState() {
    super.initState();
    timer = Timer(Duration.zero, () {});
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (countdown > 0) {
          confirmCode = true;
          resend = true;
          countdown--;
        } else {
          resetCode();
          timer.cancel();
        }
      });
    });
  }

  Future<void> resetCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('randomCode');
    setState(() {
      resend = false;
      countdown = 300;
    });
  }

  void sendResetEmail() async {
    String code = RandomString().makeId(6);
    user = await api.getDataUser(noHp: noController.text);
    if (user.email != null && user.email.toString().isNotEmpty) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return const PopUpLoading();
          });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('randomCode', code);
      bool result = await api.sendEmail(
          to: user.email.toString(),
          code: code,
          subject: 'Reset Password StuntApp');
      if (result) {
        startTimer();
        Navigator.pop(context);
      } else {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) =>
              const PopUpError(message: 'Akun Tidak Ditemukan'),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => const PopUpError(message: 'Akun Tidak Ditemukan'),
      );
    }
  }

  void verifyCode(String enteredCode) {
    SharedPreferences.getInstance().then((prefs) {
      String storedCode = prefs.getString('randomCode') ?? '';
      setState(() {
        if (enteredCode == storedCode && countdown > 0) {
          showResetForm = true;
          codeController.clear();
          confirmCode = false;
          resetCode();
        } else {
          showResetForm = false;
          codeController.clear();
        }
      });
    });
  }

  resetPassowrd() async {
    API_Message result = await api.updatePassword(
        userID: user.userID.toString(), password: passConfirm.text);
    if (result.status) {
      showDialog(
          context: context,
          builder: (context) => PopUpSuccess(
                message: result.message.toString(),
              )).then((value) {
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
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    return SafeArea(
        child: GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            shadowColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.grey),
            title: const Text(
              'Reset Password',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black),
            ),
            leading: backbutton(fem, context)),
        body: PopScope(
          canPop: !resend,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: !showResetForm
                  ? Visibility(
                      visible: !confirmCode,
                      replacement: codeForm(),
                      child: noForm(),
                    )
                  : Column(children: [
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
                      ElevatedButton(
                          onPressed: () {
                            if (pass.text == passConfirm.text) {
                              resetPassowrd();
                            }
                          },
                          child: const Text('Reset Password'))
                    ]),
            ),
          ),
        ),
      ),
    ));
  }

  Column codeForm() {
    return Column(children: [
      const Align(
          alignment: Alignment.centerLeft,
          child: Text('Masukan Kode Yang Dikirim Ke Email Disini')),
      const SizedBox(
        height: 8,
      ),
      TextFormField(
        controller: codeController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          hintText: 'Ketik Kode Disini',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Masukan Kode Yang Dikirim Ke Email Disini';
          }
          return null; // Return null if the input is valid
        },
      ),
      const SizedBox(
        height: 8,
      ),
      Align(
        alignment: Alignment.center,
        child: ElevatedButton(
            onPressed: () {
              verifyCode(codeController.text);
            },
            child: const Text('Send')),
      ),
      const SizedBox(height: 16),
      resend
          ? Text(
              'Time remaining: ${countdown ~/ 60}:${(countdown % 60).toString().padLeft(2, '0')}')
          : GestureDetector(
              onTap: () {
                sendResetEmail();
              },
              child: const Text(
                'Kirim Ulang?',
                style: TextStyle(color: Colors.blue),
              ),
            ),
    ]);
  }

  Column noForm() {
    return Column(children: [
      const Align(
          alignment: Alignment.centerLeft,
          child: Text('Gunakan Nomer HP Yang Terdaftar di Aplikasi')),
      const SizedBox(
        height: 8,
      ),
      TextFormField(
        controller: noController,
        keyboardType: TextInputType.phone,
        onEditingComplete: () {
          FocusScope.of(context).unfocus();
        },
        decoration: InputDecoration(
          hintText: 'Nomor HP',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      const SizedBox(
        height: 8,
      ),
      Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton(
            onPressed: () {
              sendResetEmail();
            },
            child: const Text('Send')),
      ),
    ]);
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegex.hasMatch(email);
  }

  TextFormField textfield(
      double fem, String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          if (label == 'Konfirmasi Password Baru') {
            if (pass.text == value) {
              return null; // Validation passed
            } else {
              return 'Pastikan Kolom Password Baru Dan Konfirmasi Password Baru Sama';
            }
          } else {
            return null; // Validation passed for other cases
          }
        } else {
          return 'Kolom $label tidak boleh kosong'; // Validation failed for empty input
        }
      },
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: GestureDetector(
          onTap: () {
            if (label == 'Password Baru') {
              pass.text = '';
            }
            if (label == 'Konfirmasi Password Baru') {
              passConfirm.text = '';
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
              if (!resend) {
                Navigator.pop(context);
              }
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
