import 'package:flutter/material.dart';

class PopUpSuccess extends StatelessWidget {
  final String message;
  const PopUpSuccess({super.key, required this.message});

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
                          color: Colors.green, //const Color(0xffebf1fe),
                          borderRadius:
                              BorderRadius.circular(12.228260994 * fem),
                        ),
                        child: const Center(
                            child: Icon(
                          Icons.check,
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
                              'Success',
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
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: const Color(0xff3f7af6)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Tutup')),
                )
              ],
            ),
          ],
        ));
  }
}
