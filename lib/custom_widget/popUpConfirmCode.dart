// ignore_for_file: use_build_context_synchronously

import 'package:chat_app_for_stunt_app/LupaPassword/lupa_password_api.dart';
import 'package:chat_app_for_stunt_app/custom_widget/popUpLoading.dart';
import 'package:chat_app_for_stunt_app/custom_widget/popup_error.dart';
import 'package:chat_app_for_stunt_app/utils/random_String.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PopUpConfirmCode extends StatefulWidget {
  final String email;
  final Function(String) onPressed;
  const PopUpConfirmCode(
      {super.key, required this.email, required this.onPressed});

  @override
  State<PopUpConfirmCode> createState() => _PopUpConfirmCodeState();
}

class _PopUpConfirmCodeState extends State<PopUpConfirmCode> {
  LupaPasswordApi api = LupaPasswordApi();
  @override
  Widget build(BuildContext context) {
    TextEditingController confirmCode = TextEditingController();
    return AlertDialog(
      clipBehavior: Clip.hardEdge,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      content: Wrap(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 65,
                    width: 65,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12.228260994),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.mark_email_unread_outlined,
                          size: 50,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 8),
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 7),
                        child: const Text(
                          'Email Konfirmasi Terkirim',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 1.2125,
                            color: Color(0xff161f35),
                          ),
                        ),
                      ),
                      Text(
                        'Kode Konfirmasi Terkirm ke Email\n${widget.email}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.4285714286,
                          color: Color(0xff2d2d2d),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: confirmCode,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          hintText: 'Ketik Kode Disini',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Masukan Kode 6 digit yang dikirim ke email anda disini';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      GestureDetector(
                        onTap: () async {
                          String code = RandomString().makeId(6);

                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return const PopUpLoading();
                              });
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setString('randomCode', code);
                          bool result = await api.sendEmail(
                              to: widget.email,
                              code: code,
                              subject: 'Konfirmasi Email StuntApp');
                          if (result) {
                            Navigator.pop(context);
                          } else {
                            Navigator.pop(context);
                            showDialog(
                              context: context,
                              builder: (context) => const PopUpError(
                                  message:
                                      'Terjadi Kesalahan Saat Mengirim Kode'),
                            );
                          }
                        },
                        child: const Text(
                          'Kirim Ulang?',
                          style: TextStyle(color: Colors.blue),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
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
                          onPressed: () {
                            widget.onPressed(confirmCode.text);
                          },
                          child: const Text(
                            'Simpan',
                            style: TextStyle(color: Colors.white),
                          )),
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
                            Navigator.pop(context);
                          },
                          child: const Text('Batal',
                              style: TextStyle(color: Colors.white))),
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
