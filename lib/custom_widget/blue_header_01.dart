import 'package:flutter/material.dart';

class Blue_Header_01 extends StatelessWidget {
  final String text1;
  final String text2;
  const Blue_Header_01({super.key,required this.text1,required this.text2});

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Container(
      // frame6d5T (318:1984)
      width: double.infinity,
      height: 150 * fem,
      decoration: const BoxDecoration(
        color: Color(0xff3f7af6),
      ),
      child: Stack(
        children: [
          Positioned(
            // ellipse1ZUu (318:2000)
            left: -135 * fem,
            top: -205 * fem,
            child: Align(
              child: SizedBox(
                width: 464 * fem,
                height: 464 * fem,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(232 * fem),
                    color: const Color(0xff3271f5),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            // ellipse2rD7 (318:2001)
            left: -220 * fem,
            top: -255 * fem,
            child: Align(
              child: SizedBox(
                width: 464 * fem,
                height: 464 * fem,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(232 * fem),
                    color: const Color(0xff286af5),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            // frame9kZP (318:2008)
            left: 25 * fem,
            top: 38 * fem,
            child: SizedBox(
              width: 230 * fem,
              height: 100 * fem,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    // selamatdatangkembaliUEV (318:1986)
                    margin: EdgeInsets.fromLTRB(
                        0 * fem, 0 * fem, 0 * fem, 13 * fem),
                    constraints: BoxConstraints(
                      maxWidth: 221 * fem,
                    ),
                    child: Text(
                      text1,
                      style: TextStyle(
                        fontSize: 28 * ffem,
                        fontWeight: FontWeight.w700,
                        height: 1.1579999924 * ffem / fem,
                        color: const Color(0xffffffff),
                      ),
                    ),
                  ),
                  Text(
                      // silahkanmengisidatadibawahiniX (318:2007)
                      text2,
                      style: TextStyle(
                        fontSize: 14 * ffem,
                        fontWeight: FontWeight.w400,
                        height: 1.1579999924 * ffem / fem,
                        color: const Color(0xccffffff),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
