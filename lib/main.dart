import 'dart:developer';
import 'package:chat_app_for_stunt_app/Bloc/KonsultasiBloc/konsultasiBloc.dart';
import 'package:chat_app_for_stunt_app/utils/firebase_api.dart';
import 'package:chat_app_for_stunt_app/utils/sqlite_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Bloc/Bloc/AllBloc.dart';
import 'Bloc/LogIn/login_bloc.dart';
import 'Bloc/LogIn/login_state.dart';
import 'Chats/chat_list.dart';
import 'Login_Register/login.dart';
import 'firebase_options.dart';
import 'navigation_bar.dart';

final navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initPushNotifications();
  await FirebaseApi().initLocalNotification();
  await SqliteHelper().database;
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AllBloc()),
        BlocProvider(create: (context) => LoginBloc()),
        BlocProvider(create: (context) => KonsultasiBloc()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;
  bool isSessionExpired = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<LoginBloc>().isLogIn();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        if (state is LoginInitial) {
        } else if (state is LoginErrorState) {
        } else if (state is LoggedInState) {
          isLoggedIn = state.isLoggedIn;
          isSessionExpired = state.isSessionExpired;
        }
        log(' Is User Loggedin : ${isLoggedIn && !isSessionExpired}');
        if (isLoggedIn && !isSessionExpired) {
          return MaterialApp(
              navigatorKey: navigatorKey,
              routes: {ChatList.route: (context) => const ChatList()},
              home: const Navigationbar(index: 0));
        } else {
          return const MaterialApp(home: Login());
        }
      },
    );
  }
}
