// ignore_for_file: non_constant_identifier_names

import 'package:intl/intl.dart';

class FormatTgl {
  String format_tanggal(String? tgl) {
    if (tgl != null && tgl != '0000-00-00') {
      DateTime date = DateFormat('dd MMMM yyyy').parse(tgl);
      return DateFormat('yyyy-MM-dd').format(date);
    } else {
      return '';
    }
  }

  String setTgl(String? tgl) {
    if (tgl != null && tgl != '0000-00-00') {
      DateTime date = DateFormat('yyyy-MM-dd').parse(tgl);
      return DateFormat('dd MMMM yyyy')
          .format(date);
    } else {
      return '';
    }
  }
}
