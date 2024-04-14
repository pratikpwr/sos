import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DateTimeExtenion on DateTime {
  String get ddMMMyy {
    return DateFormat('dd MMM, yy').format(this);
  }

  String get ddMMyyyy {
    return DateFormat('dd/MM/yyyy').format(this);
  }

  String get ddMMM {
    return DateFormat('dd MMM').format(this);
  }

  String get hhmmA {
    return DateFormat('hh:mm a').format(this);
  }

  String get formattedDateTime {
    return DateFormat('dd MMM yyyy hh:mm a').format(this);
  }

  DateTime onlyDate() {
    return DateTime(year, month, day);
  }

  DateTime onlyTime() {
    return DateTime(0, 0, 0, hour, minute);
  }
}


extension TimeOfDayExtenion on TimeOfDay {
  String get hhmmA {
    return DateFormat('hh:mm a').format(DateTime(0, 0, 0, hour, minute));
  }
}