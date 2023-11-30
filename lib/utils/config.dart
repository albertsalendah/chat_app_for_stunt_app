// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

import '../Bloc/LogIn/login_bloc.dart';

class Configs {
  //static const String LINK = 'http://uksw-blast-api.marikhsalatiga.com/';
  static const String LINK = 'http://192.168.100.21:8000/';
  int logoutDuration = 15;//60;
  Color green = const Color.fromRGBO(0, 167, 131, 1);
  Color blue = const Color.fromARGB(255, 76, 125, 231);

  void startSessionTimer(
      BuildContext context, LoginBloc loginBloc, Duration duration) async {
    try {
      Timer.periodic(duration, (timer) async {
        
        await loginBloc.logout();
        log('SESSION EXPIRED');
        timer.cancel();
      });
    } catch (e) {
      log('SESSION ERROR : $e');
    }
  }
}
 