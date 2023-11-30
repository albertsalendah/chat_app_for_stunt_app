// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:chat_app_for_stunt_app/custom_widget/contact_card.dart';
import 'package:chat_app_for_stunt_app/models/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Bloc/KonsultasiBloc/konsultasiBloc.dart';
import '../../Bloc/KonsultasiBloc/konsultasiState.dart';

class DaftarKontak extends StatefulWidget {
  const DaftarKontak({super.key});

  @override
  State<DaftarKontak> createState() => _DaftarKontakState();
}

class _DaftarKontakState extends State<DaftarKontak> {
  List<Contact> daftarKontak = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchData();
    });
  }

  Future<void> fetchData() async {
    await context.read<KonsultasiBloc>().getDaftarKontak();
  }

  List<Contact> get searchfilteredList {
    return daftarKontak.where((item) {
      bool mNama = true;
      if (searchController.text.isNotEmpty) {
        mNama = item.nama
            .toString()
            .toLowerCase()
            .contains(searchController.text.toLowerCase());
      }
      return mNama;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.grey),
            title: Text(
              'Daftar Kontak',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16 * fem,
                  color: Colors.black),
            ),
            leading: backbutton(fem, context),
          ),
          body: BlocBuilder<KonsultasiBloc, KonsultasiState>(
            builder: (context, state) {
              if (state is DataErrorState) {
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
              } else if (state is DaftarKontakLoaded) {
                daftarKontak = state.daftarkontak;
                daftarKontak.sort((a, b) {
                  return a.nama
                      .toString()
                      .toLowerCase()
                      .compareTo(b.nama.toString().toLowerCase());
                });
                log('List : ${daftarKontak.length}');
              }
              if (daftarKontak.isEmpty) {
                return const Center(child: Text('Belum Ada Data'));
              }
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        setState(() {});
                      },
                      decoration: const InputDecoration(
                        labelText: 'Search...',
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 160,
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await fetchData();
                      },
                      child: ListView.builder(
                        itemCount: searchfilteredList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                                ContactCard(contact: searchfilteredList[index]),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
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
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.grey,
              size: 16 * fem,
            )),
      ),
    );
  }
}
