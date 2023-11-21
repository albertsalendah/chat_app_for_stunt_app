// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:chat_app_for_stunt_app/custom_widget/popUpConfirm.dart';
import 'package:chat_app_for_stunt_app/models/api_massage.dart';
import 'package:chat_app_for_stunt_app/utils/formatTgl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../Bloc/Bloc/AllBloc.dart';
import '../Bloc/Bloc/AllState.dart';
import '../custom_widget/popup_error.dart';
import '../custom_widget/popup_success.dart';
import '../models/rekomendasiMenuMakan.dart';
import '../models/user.dart';
import '../navigation_bar.dart';
import '../utils/SessionManager.dart';
import 'menu_asupan_field.dart';
import 'menu_makan_api.dart';

class RekomendasiMenuAsupan extends StatefulWidget {
  const RekomendasiMenuAsupan({super.key});

  @override
  State<RekomendasiMenuAsupan> createState() => _RekomendasiMenuAsupanState();
}

class _RekomendasiMenuAsupanState extends State<RekomendasiMenuAsupan> {
  MenuMakanAPI api = MenuMakanAPI();
  User user = User();
  String token = '';
  TextEditingController makananPokok = TextEditingController();
  TextEditingController makananPokokCount = TextEditingController();
  TextEditingController makananPokokMeasure = TextEditingController();

  TextEditingController sayur = TextEditingController();
  TextEditingController sayurCount = TextEditingController();
  TextEditingController sayurMeasure = TextEditingController();

  TextEditingController laukHewani = TextEditingController();
  TextEditingController laukHewaniCount = TextEditingController();
  TextEditingController laukHewaniMeasure = TextEditingController();

  TextEditingController laukNabati = TextEditingController();
  TextEditingController laukNabatiCount = TextEditingController();
  TextEditingController laukNabatiMeasure = TextEditingController();

  TextEditingController buah = TextEditingController();
  TextEditingController buahCount = TextEditingController();
  TextEditingController buahMeasure = TextEditingController();

  TextEditingController minuman = TextEditingController();
  TextEditingController minumanCount = TextEditingController();
  TextEditingController minumanMeasure = TextEditingController();

  TextEditingController jamMakan = TextEditingController();
  FocusNode timeFocus = FocusNode();

  int selectedMenuMakan = 1;
  List<String> menu = [
    'Menu Makan Pagi',
    'Menu Makan Siang',
    'Menu Makan Malam'
  ];
  List<String> listSatuanMakan = [
    'Sdm (satu sendok makan)',
    'Sdt (satu sendok teh)',
    'Butir',
    'Potong',
    'Sendok Sayur',
    'Centong',
    'Buah',
    'Piring',
    'Mangkok'
  ];
  List<String> listSatuanMinuman = ['Gelas', 'Cangkir'];

