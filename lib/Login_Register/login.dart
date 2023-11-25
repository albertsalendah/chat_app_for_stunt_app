// ignore_for_file: use_build_context_synchronously

import 'package:chat_app_for_stunt_app/Login_Register/register.dart';
import 'package:chat_app_for_stunt_app/LupaPassword/lupa_password.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/LogIn/login_bloc.dart';
import '../../models/api_massage.dart';
import '../custom_widget/blue_header_01.dart';
import '../custom_widget/popup_error.dart';
import 'login_register_api.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool passwordVisible = false;
  TextEditingController no_wa = TextEditingController();
  TextEditingController pass = TextEditingController();
  Login_Register_Api api = Login_Register_Api();
  FocusNode btnFocus = FocusNode();
  List<FocusNode> focusNodes = List.generate(3, (index) => FocusNode());

  void clear_field() {
    no_wa.text = '';
    pass.text = '';
  }

  @override
  void dispose() {
    btnFocus.dispose();
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
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
                    text1: 'Selamat datang kembali!',
                    text2: 'Silahkan mengisi data dibawah ini'),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom / 2),
                    child: Column(children: [
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
                                focusNode: focusNodes[0],
                                onEditingComplete: () =>
                                    FocusScope.of(context).nextFocus(),
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
                                    prefixIconConstraints: const BoxConstraints(
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
                              child: Text('Kata Sandi'),
                            ),
                            TextFormField(
                                controller: pass,
                                focusNode: focusNodes[1],
                                onEditingComplete: () =>
                                    btnFocus.requestFocus(),
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LupaPassword(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Lupa password?',
                                style: TextStyle(
                                    fontSize: 16, color: Color(0xff3f7af6)),
                              ),
                            )),
                      )
                    ]),
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
                            focusNode: btnFocus,
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                backgroundColor: const Color(0xff3f7af6)),
                            onPressed: () async {
                              if (no_wa.text.isNotEmpty &&
                                  pass.text.isNotEmpty) {
                                API_Message result = await context
                                    .read<LoginBloc>()
                                    .login(
                                        noHp: no_wa.text, password: pass.text);
                                if (result.status) {
                                  clear_field();
                                } else {
                                  clear_field();
                                  showDialog(
                                    context: context,
                                    builder: (context) => PopUpError(
                                        message: result.message.toString()),
                                  );
                                }
                              } else {
                                if (no_wa.text.isEmpty) {
                                  focusNodes[0].requestFocus();
                                } else {
                                  focusNodes[1].requestFocus();
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
                                'Masuk',
                                style: TextStyle(fontSize: 16 * ffem),
                              ),
                            ),
                          )),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 14 * ffem,
                            fontWeight: FontWeight.w400,
                            height: 1.2125 * ffem / fem,
                            color: const Color(0xff707070),
                          ),
                          children: [
                            const TextSpan(
                              text: 'Belum punya akun? Daftar ',
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
                                        builder: (context) => const Register()),
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
