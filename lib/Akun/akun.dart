// ignore_for_file: non_constant_identifier_names
import 'package:chat_app_for_stunt_app/Akun/updateFotoPopUp.dart';
import 'package:chat_app_for_stunt_app/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/user.dart';
import '../../utils/SessionManager.dart';
import '../Bloc/Bloc/AllBloc.dart';
import '../Bloc/Bloc/AllState.dart';
import '../Login_Register/login.dart';
import '../Login_Register/logout.dart';
import '../custom_widget/popUpConfirm.dart';
import '../custom_widget/popup_error.dart';
import '../models/api_massage.dart';
import '../navigation_bar.dart';
import 'edit_akun.dart';
import 'edit_akun_api.dart';

class Akun extends StatefulWidget {
  const Akun({super.key});

  @override
  State<Akun> createState() => _AkunState();
}

class _AkunState extends State<Akun> {
  User user = User();
  static const String link = Configs.LINK;
  String token = '';
  EditAkunApi api = EditAkunApi();
  TextEditingController no_wa = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController keterangan = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      user = await fetch_user();
      token = await SessionManager.getToken() ?? '';
      if (user.userID == null) {
        await fetch_Data();
      }
      setState(() {});
    });
  }

  Future<User> fetch_user() async {
    return await SessionManager.getUser();
  }

  void saveUser(User user) async {
    await SessionManager.saveUser(user);
  }

  Future<void> fetch_Data() async {
    await context
        .read<AllBloc>()
        .getUserData(userID: user.userID.toString(), token: token);
  }

  void setData() {
    if (user.userID != null) {
      no_wa.text = user.nohp ?? '';
      email.text = user.email ?? '';
      keterangan.text = user.keterangan ?? '';
    }
  }

  Future<void> hapusAkun() async {
    API_Message result =
        await api.hapusAkun(userID: user.userID ?? '', token: token);
    if (result.status) {
      await SessionManager.logout();
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return const Login();
        },
      ));
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => PopUpError(message: result.message ?? ''),
      );
    }
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
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.grey),
            title: Text(
              'Akun Saya',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16 * fem,
                  color: Colors.black),
            ),
            leading: backbutton(fem, context),
            actions: [settingbutton(fem, context)],
          ),
          backgroundColor: Colors.white,
          body: BlocBuilder<AllBloc, AllState>(
            builder: (context, state) {
              if (state is DataInitialState) {
                return Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: 40 * fem,
                            width: 40 * fem,
                            child: const CircularProgressIndicator()),
                        const SizedBox(
                          height: 8,
                        ),
                        const Text('Memuat Data')
                      ]),
                );
              } else if (state is DataErrorState) {
                return Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error,
                          color: Colors.red,
                          size: 32 * fem,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(state.errorMessage)
                      ]),
                );
              } else if (state is UserDataLoaded) {
                user = state.user;
                saveUser(user);
              }
              if (user.userID != null) {
                setData();
              }
              return RefreshIndicator(
                onRefresh: () async {
                  await fetch_Data();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      header_akun(fem, ffem),
                      const SizedBox(
                        height: 16,
                      ),
                      textfield(fem, 'Nomer Wa', no_wa),
                      const SizedBox(
                        height: 16,
                      ),
                      textfield(fem, 'Email', email),
                      const SizedBox(
                        height: 16,
                      ),
                      textfield(fem, 'Specialist', keterangan),
                      const SizedBox(
                        height: 16,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditAkun(
                                      label: 'Ubah Password',
                                      no: user.nohp ?? '',
                                      email: user.email ?? '',
                                      keterangan: user.keterangan ?? '',
                                    )),
                          );
                        },
                        child: const Row(
                          children: [
                            Icon(
                              Icons.lock,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              'Ganti Password',
                              style: TextStyle(fontSize: 16),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const Row(
                        children: [
                          Icon(
                            Icons.question_mark,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                            'Bantuan',
                            style: TextStyle(fontSize: 16),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => PopUpConfirm(
                              btnConfirmText: 'Hapus',
                              btnCancelText: 'Batal',
                              title: 'Hapus Akun',
                              message:
                                  'Apakah Anda Yakin Akan Menghapus Akun Ini?',
                              onPressed: () => hapusAkun(),
                            ),
                          );
                        },
                        child: const Row(
                          children: [
                            Icon(
                              Icons.delete_forever_outlined,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              'Hapus Akun',
                              style: TextStyle(color: Colors.red, fontSize: 16),
                            )
                          ],
                        ),
                      )
                    ]),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  TextFormField textfield(
      double fem, String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        hintText: label == 'Specialist' ? 'Contoh : Pakar Gizi' : '',
        labelText: label,
        suffixIcon: GestureDetector(
          onTap: () {
            if (label == 'Nomer Wa') {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditAkun(
                          label: 'Ubah Nomer WA',
                          no: user.nohp ?? '',
                          email: user.email ?? '',
                          keterangan: user.keterangan ?? '',
                        )),
              );
            } else if (label == 'Email') {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditAkun(
                          label: 'Ubah Email',
                          no: user.nohp ?? '',
                          email: user.email ?? '',
                          keterangan: user.keterangan ?? '',
                        )),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditAkun(
                          label: 'Ubah Specialist',
                          no: user.nohp ?? '',
                          email: user.email ?? '',
                          keterangan: user.keterangan ?? '',
                        )),
              );
            }
          },
          child: const Icon(
            Icons.edit_square,
            color: Colors.grey,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            8,
          ),
        ),
      ),
    );
  }

  Padding backbutton(double fem, BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0 * fem),
      child: Container(
        height: 20 * fem,
        width: 20 * fem,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffe2e2e2)),
          color: const Color(0xffffffff),
          borderRadius: BorderRadius.circular(8 * fem),
        ),
        child: IconButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const Navigationbar(
                          index: 0,
                        )),
              );
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.grey,
              size: 16 * fem,
            )),
      ),
    );
  }

  Container settingbutton(double fem, BuildContext context) {
    return Container(
      height: 40 * fem,
      width: 40 * fem,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8 * fem),
        border: Border.all(color: const Color(0xffe2e2e2)),
        color: const Color(0xffffffff),
      ),
      margin: EdgeInsets.only(
        left: 4 * fem,
        right: 4 * fem,
        bottom: 4 * fem,
        top: 8 * fem,
      ),
      child: PopupMenuButton(
        icon: const Icon(
          Icons.settings,
          color: Colors.grey,
        ),
        itemBuilder: (context) {
          return <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'logout',
              child: Row(
                children: [
                  Icon(
                    Icons.logout,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text('Logout'),
                ],
              ),
            ),
          ];
        },
        onSelected: (value) {
          if (value == 'logout') {
            showDialog(
              context: context,
              builder: (context) {
                return const PopUpLogout();
              },
            );
          }
        },
      ),
    );
  }

  Container header_akun(double fem, double ffem) {
    return Container(
      margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 20 * fem),
      width: double.infinity,
      height: 81 * fem,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xfff0f0f0)),
      ),
      child: SizedBox(
        width: 216 * fem,
        height: 65 * fem,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => const UpdateFotoPopUp(),
                ).then((value) async {
                  await fetch_Data();
                });
              },
              child: Container(
                margin:
                    EdgeInsets.fromLTRB(0 * fem, 0 * fem, 12 * fem, 0 * fem),
                padding: EdgeInsets.only(left: 8 * fem),
                width: 65 * fem,
                height: 65 * fem,
                child: CircleAvatar(
                  radius: 65.0,
                  backgroundImage: user.foto != null && user.foto!.isNotEmpty
                      ? NetworkImage(link + user.foto.toString(),
                          headers: {'x-access-token': token}) as ImageProvider
                      : const AssetImage('assets/images/group-115.png'),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: 65,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(200),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(65),
                          bottomRight: Radius.circular(65),
                        ),
                      ),
                      child: const Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            'Ubah',
                            style: TextStyle(color: Colors.black),
                          )),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0 * fem, 14 * fem, 0 * fem, 14 * fem),
              height: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin:
                        EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 3 * fem),
                    child: Text(
                      user.nama ?? '',
                      style: TextStyle(
                        fontSize: 14 * ffem,
                        fontWeight: FontWeight.w600,
                        height: 1.2125 * ffem / fem,
                        color: const Color(0xff161f35),
                      ),
                    ),
                  ),
                  Text(
                    user.nohp ?? '',
                    style: TextStyle(
                      fontSize: 14 * ffem,
                      fontWeight: FontWeight.w400,
                      height: 1.2125 * ffem / fem,
                      color: const Color(0xff2d2d2d),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