  List<RekomendasiMenuMakan> listRekomendasi = [];
  RekomendasiMenuMakan menuMakan = RekomendasiMenuMakan();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      jamMakan.text = selectedMenuMakan == 1
          ? '07:00'
          : selectedMenuMakan == 2
              ? '12:00'
              : '18:00';
      user = await fetch_user();
      token = await SessionManager.getToken() ?? '';
      await fetchData(token);
    });
  }

  Future<User> fetch_user() async {
    return await SessionManager.getUser();
  }

  Future<void> fetchData(String token) async {
    await context
        .read<AllBloc>()
        .getListRekomendasi(user_id: user.userID ?? '', token: token);
  }

  void setMenuMakan() {
    if (menuMakan.idmenu != null) {
      jamMakan.text = menuMakan.jammakan.toString();
      makananPokok.text = menuMakan.makananpokok.toString();
      makananPokokCount.text = menuMakan.jumlahmk.toString();
      makananPokokMeasure.text = menuMakan.satuanmk.toString();
      sayur.text = menuMakan.sayur.toString();
      sayurCount.text = menuMakan.jumlahsayur.toString();
      sayurMeasure.text = menuMakan.satuansayur.toString();
      laukHewani.text = menuMakan.laukhewani.toString();
      laukHewaniCount.text = menuMakan.jumlahlaukhewani.toString();
      laukHewaniMeasure.text = menuMakan.satuanlaukhewani.toString();
      laukNabati.text = menuMakan.lauknabati.toString();
      laukNabatiCount.text = menuMakan.jumlahlauknabati.toString();
      laukNabatiMeasure.text = menuMakan.satuanlauknabati.toString();
      buah.text = menuMakan.buah.toString();
      buahCount.text = menuMakan.jumlahbuah.toString();
      buahMeasure.text = menuMakan.satuanbuah.toString();
      minuman.text = menuMakan.minuman.toString();
      minumanCount.text = menuMakan.jumlahminuman.toString();
      minumanMeasure.text = menuMakan.satuanminuman.toString();
    }
  }

  void clearField() {
    jamMakan.text = selectedMenuMakan == 1
        ? '07:00'
        : selectedMenuMakan == 2
            ? '12:00'
            : '18:00';
    makananPokok.clear();
    makananPokokCount.clear();
    makananPokokMeasure.text = listSatuanMakan[5];
    sayur.clear();
    sayurCount.clear();
    sayurMeasure.text = listSatuanMakan[4];
    laukHewani.clear();
    laukHewaniCount.clear();
    laukHewaniMeasure.text = listSatuanMakan[3];
    laukNabati.clear();
    laukNabatiCount.clear();
    laukNabatiMeasure.text = listSatuanMakan[3];
    buah.clear();
    buahCount.clear();
    buahMeasure.text = listSatuanMakan[6];
    minuman.clear();
    minumanCount.clear();
    minumanMeasure.text = listSatuanMinuman[0];
  }

  addRekomendasiMenu() {
    showDialog(
      context: context,
      builder: (context) => PopUpConfirm(
        btnConfirmText: 'Simpan',
        btnCancelText: 'Batal',
        title: 'Tambah Menu',
        message: 'Tambah ${menu[selectedMenuMakan - 1]}',
        onPressed: () async {
          API_Massage result = await api.addMenuMakan(
              user_id: user.userID.toString(),
              menu_makan: selectedMenuMakan,
              jam_makan: jamMakan.text,
              makan_pokok: makananPokok.text,
              jumlah_mk: makananPokokCount.text,
              satuan_mk: makananPokokMeasure.text,
              sayur: sayur.text,
              jumlah_sayur: sayurCount.text,
              satuan_sayur: sayurMeasure.text,
              lauk_hewani: laukHewani.text,
              jumlah_lauk_hewani: laukHewaniCount.text,
              satuan_lauk_hewani: laukHewaniMeasure.text,
              lauk_nabati: laukNabati.text,
              jumlah_lauk_nabati: laukNabatiCount.text,
              satuan_lauk_nabati: laukNabatiMeasure.text,
              buah: buah.text,
              jumlah_buah: buahCount.text,
              satuan_buah: buahMeasure.text,
              minuman: minuman.text,
              jumlah_minuman: minumanCount.text,
              satuan_minuman: minumanMeasure.text,
              token: token);
          if (result.status) {
            Navigator.pop(context);
            await fetchData(token);
            showDialog(
              context: context,
              builder: (context) => PopUpSuccess(message: result.message ?? ''),
            ).then((value) {
              setState(() {
                clearField();
                menuMakan = RekomendasiMenuMakan();
                // setMenuMakan();
              });
            });
          } else {
            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (context) => PopUpError(message: result.message ?? ''),
            );
          }
        },
      ),
    );
  }

  updateRekomendasiMenu() {
    showDialog(
      context: context,
      builder: (context) => PopUpConfirm(
        btnConfirmText: 'Simpan',
        btnCancelText: 'Batal',
        title: 'Update Menu',
        message: 'Update ${menu[selectedMenuMakan - 1]}',
        onPressed: () async {
          API_Massage result = await api.updateMenuMakan(
              id_menu: menuMakan.idmenu.toString(),
              menu_makan: selectedMenuMakan,
              jam_makan: jamMakan.text,
              makan_pokok: makananPokok.text,
              jumlah_mk: makananPokokCount.text,
              satuan_mk: makananPokokMeasure.text,
              sayur: sayur.text,
              jumlah_sayur: sayurCount.text,
              satuan_sayur: sayurMeasure.text,
              lauk_hewani: laukHewani.text,
              jumlah_lauk_hewani: laukHewaniCount.text,
              satuan_lauk_hewani: laukHewaniMeasure.text,
              lauk_nabati: laukNabati.text,
              jumlah_lauk_nabati: laukNabatiCount.text,
              satuan_lauk_nabati: laukNabatiMeasure.text,
              buah: buah.text,
              jumlah_buah: buahCount.text,
              satuan_buah: buahMeasure.text,
              minuman: minuman.text,
              jumlah_minuman: minumanCount.text,
              satuan_minuman: minumanMeasure.text,
              token: token);
          if (result.status) {
            Navigator.pop(context);
            await fetchData(token);
            showDialog(
              context: context,
              builder: (context) => PopUpSuccess(message: result.message ?? ''),
            ).then((value) {
              setState(() {
                clearField();
                menuMakan = RekomendasiMenuMakan();
                // setMenuMakan();
              });
            });
          } else {
            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (context) => PopUpError(message: result.message ?? ''),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.grey),
            title: const Text(
              'Rekomendasi Menu Asupan',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
            leading: backbutton(context)),
        backgroundColor: Colors.white,
        body: BlocBuilder<AllBloc, AllState>(
          builder: (context, state) {
            if (state is DataInitialState) {
              return const Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: 40,
                          width: 40,
                          child: CircularProgressIndicator()),
                      SizedBox(
                        height: 8,
                      ),
                      Text('Memuat Data')
                    ]),
              );
            } else if (state is DataErrorState) {
              return Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 32,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(state.errorMessage)
                    ]),
              );
            } else if (state is ListRekomendasiMenuLoaded) {
              listRekomendasi = state.listRekomendasi;
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom / 2),
                    reverse: false,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: DropdownMenu<String>(
                            width: MediaQuery.of(context).size.width - 17,
                            inputDecorationTheme: InputDecorationTheme(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            onSelected: (String? value) {
                              if (value != null) {
                                selectedMenuMakan = menu.indexOf(value) + 1;
                                jamMakan.text = selectedMenuMakan == 1
                                    ? '07:00'
                                    : selectedMenuMakan == 2
                                        ? '12:00'
                                        : '18:00';
                              }
                              setState(() {});
                            },
                            initialSelection: menu.first,
                            dropdownMenuEntries: menu
                                .map<DropdownMenuEntry<String>>((String value) {
                              return DropdownMenuEntry<String>(
                                  value: value, label: value);
                            }).toList(),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        jamMakanPicker(),
                        const SizedBox(
                          height: 16,
                        ),
                        MenuAsupanField(
                            label: 'Makanan Pokok',
                            hint: 'Nasi',
                            hintM: listSatuanMakan[5],
                            list: listSatuanMakan,
                            mainController: makananPokok,
                            countController: makananPokokCount,
                            measurementController: makananPokokMeasure),
                        const SizedBox(
                          height: 16,
                        ),
                        MenuAsupanField(
                            label: 'Sayur',
                            hint: 'Bayam',
                            hintM: listSatuanMakan[4],
                            list: listSatuanMakan,
                            mainController: sayur,
                            countController: sayurCount,
                            measurementController: sayurMeasure),
                        const SizedBox(
                          height: 16,
                        ),
                        MenuAsupanField(
                            label: 'Lauk Hewani',
                            hint: 'Ikan',
                            hintM: listSatuanMakan[3],
                            list: listSatuanMakan,
                            mainController: laukHewani,
                            countController: laukHewaniCount,
                            measurementController: laukHewaniMeasure),
                        const SizedBox(
                          height: 16,
                        ),
                        MenuAsupanField(
                            label: 'Lauk Nabati',
                            hint: 'Tahu',
                            hintM: listSatuanMakan[3],
                            list: listSatuanMakan,
                            mainController: laukNabati,
                            countController: laukNabatiCount,
                            measurementController: laukNabatiMeasure),
                        const SizedBox(
                          height: 16,
                        ),
                        MenuAsupanField(
                            label: 'Buah',
                            hint: 'Apel',
                            hintM: listSatuanMakan[6],
                            list: listSatuanMakan,
                            mainController: buah,
                            countController: buahCount,
                            measurementController: buahMeasure),
                        const SizedBox(
                          height: 16,
                        ),
                        MenuAsupanField(
                            label: 'Minuman',
                            hint: 'Susu',
                            hintM: listSatuanMinuman[0],
                            list: listSatuanMinuman,
                            mainController: minuman,
                            countController: minumanCount,
                            measurementController: minumanMeasure),
                        Padding(
                          padding: EdgeInsets.only(
                              bottom:
                                  MediaQuery.of(context).viewInsets.bottom / 2),
                        )
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Visibility(
                        visible: menuMakan.idmenu != null,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              menuMakan = RekomendasiMenuMakan();
                              clearField();
                            });
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10)),
                            child: const Icon(Icons.clear),
                          ),
                        )),
                    Expanded(
                      child: Container(
                        height: 50,
                        margin: const EdgeInsets.all(10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              backgroundColor: const Color(0xff3f7af6)),
                          onPressed: () {
                            if (menuMakan.idmenu == null) {
                              addRekomendasiMenu();
                            } else {
                              updateRekomendasiMenu();
                            }
                          },
                          child: Center(
                            child: Text(
                              menuMakan.idmenu == null ? 'Simpan' : 'Update',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ),
                    listRekomendasuMenuMakan(context),
                  ],
                ),
              ]),
            );
          },
        ),
      ),
    );
  }

  GestureDetector listRekomendasuMenuMakan(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: Colors.white,
          useSafeArea: true,
          isDismissible: true,
          elevation: 3,
          isScrollControlled: true,
          builder: (context) {
            return SizedBox(
              height: 420,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                                child: Text(
                              'List Menu Rekomendasi',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            )),
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.close)),
                            )
                          ],
                        )),
                  ),
                  SizedBox(
                    height: 350,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: listRekomendasi.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            title: Text(FormatTgl().setTgl(
                                listRekomendasi[index].tanggal.toString())),
                            subtitle: Text(menu[int.parse(listRekomendasi[index]
                                    .menumakan
                                    .toString()) -
                                1]),
                            onTap: () {
                              setState(() {
                                clearField();
                                menuMakan = listRekomendasi[index];
                                setMenuMakan();
                              });
                              Navigator.pop(context);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10)),
        child: const Icon(Icons.list),
      ),
    );
  }

  Column jamMakanPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Jam Makan',
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          focusNode: timeFocus,
          readOnly: true,
          controller: jamMakan,
          decoration: InputDecoration(
            suffixIcon: const Icon(
              Icons.av_timer_sharp,
              color: Colors.grey,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onTap: () async {
            timeFocus.unfocus();
            showModalBottomSheet(
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              backgroundColor: Colors.white,
              useSafeArea: true,
              isDismissible: true,
              //isScrollControlled: true,
              builder: (BuildContext builder) {
                return SizedBox(
                  height: 280,
                  child: Column(
                    children: [
                      Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(
                                    child: Text(
                                  'Pilih Jam Pengingat',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: const Icon(Icons.close)),
                                )
                              ],
                            )),
                      ),
                      SizedBox(
                        height: 230,
                        child: Column(
                          children: [
                            Expanded(
                              child: CupertinoDatePicker(
                                mode: CupertinoDatePickerMode.time,
                                use24hFormat: true,
                                initialDateTime: DateTime.now(),
                                onDateTimeChanged: (DateTime newDateTime) {
                                  setState(() {
                                    String formattedTime =
                                        DateFormat.Hm().format(newDateTime);
                                    jamMakan.text = formattedTime;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Padding backbutton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 20,
        width: 20,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffe2e2e2)),
          color: const Color(0xffffffff),
          borderRadius: BorderRadius.circular(8),
        ),
        child: IconButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const Navigationbar(index: 0)),
            );
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.grey,
            size: 16,
          ),
        ),
      ),
    );
  }
}
