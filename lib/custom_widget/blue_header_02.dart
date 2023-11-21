import 'package:flutter/material.dart';

class Blue_Header_02 extends StatelessWidget {
  final String text1;
  final String text2;
  const Blue_Header_02({super.key,required this.text1,required this.text2});

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Container(
      // frame54Frq (358:14915)
      margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 13 * fem),
      width: double.infinity,
      height: 123 * fem,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12 * fem),
        gradient: const LinearGradient(
          begin: Alignment(-0.978, -1.146),
          end: Alignment(1.203, 1.366),
          colors: <Color>[Color(0xff3f7af6), Color(0xff094fe2)],
          stops: <double>[0, 1],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            // ellipse303vCH (358:14967)
            left: -25 * fem,
            top: 33 * fem,
            child: Align(
              child: SizedBox(
                width: 187 * fem,
                height: 187 * fem,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(93.5 * fem),
                    color: const Color(0x7f4b80ec),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 29 * fem,
            top: 15 * fem,
            child: Align(
              child: SizedBox(
                width: 84.86 * fem,
                height: 215 * fem,
                child: Image.asset(
                  'assets/images/image-1-K4V.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            left: 124 * fem,
            top: 24 * fem,
            child: Align(
              child: SizedBox(
                width: 174 * fem,
                height: 44 * fem,
                child: Text(
                  text1,
                  style: TextStyle(
                      fontSize: 18 * ffem,
                      fontWeight: FontWeight.w600,
                      height: 1.2125 * ffem / fem,
                      color: Colors.white //Color(0xffffffff),
                      ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 124 * fem,
            top: 73 * fem,
            child: Align(
              child: SizedBox(
                width: 153 * fem,
                height: 20 * fem,
                child: Text(
                  text2,
                  style: TextStyle(
                    fontSize: 12 * ffem,
                    fontWeight: FontWeight.w400,
                    height: 1.6666666667 * ffem / fem,
                    color: const Color(0xffffffff),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
