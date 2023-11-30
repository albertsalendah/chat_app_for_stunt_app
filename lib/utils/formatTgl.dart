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
      return DateFormat('dd MMMM yyyy').format(date);
    } else {
      return '';
    }
  }

  String formatSpecialDate(String? inputDate) {
    if (inputDate == null || inputDate.isEmpty) {
      return "Invalid date"; // You can customize the error message as needed
    }

    try {
      DateTime dateTime = DateTime.parse(inputDate);

      // Get today's date at midnight
      DateTime today = DateTime.now();
      today = DateTime(today.year, today.month, today.day);

      // Format dates as MM/dd/yyyy
      DateFormat formatter = DateFormat('MM/dd/yyyy');
      String formattedDateTime = formatter.format(dateTime);
      String formattedToday = formatter.format(today);

      // Check if the date is today
      if (formattedDateTime == formattedToday) {
        return "Today";
      }

      // Check if the date is yesterday
      DateTime yesterday = today.subtract(const Duration(days: 1));
      String formattedYesterday = formatter.format(yesterday);
      if (formattedDateTime == formattedYesterday) {
        return "Yesterday";
      }

      return formattedDateTime; // Other dates
    } catch (e) {
      return "Invalid date"; // Handle parsing errors (e.g., invalid format)
    }
  }
}
