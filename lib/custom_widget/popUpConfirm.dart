import 'package:flutter/material.dart';

class PopUpConfirm extends StatelessWidget {
  final String btnConfirmText;
  final String btnCancelText;
  final String title;
  final String message;
  final VoidCallback onPressed;
  const PopUpConfirm(
      {super.key,
      required this.btnConfirmText,
      required this.btnCancelText,
      required this.title,
      required this.message,
      required this.onPressed});

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
                          color: Colors.amberAccent, //const Color(0xffebf1fe),
                          borderRadius:
                              BorderRadius.circular(12.228260994 * fem),
                        ),
                        child: const Center(
                            child: Icon(
                          Icons.question_mark_rounded,
                          size: 80,
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
                              title,
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
                              message,
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
                              onPressed();
                            },
                            child: Text(btnConfirmText)),
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
                            child: Text(btnCancelText)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ));
  }
}
