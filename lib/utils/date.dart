import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatDate(String createdAt, BuildContext context) {
  // Mendapatkan tanggal dari string createdAt
  DateTime parsedDate = DateTime.parse(createdAt);

  // Membuat formatter sesuai dengan lokal pengguna
  DateFormat formatter = Localizations.localeOf(context).languageCode == 'en'
      ? DateFormat('MMMM dd, yyyy')
      : DateFormat('dd MMMM yyyy');

  // Memformat tanggal sesuai dengan formatter yang telah dibuat
  String formattedDate = formatter.format(parsedDate);

  return formattedDate;
}
