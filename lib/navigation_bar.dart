// ignore_for_file: use_build_context_synchronously
import 'package:chat_app_for_stunt_app/Bloc/KonsultasiBloc/konsultasiBloc.dart';
import 'package:chat_app_for_stunt_app/Bloc/SocketBloc/socket_bloc.dart';
import 'package:chat_app_for_stunt_app/MenuAsupan/rekomendasi_menu_asupan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../Bloc/LogIn/login_bloc.dart';
import '../utils/SessionManager.dart';
import '../utils/config.dart';
import 'Akun/akun.dart';
import 'Bloc/Bloc/AllBloc.dart';
import 'Chats/chat_list.dart';
import 'models/user.dart';

class Navigationbar extends StatefulWidget {
  final int index;
  const Navigationbar({super.key, required this.index});

  @override
  State<Navigationbar> createState() => _NavigationbarState();
}

class _NavigationbarState extends State<Navigationbar> {
  int selectedIndex = 0;
  User user = User();
  String token = '';
  final screens = [
    const ChatList(),
    const RekomendasiMenuAsupan(),
    const Akun()
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      String token = await SessionManager.getToken() ?? '';
      user = await fetch_user();
      Duration duration = token.isNotEmpty
          ? JwtDecoder.getRemainingTime(token)
          : const Duration(minutes: 0);
      Configs().startSessionTimer(context, context.read<LoginBloc>(), duration);
      await fetchData(token);
      setState(() {
        selectedIndex = widget.index;
      });
      context
          .read<SocketProviderBloc>()
          .connectSocket(userID: user.userID.toString());
    });
  }

  Future<User> fetch_user() async {
    return await SessionManager.getUser();
  }

  Future<void> fetchData(String token) async {
    await context
        .read<AllBloc>()
        .getUserData(userID: user.userID.toString(), token: token);
    await context
        .read<KonsultasiBloc>()
        .getLatestMesage(userID: user.userID.toString());
    await context
        .read<AllBloc>()
        .getListRekomendasi(user_id: user.userID ?? '', token: token);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType
            .fixed, // This ensures that all labels are visible
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank_outlined),
            label: 'Rekomendasi Menu',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.ballot),
          //   label: 'Konsultasi',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Akun',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: const Color(0xff3f7af6),
        unselectedItemColor: Colors.grey, // Color of unselected items
        backgroundColor: Colors.white,
        elevation: 3,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
      ),
    );
  }
}
