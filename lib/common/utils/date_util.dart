import 'dart:io';

import 'package:intl/intl.dart';

String timeFormated(String? time) {
  final DateTime now =
      time == null ? DateTime.now().toLocal() : DateTime.parse(time).toLocal();
  final DateFormat formatter =
      DateFormat('yyyy-MM-dd HH:mm:ss', Platform.localeName);
  return formatter.format(now);
}

/// Formattazione data DateTime in data Stringa
String dataFormattata(DateTime data) {
  return DateFormat('dd/MM/yyyy').format(data);
}

/// Formattazione data DateTime in data-ora Stringa
String dataOraFormattata(DateTime data) {
  return DateFormat('dd/MM/yyyy HH:mm').format(data);
}

/// Conversione data da formato CARL a formato DateTime corretto
DateTime? conversioneDataCarlFormatDateTime(String? data) {
  return data == null
      ? null
      : DateTime.parse(data).toLocal().add(
            Duration(
              hours: int.parse(
                data.substring(data.length - 6).substring(0, 3),
              ),
              minutes: int.parse(
                data.substring(data.length - 6).substring(4),
              ),
            ),
          );
}

/// Conversione data DateTime in stringa con formato CARL
String? conversioneDataDateTimeCarlFormat(DateTime? data) {
  return data == null
      ? null
      : "${data.add(const Duration(hours: -2)).toIso8601String().substring(0, 23)}+00:00";
}
