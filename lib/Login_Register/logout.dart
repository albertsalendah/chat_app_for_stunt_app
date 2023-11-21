// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/LogIn/login_bloc.dart';

class PopUpLogout extends StatelessWidget {
  const PopUpLogout({
    super.key,
  });

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
                    Container(
                      height: 65 * fem,
                      width: 65 * fem,
                      decoration: BoxDecoration(
                        color: const Color(0xff3f7af6),
                        borderRadius: BorderRadius.circular(12.228260994 * fem),
                      ),
                      child: const Center(
                          child: Icon(
                        Icons.question_mark,
                        size: 70,
                        color: Colors.white,
                      )),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 8),
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 0 * fem, 7 * fem),
                          child: Text(
                            'Logout',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16 * ffem,
                              fontWeight: FontWeight.w600,
                              height: 1.2125 * ffem / fem,
                              color: const Color(0xff161f35),
                            ),
                          ),
                        ),
                        Container(
                          // penjelasansingkatintepretasiad (345:2493)
                          constraints: BoxConstraints(
                            maxWidth: 197 * fem,
                          ),
                          child: Text(
                            'Apa anda yakin ingin keluar?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14 * ffem,
                              fontWeight: FontWeight.w400,
                              height: 1.4285714286 * ffem / fem,
                              color: const Color(0xff2d2d2d),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(60 * fem, 5 * fem),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Colors.green),
                      onPressed: () async {
                        await context.read<LoginBloc>().logout();
                      },
                      child: const Text('Logout')),
                  const SizedBox(
                    width: 16,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(60 * fem, 5 * fem),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Colors.red),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Batal')),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
